require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./db');
const authRoutes = require('./auth');
const orderRoutes = require('./orders');
const productRoutes = require('./products');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (_req, res) => res.json({ status: 'ok', service: 'nouveau_app backend' }));
app.get('/api/health', (_req, res) => res.json({
  status: 'ok',
  service: 'nouveau_app backend',
  database: process.env.MONGODB_URI ? 'configured' : 'local-auth-mode',
  razorpay: process.env.RAZORPAY_KEY_ID && (process.env.RAZORPAY_SECRET || process.env.RAZORPAY_KEY_SECRET)
    ? 'configured'
    : 'missing configuration',
}));
app.use('/api/auth', authRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/products', productRoutes);

const PORT = process.env.PORT || 5000;

if (!process.env.RAZORPAY_KEY_ID || !(process.env.RAZORPAY_SECRET || process.env.RAZORPAY_KEY_SECRET)) {
  console.warn('Razorpay is not configured. Set RAZORPAY_KEY_ID and RAZORPAY_KEY_SECRET in backend/.env.');
}

async function start() {
  if (process.env.MONGODB_URI) {
    try {
      await connectDB();
    } catch (error) {
      console.warn('MongoDB unavailable, continuing in local-auth mode:', error.message);
    }
  } else {
    console.log('MONGODB_URI not set; running in local-auth mode without MongoDB.');
  }

  app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
}

start();
