const express = require('express');
const router = express.Router();
const Driver = require('../models/Driver');

// Get all active driver locations
router.get('/', async (req, res) => {
  try {
    const activeDrivers = await Driver.find({
      isActive: true,
      location: { $ne: null },
      status: 'approved'
    }).select('name vehicleNumber location vehicleType');
    
    // Format response for map display
    const locations = activeDrivers.map(driver => ({
      id: driver._id,
      name: driver.name,
      vehicleNumber: driver.vehicleNumber,
      vehicleType: driver.vehicleType,
      longitude: driver.location.coordinates[0],
      latitude: driver.location.coordinates[1]
    }));
    
    res.json(locations);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router; 