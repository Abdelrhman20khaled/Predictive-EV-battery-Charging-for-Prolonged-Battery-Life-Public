#include "rtc_handler.h"
#include <Wire.h> // Needed for I2C communication with RTC

// Define the RTC object (declared as extern in the header)
RTC_DS3231 rtc;

// Function to initialize the RTC
void setupRTC() {
    // Initialize I2C communication (using default ESP32 pins SDA=21, SCL=22 if not specified otherwise)
    // Wire.begin(I2C_SDA_PIN, I2C_SCL_PIN); // Uncomment and define pins in config.h if using non-default I2C pins
    Wire.begin(); 

    if (!rtc.begin()) {
        Serial.println("Couldn't find RTC! Check wiring.");
        // Depending on the application, you might want to halt or use millis() as a fallback
        // For now, we just print an error and continue.
    } else {
        Serial.println("RTC initialized.");
        // Optional: Check if RTC lost power and reset the time if needed
        if (rtc.lostPower()) {
            Serial.println("RTC lost power, let's set the time!");
            // rtc.adjust(DateTime(F(__DATE__), F(__TIME__))); // Uncomment to set time to compile time
        }
    }
}

// Function to get the current date and time as a formatted string
String getRTCDateTimeString() {
    if (!rtc.begin()) { // Check if RTC is still accessible
        return "RTC Error";
    }
    DateTime now = rtc.now();
    
    // Apply time zone adjustment from config.h
    int hourLocal = (now.hour() + TIMEZONE_OFFSET_HOURS);
    // Handle day change due to timezone offset
    // This is a simplified adjustment, doesn't handle DST or complex date rollovers perfectly
    int dayOffset = hourLocal / 24;
    hourLocal = hourLocal % 24;
    if (hourLocal < 0) { // Handle negative offset resulting in previous day
        hourLocal += 24;
        dayOffset = -1; // Adjust day backward
    }
    // Note: DateTime object doesn't directly support adding days easily. 
    // For simplicity, we are only adjusting the hour here. 
    // A more robust solution would involve Unixtime or a more complex date calculation.

    char buffer[25]; // Increased buffer size slightly
    // Format: YYYY-MM-DD HH:MM:SS
    snprintf(buffer, sizeof(buffer), "%04d-%02d-%02d %02d:%02d:%02d", 
             now.year(), now.month(), now.day() + dayOffset, // Apply simple day offset (may need refinement)
             hourLocal, now.minute(), now.second());

    return String(buffer);
}

