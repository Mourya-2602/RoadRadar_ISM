const express = require('express');
const router = express.Router();
const Driver = require('../models/Driver');

// Driver Registration
router.post('/register', async (req, res) => {
  try {
    const { name, mobileNumber, vehicleNumber, vehicleType, password } = req.body;
    
    // Check if driver already exists
    const existingDriver = await Driver.findOne({ 
      $or: [{ mobileNumber }, { vehicleNumber }] 
    });
    
    if (existingDriver) {
      return res.status(400).json({ 
        message: 'Driver with this mobile number or vehicle number already exists' 
      });
    }

    // Create new driver
    const newDriver = new Driver({
      name,
      mobileNumber,
      vehicleNumber,
      vehicleType,
      password
    });

    await newDriver.save();

    res.status(201).json({
      message: 'Driver registered successfully! Waiting for admin approval',
      driverId: newDriver._id
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Driver Login
router.post('/login', async (req, res) => {
  try {
    const { mobileNumber, password } = req.body;
    
    // Find driver
    const driver = await Driver.findOne({ mobileNumber });
    
    if (!driver) {
      return res.status(404).json({ message: 'Driver not found' });
    }
    
    // Check password
    const isMatch = await driver.comparePassword(password);
    
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }
    
    // Check if approved
    if (driver.status == 'pending') {
      return res.status(403).json({ 
        message: `Your account is ${driver.status}. Please wait for admin approval.` 
      });
    }

    // No need to check for rejected status anymore since rejected drivers are deleted
    
    // Update last login
    driver.lastLogin = new Date();
    await driver.save();
    
    // Return driver info
    res.json({
      message: 'Login successful',
      driver: {
        id: driver._id,
        name: driver.name,
        mobileNumber: driver.mobileNumber,
        vehicleNumber: driver.vehicleNumber,
        vehicleType: driver.vehicleType,
        isActive: driver.isActive,
        status: driver.status
      }
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Update Driver Location
router.put('/location', async (req, res) => {
  try {
    const { driverId, longitude, latitude } = req.body;
    
    if (!driverId || !longitude || !latitude) {
      return res.status(400).json({ message: 'Missing required fields' });
    }
    
    const driver = await Driver.findById(driverId);
    
    if (!driver) {
      return res.status(404).json({ message: 'Driver not found' });
    }
    
    // Update location
    driver.location = {
      type: 'Point',
      coordinates: [longitude, latitude]
    };
    
    await driver.save();
    
    res.json({ message: 'Location updated successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Toggle Active Status
router.put('/status', async (req, res) => {
  try {
    const { driverId, isActive } = req.body;
    
    const driver = await Driver.findById(driverId);
    
    if (!driver) {
      return res.status(404).json({ message: 'Driver not found' });
    }
    
    driver.isActive = isActive;
    
    // If turning inactive, clear location
    if (!isActive) {
      driver.location = null;
    }
    
    await driver.save();
    
    res.json({ 
      message: `Driver status set to ${isActive ? 'active' : 'inactive'}`,
      isActive
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get Driver Profile
router.get('/:id', async (req, res) => {
  try {
    const driver = await Driver.findById(req.params.id);
    
    if (!driver) {
      return res.status(404).json({ message: 'Driver not found' });
    }
    
    res.json({
      id: driver._id,
      name: driver.name,
      mobileNumber: driver.mobileNumber,
      vehicleNumber: driver.vehicleNumber,
      vehicleType: driver.vehicleType,
      status: driver.status,
      isActive: driver.isActive,
      registeredAt: driver.registeredAt,
      lastLogin: driver.lastLogin
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Update Driver Profile
router.put('/:id', async (req, res) => {
  try {
    const { name, vehicleNumber, vehicleType } = req.body;
    
    const driver = await Driver.findById(req.params.id);
    
    if (!driver) {
      return res.status(404).json({ message: 'Driver not found' });
    }
    
    // Check if vehicle number is being changed and already exists
    if (vehicleNumber && vehicleNumber !== driver.vehicleNumber) {
      const existingVehicle = await Driver.findOne({ vehicleNumber });
      if (existingVehicle) {
        return res.status(400).json({ message: 'Vehicle number already in use' });
      }
    }
    
    // Update fields
    if (name) driver.name = name;
    if (vehicleNumber) driver.vehicleNumber = vehicleNumber;
    if (vehicleType) driver.vehicleType = vehicleType;
    
    await driver.save();
    
    res.json({
      message: 'Profile updated successfully',
      driver: {
        id: driver._id,
        name: driver.name,
        mobileNumber: driver.mobileNumber,
        vehicleNumber: driver.vehicleNumber,
        vehicleType: driver.vehicleType,
        status: driver.status,
        isActive: driver.isActive
      }
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router; 