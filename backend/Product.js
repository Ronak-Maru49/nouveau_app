const mongoose = require('mongoose');

const ProductSizeSchema = new mongoose.Schema(
  {
    size: { type: String, required: true },
    quantity: { type: Number, required: true, default: 0 },
  },
  { _id: false }
);

const ProductSchema = new mongoose.Schema(
  {
    title: { type: String, required: true, default: 'Nouveau Signature Piece' },
    price: { type: Number, required: true },
    originalPrice: { type: Number, required: true },
    category: { type: String, required: true, default: 'Nouveau Collection' },
    subcategory: { type: String, default: 'Womenswear' },
    gender: { type: String, default: 'Women' },
    images: { type: [String], default: ['/product1.jpeg'] },
    sizes: { type: [ProductSizeSchema], default: [] },
    rating: { type: Number, default: 0 },
    reviews: { type: Number, default: 0 },
    stock: { type: Number, default: 0 },
    description: { type: String, default: '' },
    isNew: { type: Boolean, default: false },
    discount: { type: Number, default: 0 },
    material: { type: String },
  },
  { timestamps: true }
);

// Flutter's Product.fromJson reads `_id`, which Mongo already provides
// natively, so no extra transform is needed — toJSON's default output
// (with _id as a string) matches the shape the app expects.
ProductSchema.set('toJSON', {
  transform: (_doc, ret) => {
    ret._id = ret._id.toString();
    delete ret.__v;
    return ret;
  },
});

module.exports = mongoose.model('Product', ProductSchema);
