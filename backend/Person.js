const mongoose = require('mongoose');

const PersonSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true, index: true },
    token: { type: String, required: true },
    provider: { type: String, default: 'firebase-jwt' },
    lastLoginAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Person', PersonSchema);
