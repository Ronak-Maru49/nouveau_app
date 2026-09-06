const express = require('express');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const mongoose = require('mongoose');
const Order = require('./Order');

const router = express.Router();
const ordersFile = path.join(__dirname, 'data', 'orders.json');
const razorpaySecret = () => process.env.RAZORPAY_SECRET || process.env.RAZORPAY_KEY_SECRET;

let RazorpayClient = null;
try {
  RazorpayClient = require('razorpay');
} catch (_) {
  RazorpayClient = null;
}

function ensureStore() {
  const dir = path.dirname(ordersFile);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
  if (!fs.existsSync(ordersFile)) {
    fs.writeFileSync(ordersFile, '[]', 'utf8');
  }
}

function readOrders() {
  ensureStore();
  try {
    return JSON.parse(fs.readFileSync(ordersFile, 'utf8'));
  } catch (_) {
    return [];
  }
}

function writeOrders(orders) {
  ensureStore();
  fs.writeFileSync(ordersFile, JSON.stringify(orders, null, 2), 'utf8');
}

function normalizeOrderPayload(payload) {
  const items = Array.isArray(payload.items) ? payload.items : [];
  const subtotal = Number(payload.subtotal ?? items.reduce((sum, item) => sum + Number(item.total ?? item.price ?? 0) * Number(item.quantity ?? 1), 0));
  const shippingFee = Number(payload.shippingFee ?? 0);
  const discount = Number(payload.discount ?? 0);
  const totalAmount = Number(payload.totalAmount ?? subtotal + shippingFee - discount);

  return {
    orderNumber: payload.orderNumber || `NOU-${Date.now()}`,
    customer: {
      name: payload.customer?.name || 'Guest',
      email: payload.customer?.email || 'guest@nouveau.local',
      phone: payload.customer?.phone || '',
    },
    shipping: {
      address: payload.shipping?.address || '',
      city: payload.shipping?.city || '',
      state: payload.shipping?.state || '',
      pincode: payload.shipping?.pincode || '',
      notes: payload.shipping?.notes || payload.notes || '',
    },
    items: items.map((item) => ({
      productId: item.productId || '',
      title: item.title || 'Product',
      size: item.size || 'Free Size',
      quantity: Number(item.quantity || 1),
      price: Number(item.price || 0),
      total: Number(item.total || Number(item.price || 0) * Number(item.quantity || 1)),
    })),
    subtotal,
    shippingFee,
    discount,
    totalAmount,
    payment: {
      method: payload.payment?.method || 'razorpay',
      status: payload.payment?.status || 'pending',
      provider: 'razorpay',
      orderId: '',
      paymentId: '',
      signature: '',
      amount: 0,
      currency: 'INR',
      keyId: '',
      message: '',
    },
    paymentTarget: payload.paymentTarget || '8238713571',
    ownerEmail: payload.ownerEmail || 'maruroank5@gmail.com',
    notes: payload.notes || '',
    status: payload.status || 'placed',
  };
}

async function persistOrder(order) {
  if (process.env.MONGODB_URI && mongoose.connection.readyState === 1) {
    const saved = await Order.findByIdAndUpdate(order._id, order, { new: true, runValidators: false });
    return saved || order;
  }

  const orders = readOrders();
  const index = orders.findIndex((entry) => entry._id === order._id);
  if (index >= 0) {
    orders[index] = order;
  } else {
    orders.unshift(order);
  }
  writeOrders(orders);
  return order;
}

