-- Users Table
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY, -- Unique ID for each user
    Username VARCHAR(255) NOT NULL, -- Username for login
    Email VARCHAR(255) NOT NULL UNIQUE -- Email for login
);

-- LED Patterns (Presets) Table
CREATE TABLE LEDPatterns (
    PatternID SERIAL PRIMARY KEY, -- Unique ID for each pattern
    UserID INT, -- User who created the pattern
    PatternName VARCHAR(255) NOT NULL, -- User Friendly Name of the pattern
    PatternData JSONB NOT NULL, -- Pattern will most likely be stored as JSON, this is a placeholder
    CreationDate TIMESTAMP NOT NULL, -- Date the pattern was created
    ModifiedDate TIMESTAMP NOT NULL, -- Date the pattern was last modified
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE -- Reference to the user who created the pattern
);

-- Devices Table
CREATE TABLE Devices (
    DeviceID VARCHAR(255) PRIMARY KEY, -- Unique ID for each device
    UserID INT, -- User who owns the device
    DeviceName VARCHAR(255) NOT NULL, -- User Friendly Name of the device
    DeviceLocation VARCHAR(255), -- Location of the device
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE -- Reference to the user who owns the device
);
