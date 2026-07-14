const express = require('express');
const Order = require('./Order');

const router = express.Router();

router.get('/', async (_req, res) => {
  try {
    const orders = await Order.find().sort({ createdAt: -1 });
    res.json(orders);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/', async (req, res) => {
  try {
    const order = await Order.create(req.body);
    await sendOrderEmail(order);
    res.status(201).json(order);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

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
    const text = `Nouveau order bill\n\nCustomer: ${order.customer.name}\nEmail: ${order.customer.email}\n\n${items}\n\nSubtotal: Rs ${order.subtotal}\nPayment: ${order.paymentTarget}`;

    await transporter.sendMail({
      from: process.env.SMTP_FROM || process.env.SMTP_USER,
      to: order.ownerEmail,
      cc: order.customer.email,
      subject: `Nouveau order ${order._id}`,
      text,
    });
  } catch (err) {
    console.warn('Order saved, but email delivery failed:', err.message);
  }
}

module.exports = router;
