const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const fs = require('fs');
const path = require('path');

const router = express.Router();
const usersFile = path.join(__dirname, 'data', 'users.json');
const secret = process.env.JWT_SECRET || 'nouveau-local-secret';

function ensureStore() {
  const dir = path.dirname(usersFile);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
  if (!fs.existsSync(usersFile)) {
    fs.writeFileSync(usersFile, '[]', 'utf8');
  }
}

function readUsers() {
  ensureStore();
  try {
    return JSON.parse(fs.readFileSync(usersFile, 'utf8'));
  } catch (error) {
    return [];
  }
}

function writeUsers(users) {
  ensureStore();
  fs.writeFileSync(usersFile, JSON.stringify(users, null, 2), 'utf8');
}

function normalizeEmail(email) {
  return (email || '').trim().toLowerCase();
}

function createToken(user) {
  return jwt.sign(
    {
      sub: user.id,
      name: user.name,
      email: user.email,
      provider: user.provider,
    },
    secret,
    { expiresIn: '7d' },
  );
}

router.post('/register', async (req, res) => {
  try {
    const { name, email, password, provider = 'local' } = req.body;
    if (!email || !password) {
      return res.status(400).json({ error: 'email and password are required' });
    }

    const users = readUsers();
    const normalizedEmail = normalizeEmail(email);
    const existingUser = users.find((user) => user.email === normalizedEmail);
    if (existingUser && provider === 'google') {
      existingUser.name = (name || existingUser.name || normalizedEmail.split('@')[0]).trim();
      existingUser.provider = 'google';
      existingUser.lastLoginAt = new Date().toISOString();
      writeUsers(users);
      return res.json({
        token: createToken(existingUser),
        user: {
          id: existingUser.id,
          name: existingUser.name,
          email: existingUser.email,
          provider: existingUser.provider,
        },
      });
    }
    if (existingUser) {
      return res.status(409).json({ error: 'A user with this email already exists' });
    }

    const passwordHash = await bcrypt.hash(password, 10);
    const user = {
      id: `user_${Date.now()}`,
      name: (name || normalizedEmail.split('@')[0]).trim(),
      email: normalizedEmail,
      passwordHash,
      provider,
      createdAt: new Date().toISOString(),
      lastLoginAt: new Date().toISOString(),
    };
    users.push(user);
    writeUsers(users);

    res.status(201).json({
      token: createToken(user),
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        provider: user.provider,
      },
    });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

router.post('/login', async (req, res) => {
  try {
    const { email, password, provider = 'local' } = req.body;
    if (!email || !password) {
      return res.status(400).json({ error: 'email and password are required' });
    }

    const users = readUsers();
    const normalizedEmail = normalizeEmail(email);
    const user = users.find((entry) => entry.email === normalizedEmail);
    if (!user && provider === 'google') {
      const googleUser = {
        id: `user_${Date.now()}`,
        name: normalizedEmail.split('@')[0],
        email: normalizedEmail,
        passwordHash: await bcrypt.hash(password, 10),
        provider: 'google',
        createdAt: new Date().toISOString(),
        lastLoginAt: new Date().toISOString(),
      };
      users.push(googleUser);
      writeUsers(users);
      return res.json({
        token: createToken(googleUser),
        user: {
          id: googleUser.id,
          name: googleUser.name,
          email: googleUser.email,
          provider: googleUser.provider,
        },
      });
    }
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const isValid = provider === 'google' || await bcrypt.compare(password, user.passwordHash);
    if (!isValid) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    user.lastLoginAt = new Date().toISOString();
    user.provider = provider;
    writeUsers(users);

    res.json({
      token: createToken(user),
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        provider: user.provider,
      },
    });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

router.post('/persons', async (req, res) => {
  try {
    const { name, email, token, provider } = req.body;
    if (!name || !email || !token) {
      return res.status(400).json({ error: 'name, email and token are required' });
    }

    const users = readUsers();
    const normalizedEmail = normalizeEmail(email);
    const existingIndex = users.findIndex((entry) => entry.email === normalizedEmail);
    if (existingIndex >= 0) {
      users[existingIndex].name = name;
      users[existingIndex].token = token;
      users[existingIndex].provider = provider || users[existingIndex].provider;
      users[existingIndex].lastLoginAt = new Date().toISOString();
    } else {
      users.push({
        id: `user_${Date.now()}`,
        name,
        email: normalizedEmail,
        token,
        provider: provider || 'local',
        createdAt: new Date().toISOString(),
        lastLoginAt: new Date().toISOString(),
      });
    }

    writeUsers(users);
    res.status(201).json({ name, email: normalizedEmail, token, provider });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;
