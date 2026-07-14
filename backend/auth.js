const express = require('express');
const Person = require('./Person');

const router = express.Router();

router.post('/persons', async (req, res) => {
  try {
    const { name, email, token, provider } = req.body;
    if (!name || !email || !token) {
      return res.status(400).json({ error: 'name, email and token are required' });
    }

    const person = await Person.findOneAndUpdate(
      { email },
      { name, email, token, provider, lastLoginAt: new Date() },
      { new: true, upsert: true, runValidators: true }
    );
    res.status(201).json(person);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

module.exports = router;
