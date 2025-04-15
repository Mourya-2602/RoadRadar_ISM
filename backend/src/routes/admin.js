const express = require('express');
const router = express.Router();
const Driver = require('../models/Driver');

// Admin authentication middleware
const adminAuth = (req, res, next) => {
  const { adminPin } = req.headers;
  
  // Check admin PIN - in a real app, use a more secure method
  if (adminPin !== process.env.ADMIN_PIN) {
    return res.status(401).json({ message: 'Unauthorized' });
  }
  
  next();
};

// Get all drivers
router.get('/drivers', adminAuth, async (req, res) => {
  try {
    const drivers = await Driver.find().select('-password');
    res.json(drivers);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get pending driver requests
router.get('/pending', adminAuth, async (req, res) => {
  try {
    const pendingDrivers = await Driver.find({ status: 'pending' }).select('-password');
    res.json(pendingDrivers);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get active drivers
router.get('/active', adminAuth, async (req, res) => {
  try {
    const activeDrivers = await Driver.find({ isActive: true }).select('-password');
    res.json(activeDrivers);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Approve driver
router.put('/approve/:id', adminAuth, async (req, res) => {
  try {
    const driver = await Driver.findById(req.params.id);
    
    if (!driver) {
      return res.status(404).json({ message: 'Driver not found' });
    }
    
    driver.status = 'approved';
    await driver.save();
    
    res.json({ message: 'Driver approved successfully', driver });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Reject driver
router.put('/reject/:id', adminAuth, async (req, res) => {
  try {
    const driver = await Driver.findById(req.params.id);
    
    if (!driver) {
      return res.status(404).json({ message: 'Driver not found' });
    }
    
    // Delete the driver instead of changing the status
    await Driver.findByIdAndDelete(req.params.id);
    
    res.json({ message: 'Driver rejected and deleted', success: true });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Delete driver
router.delete('/drivers/:id', adminAuth, async (req, res) => {
  try {
    const driver = await Driver.findById(req.params.id);
    
    if (!driver) {
      return res.status(404).json({ message: 'Driver not found' });
    }
    
    await Driver.findByIdAndDelete(req.params.id);
    
    res.json({ message: 'Driver deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router; 