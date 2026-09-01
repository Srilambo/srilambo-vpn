const express = require('express');
const router = express.Router();
const protect = require('../middleware/auth.middleware');

// POST /api/sessions — log a VPN session for analytics
router.post('/', protect, async (req, res) => {
  // Simplified — just acknowledge for now
  // In production, store in a Session model for usage analytics
  res.status(201).json({ success: true, message: 'Session recorded.' });
});

module.exports = router;