router.get('/', async (_req, res) => {
  try {
    if (process.env.MONGODB_URI && mongoose.connection.readyState === 1) {
      const orders = await Order.find().sort({ createdAt: -1 });
      return res.json(orders);
    }

    return res.json(readOrders());
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
});

router.post('/', async (req, res) => {
  try {
    const normalized = normalizeOrderPayload(req.body);

    if (normalized.payment?.method === 'razorpay' &&
        (!process.env.RAZORPAY_KEY_ID || !razorpaySecret())) {
      return res.status(503).json({
        error: 'Razorpay is not configured. Set RAZORPAY_KEY_ID and RAZORPAY_KEY_SECRET in backend/.env.',
      });
    }

    let order;

    if (process.env.MONGODB_URI && mongoose.connection.readyState === 1) {
      order = await Order.create(normalized);
    } else {
      order = { ...normalized, _id: `ord_${Date.now()}`, createdAt: new Date().toISOString(), updatedAt: new Date().toISOString() };
      const orders = readOrders();
      orders.unshift(order);
      writeOrders(orders);
    }

    if (RazorpayClient && normalized.payment?.method === 'razorpay') {
      try {
        const razorpayOrder = await new RazorpayClient({
          key_id: process.env.RAZORPAY_KEY_ID,
          key_secret: razorpaySecret(),
        }).orders.create({
          amount: Math.round(normalized.totalAmount * 100),
          currency: 'INR',
          receipt: order._id,
          notes: {
            customerName: normalized.customer.name,
            email: normalized.customer.email,
            orderNumber: normalized.orderNumber,
          },
        });

        order.payment = {
          ...order.payment,
          provider: 'razorpay',
          orderId: razorpayOrder.id,
          amount: razorpayOrder.amount,
          currency: razorpayOrder.currency,
          keyId: process.env.RAZORPAY_KEY_ID,
          status: 'pending',
        };

        await persistOrder(order);
      } catch (error) {
        order.payment = {
          ...order.payment,
          message: error.message,
          status: 'pending',
        };
        await persistOrder(order);
      }
    }

    await sendOrderEmail(order);
    return res.status(201).json(order);
  } catch (err) {
    return res.status(400).json({ error: err.message });
  }
});

router.patch('/:id/payment', async (req, res) => {
  try {
    const {
      paymentId = '',
      orderId = '',
      signature = '',
      method = 'razorpay',
    } = req.body;

    if (method !== 'razorpay' || !paymentId || !orderId || !signature) {
      return res.status(400).json({ error: 'Incomplete Razorpay payment details' });
    }

    if (!razorpaySecret()) {
      return res.status(503).json({ error: 'Razorpay is not configured on the server' });
    }

    if (process.env.MONGODB_URI && mongoose.connection.readyState === 1) {
      const order = await Order.findById(req.params.id);
      if (!order) {
        return res.status(404).json({ error: 'Order not found' });
      }

      const verificationError = verifyRazorpayPayment(order, paymentId, orderId, signature);
      if (verificationError) {
        return res.status(400).json({ error: verificationError });
      }

      order.payment = {
        ...order.payment,
        status: 'paid',
        paymentId,
        orderId: orderId || order.payment?.orderId || '',
        signature,
        method,
      };
      order.status = 'paid';
      await order.save();
      return res.json(order);
    }

    const orders = readOrders();
    const existing = orders.find((entry) => entry._id === req.params.id);
    if (!existing) {
      return res.status(404).json({ error: 'Order not found' });
    }

    const verificationError = verifyRazorpayPayment(existing, paymentId, orderId, signature);
    if (verificationError) {
      return res.status(400).json({ error: verificationError });
    }

    existing.payment = {
      ...existing.payment,
      status: 'paid',
      paymentId,
      orderId: orderId || existing.payment?.orderId || '',
      signature,
      method,
    };
    existing.status = 'paid';
    writeOrders(orders);
    return res.json(existing);
  } catch (err) {
    return res.status(400).json({ error: err.message });
  }
});

function verifyRazorpayPayment(order, paymentId, orderId, signature) {
  if (order.payment?.orderId !== orderId) {
    return 'Razorpay order does not match this order';
  }

  const expectedSignature = crypto
    .createHmac('sha256', razorpaySecret())
    .update(`${orderId}|${paymentId}`)
    .digest('hex');
  const expected = Buffer.from(expectedSignature, 'utf8');
  const received = Buffer.from(signature, 'utf8');

  if (expected.length !== received.length || !crypto.timingSafeEqual(expected, received)) {
    return 'Invalid Razorpay payment signature';
  }

  return null;
}

async function sendOrderEmail(order) {
  if (!process.env.SMTP_HOST || !process.env.SMTP_USER || !process.env.SMTP_PASS) return;

  try {
    const nodemailer = require('nodemailer');
    const transporter = nodemailer.createTransport({
      host: process.env.SMTP_HOST,
      port: Number(process.env.SMTP_PORT || 587),
      secure: process.env.SMTP_SECURE === 'true',
      auth: { user: process.env.SMTP_USER, pass: process.env.SMTP_PASS },
    });

    const items = order.items
      .map((item) => `${item.title} | ${item.size} | Qty ${item.quantity} | Rs ${item.total}`)
      .join('\n');
    const text = `Nouveau order bill\n\nCustomer: ${order.customer.name}\nEmail: ${order.customer.email}\nPhone: ${order.customer.phone || '-'}\n\n${items}\n\nSubtotal: Rs ${order.subtotal}\nTotal: Rs ${order.totalAmount || order.subtotal}\nPayment: ${order.paymentTarget}`;

    await transporter.sendMail({
      from: process.env.SMTP_FROM || process.env.SMTP_USER,
      to: order.ownerEmail,
      cc: order.customer.email,
      subject: `Nouveau order ${order.orderNumber || order._id}`,
      text,
    });
  } catch (err) {
    console.warn('Order saved, but email delivery failed:', err.message);
  }
}

module.exports = router;
