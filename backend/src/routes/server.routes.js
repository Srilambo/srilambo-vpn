const express = require('express');
const router = express.Router();
const { getServers, getServerConfig } = require('../controllers/server.controller');
const protect = require('../middleware/auth.middleware');

// Public — list servers (auth not required, but premium ones need check on config)
router.get('/', getServers);

// Protected — get WireGuard config for specific server
router.get('/:id/config', protect, getServerConfig);

module.exports = router;
