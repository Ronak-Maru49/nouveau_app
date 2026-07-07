require('dotenv').config();
const connectDB = require('./db');
const Product = require('./Product');

// A small sample drawn from lib/models/seed_products.dart, reshaped to the
// Mongo schema (sizes as {size, quantity} pairs instead of plain strings).
const sampleProducts = [
  {
    title: 'Off White Maxi',
    price: 1396,
    originalPrice: 1800,
    category: 'Indian Ethnic Wear',
    subcategory: 'Maxi',
    gender: 'Women',
    images: ['/ethnic1.jpeg'],
    sizes: [
      { size: 'L', quantity: 10 },
      { size: 'XL', quantity: 10 },
    ],
    rating: 4.5,
    reviews: 12,
    stock: 20,
    isNew: true,
    discount: 22,
    description:
      'Beautiful Off White Maxi in Pure Cotton. Lightweight and comfortable, perfect for festive and casual wear.',
  },
  {
    title: '3 Piece Off Shoulder with Inner',
    price: 4042,
    originalPrice: 5000,
    category: 'Indian Ethnic Wear',
    subcategory: 'Set',
    gender: 'Women',
    images: ['/ethnic2.jpeg'],
    sizes: [{ size: 'Free Size', quantity: 15 }],
    rating: 4.8,
    reviews: 8,
    stock: 15,
    isNew: true,
    discount: 19,
    description:
      'Elegant 3 Piece Off Shoulder with Inner in Silk. Perfect for parties and festive occasions.',
  },
  {
    title: 'Black Embellished Sequin Jumpsuit',
    price: 3300,
    originalPrice: 3300,
    category: 'Indian Western Wear',
    subcategory: 'Jumpsuit',
    gender: 'Women',
    images: ['/western2.jpeg'],
    sizes: [
      { size: 'S', quantity: 3 },
      { size: 'M', quantity: 3 },
      { size: 'L', quantity: 2 },
      { size: 'XL', quantity: 2 },
    ],
    rating: 0,
    reviews: 0,
    stock: 10,
    isNew: true,
    discount: 0,
    description:
      'Stunning black wide-leg jumpsuit with intricate sequin and bead embellishment on the bodice.',
  },
];

async function run() {
  await connectDB();
  await Product.deleteMany({});
  await Product.insertMany(sampleProducts);
  console.log(`Seeded ${sampleProducts.length} products.`);
  process.exit(0);
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});

