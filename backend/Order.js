const mongoose = require('mongoose');

const OrderItemSchema = new mongoose.Schema(
  {
    productId: { type: String, required: true },
    title: { type: String, required: true },
    size: { type: String, default: 'Free Size' },
    quantity: { type: Number, required: true, min: 1 },
    price: { type: Number, required: true },
    total: { type: Number, required: true },
  },
  { _id: false }
);

const OrderSchema = new mongoose.Schema(
  {
    customer: {
      name: { type: String, required: true },
      email: { type: String, required: true },
    },
    items: { type: [OrderItemSchema], required: true },
    subtotal: { type: Number, required: true },
    paymentTarget: { type: String, default: '8238713571' },
    ownerEmail: { type: String, default: 'maruroank5@gmail.com' },
    status: { type: String, default: 'placed' },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Order', OrderSchema);
