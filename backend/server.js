require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./db');
const productRoutes = require('./products');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (_req, res) => res.json({ status: 'ok', service: 'nouveau_app backend' }));
app.use('/api/products', productRoutes);

const PORT = process.env.PORT || 5000;

connectDB().then(() => {
  app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
});
