require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const mqtt = require('mqtt');
const app = express();
const port = 3000;

// Create a connection pool to the PostgreSQL database
const pool = new Pool({
    user: 'postgres',
    host: '10.96.96.3',
    database: 'postgres2',
    password: 'admin',
    port: 5432,
  });


// Connect to the MQTT broker
const mqttClient = mqtt.connect('mqtt://34.145.206.196:1883');

mqttClient.on('connect', () => {
    console.log('Connected to MQTT broker');
  });

app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).send('API is up and running!');
});

// Get all users
app.get('/users', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM Users');
        res.status(200).json(result.rows);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Get a specific user by UserID
app.get('/users/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('SELECT * FROM Users WHERE UserID = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(404).send('User not found');
        }
        res.status(200).json(result.rows[0]);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Get a specific user by email
app.post('/user/email', async (req, res) => {
    try {
        const { email } = req.body;
        const result = await pool.query('SELECT * FROM Users WHERE Email = $1', [email]);
        if (result.rows.length === 0) {
            return res.status(404).send('User not found');
        }
        res.status(200).json(result.rows[0]);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Add a new user
app.post('/users', async (req, res) => {
    try {
        const { username, email } = req.body;
        const result = await pool.query('INSERT INTO Users (Username, Email) VALUES ($1, $2) RETURNING *', [username, email]);
        res.status(201).json(result.rows[0]);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Get devices for a user, requires UserID
app.get('/users/:id/devices', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('SELECT * FROM Users WHERE UserID = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(401).send('Unauthorized'); // 401 Unauthorized if the user is not found
        }
        const devices = await pool.query('SELECT * FROM Devices WHERE UserID = $1', [id]);
        res.status(200).json(devices.rows);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Add a new device for a user, requires UserID and DeviceID
app.post('/users/:id/devices', async (req, res) => {
    try {
        const { id } = req.params; // UserID
        const { deviceID, deviceName, deviceLocation } = req.body;
        const result = await pool.query('SELECT * FROM Users WHERE UserID = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(401).send('Unauthorized'); // 401 Unauthorized if the user is not found
        }
        const newDevice = await pool.query('INSERT INTO Devices (DeviceID, UserID, DeviceName, DeviceLocation) VALUES ($1, $2, $3, $4) RETURNING *', [deviceID, id, deviceName, deviceLocation]);
        res.status(201).json(newDevice.rows[0]);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

//Delete a device for a user, requires UserID, DeviceID
app.delete('/users/:id/devices/:deviceID', async (req, res) => {
    try {
        const { id, deviceID } = req.params; // UserID, DeviceID
        const result = await pool.query('SELECT * FROM Users WHERE UserID = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(401).send('Unauthorized'); // 401 Unauthorized if the user is not found
        }
        const deletedDevice = await pool.query('DELETE FROM Devices WHERE DeviceID = $1 AND UserID = $2 RETURNING *', [deviceID, id]);
        if (deletedDevice.rows.length === 0) {
            return res.status(404).send('Device not found');
        }
        res.status(200).json(deletedDevice.rows[0]);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Modify the name of a device for a user, requires UserID, DeviceID
app.put('/users/:id/devices/:deviceID/name', async (req, res) => {
    try {
        const { id, deviceID } = req.params; // UserID, DeviceID
        const { deviceName } = req.body;
        const result = await pool.query('SELECT * FROM Users WHERE UserID = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(401).send('Unauthorized'); // 401 Unauthorized if the user is not found
        }
        const updatedDevice = await pool.query('UPDATE Devices SET DeviceName = $1 WHERE DeviceID = $2 AND UserID = $3 RETURNING *', [deviceName, deviceID, id]);
        if (updatedDevice.rows.length === 0) {
            return res.status(404).send('Device not found');
        }
        res.status(200).json(updatedDevice.rows[0]);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Modify the location of a device for a user, requires UserID, DeviceID
app.put('/users/:id/devices/:deviceID/location', async (req, res) => {
    try {
        const { id, deviceID } = req.params; // UserID, DeviceID
        const { deviceLocation } = req.body;
        const result = await pool.query('SELECT * FROM Users WHERE UserID = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(401).send('Unauthorized'); // 401 Unauthorized if the user is not found
        }
        const updatedDevice = await pool.query('UPDATE Devices SET DeviceLocation = $1 WHERE DeviceID = $2 AND UserID = $3 RETURNING *', [deviceLocation, deviceID, id]);
        if (updatedDevice.rows.length === 0) {
            return res.status(404).send('Device not found');
        }
        res.status(200).json(updatedDevice.rows[0]);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Create a new pattern
app.post('/users/:id/patterns', async (req, res) => {
    try {
        const { id } = req.params; // UserID
        const { patternName, position1, position2, iconColor, interval } = req.body;
        const patternType = "User"; // Set patternType to "User"
        const patternData = { position1, position2, patternType, iconColor, interval }; // Combine position1, position2, patternType, iconColor, and interval into patternData
        const creationDate = new Date();
        const modifiedDate = new Date();

        // Check if user exists
        const userResult = await pool.query('SELECT * FROM Users WHERE UserID = $1', [id]);
        if (userResult.rows.length === 0) {
            return res.status(401).send('Unauthorized'); // 401 Unauthorized if the user is not found
        }

        // Insert new pattern into the database
        const newPattern = await pool.query(
            'INSERT INTO LEDPatterns (UserID, PatternName, PatternData, CreationDate, ModifiedDate) VALUES ($1, $2, $3, $4, $5) RETURNING *',
            [id, patternName, JSON.stringify(patternData), creationDate, modifiedDate]
        );

        // console.log(patternData);

        res.status(201).json(newPattern.rows[0]); // 201 Created
    } catch (err) {
        res.status(500).send(err.message);
    }
});

//Delete all patterns for a user, requires UserID TEMPORARY
app.delete('/users/:id/patterns', async (req, res) => {
    try {
        const { id } = req.params; // UserID
        const result = await pool.query('SELECT * FROM Users WHERE UserID = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(401).send('Unauthorized'); // 401 Unauthorized if the user is not found
        }
        const deletedPatterns = await pool.query('DELETE FROM LEDPatterns WHERE UserID = $1 RETURNING *', [id]);
        res.status(200).json(deletedPatterns.rows);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

//get all patterns for a user
app.get('/users/:id/patterns', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('SELECT * FROM Users WHERE UserID = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(401).send('Unauthorized'); // 401 Unauthorized if the user is not found
        }
        const patterns = await pool.query('SELECT * FROM LEDPatterns WHERE UserID = $1', [id]);
        res.status(200).json(patterns.rows);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

//Delete a pattern for a user, requires UserID, PatternID
app.delete('/users/:id/patterns/:patternID', async (req, res) => {
    try {
        const { id, patternID } = req.params; // UserID, PatternID
        const result = await pool.query('SELECT * FROM Users WHERE UserID = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(401).send('Unauthorized'); // 401 Unauthorized if the user is not found
        }
        const deletedPattern = await pool.query('DELETE FROM LEDPatterns WHERE PatternID = $1 AND UserID = $2 RETURNING *', [patternID, id]);
        if (deletedPattern.rows.length === 0) {
            return res.status(404).send('Pattern not found');
        }
        res.status(200).json(deletedPattern.rows[0]);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

//Route which takes a JSON object with an array of RGB values, and a deviceID
//Connects over MQTT to the broker,
app.post('/publish/:deviceID', async (req, res) => {
    const { deviceID } = req.params;
    const command = req.body.command; // Assuming command is sent in the request body
  
    // Check for the presence of the device in the database before publishing
    const deviceCheckResult = await pool.query('SELECT * FROM Devices WHERE DeviceID = $1', [deviceID]);
    if (deviceCheckResult.rows.length === 0) {
      return res.status(404).send('Device not found');
    }
  
    mqttClient.publish(deviceID, command, (err) => {
      if (err) {
        return res.status(500).send('Failed to publish message');
      }
      res.status(200).send('Message published');
    });
  });

// Route for setting color
app.post('/devices/:deviceID/color', async (req, res) => {
    try {
        const { deviceID } = req.params;
        const { color } = req.body;
        
        // Check for the presence of the device in the database before publishing
        const deviceCheckResult = await pool.query('SELECT * FROM Devices WHERE DeviceID = $1', [deviceID]);
        if (deviceCheckResult.rows.length === 0) {
            return res.status(404).send('Device not found');
        }
        
        mqttClient.publish(`${deviceID}/color`, color, (err) => {
            if (err) {
                return res.status(500).send('Failed to publish message');
            }
            res.status(200).send('Message published');
        });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Route for setting power
app.post('/devices/:deviceID/power', async (req, res) => {
    try {
        const { deviceID } = req.params;
        const { power } = req.body;
        
        // Check for the presence of the device in the database before publishing
        const deviceCheckResult = await pool.query('SELECT * FROM Devices WHERE DeviceID = $1', [deviceID]);
        if (deviceCheckResult.rows.length === 0) {
            return res.status(404).send('Device not found');
        }
        
        mqttClient.publish(`${deviceID}/power`, power, (err) => {
            if (err) {
                return res.status(500).send('Failed to publish message');
            }
            res.status(200).send('Message published');
        });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Route for setting brightness
app.post('/devices/:deviceID/brightness', async (req, res) => {
    try {
        const { deviceID } = req.params;
        const { brightness } = req.body;
        
        // Check for the presence of the device in the database before publishing
        const deviceCheckResult = await pool.query('SELECT * FROM Devices WHERE DeviceID = $1', [deviceID]);
        if (deviceCheckResult.rows.length === 0) {
            return res.status(404).send('Device not found');
        }
        
        mqttClient.publish(`${deviceID}/brightness`, brightness, (err) => {
            if (err) {
                return res.status(500).send('Failed to publish message');
            }
            res.status(200).send('Message published');
        });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Route for setting effect
app.post('/devices/:deviceID/effect', async (req, res) => {
    try {
        const { deviceID } = req.params;
        const { effect } = req.body;
        
        // Check for the presence of the device in the database before publishing
        const deviceCheckResult = await pool.query('SELECT * FROM Devices WHERE DeviceID = $1', [deviceID]);
        if (deviceCheckResult.rows.length === 0) {
            return res.status(404).send('Device not found');
        }
        
        mqttClient.publish(`${deviceID}/effect`, effect, (err) => {
            if (err) {
                return res.status(500).send('Failed to publish message');
            }
            res.status(200).send('Message published');
        });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Route for setting a pattern
app.post('/devices/:deviceID/pattern', async (req, res) => {
    try {
        const { deviceID } = req.params; // Device ID from the URL
        // const { pattern } = req.body; // Pattern details from the request body
        const pattern = req.body; // Pattern details from the request body
        
        // Check for the presence of the device in the database before publishing
        const deviceCheckResult = await pool.query('SELECT * FROM Devices WHERE DeviceID = $1', [deviceID]);
        if (deviceCheckResult.rows.length === 0) {
            return res.status(404).send('Device not found');
        }
        
        // Publish the pattern configuration to the MQTT topic for the device
        const patternTopic = `${deviceID}/pattern`;
        mqttClient.publish(patternTopic, JSON.stringify(pattern), (err) => {
            if (err) {
                return res.status(500).send('Failed to publish pattern');
            }
            res.status(200).send('Pattern set successfully');
        });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

app.listen(port, () => {
    console.log(`LuminaSync API running on http://localhost:${port}`);
});
