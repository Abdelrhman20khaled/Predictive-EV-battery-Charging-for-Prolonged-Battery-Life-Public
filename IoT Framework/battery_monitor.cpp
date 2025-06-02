#include "battery_monitor.h"
#include "rtc_handler.h"      // For getting timestamps
#include "wifi_supabase.h"  // For sending data to Supabase


// State variables for battery monitoring (static to keep scope limited to this file)
static bool previousState = HIGH; // Assume not charging initially (pull-up resistor)
static bool currentState;
static bool checking = false;
static unsigned long checkStartTime = 0;
static String chargeStartTime = "";
static String chargeEndTime = "";
static unsigned int cycleCount = EEPROM.read(EEPROM_CYCLE_COUNT_LOCATION);
// Function to initialize the battery monitor pin
void setupBatteryMonitor() {
    pinMode(BATTERY_STATUS_PIN, INPUT_PULLUP);
    previousState = digitalRead(BATTERY_STATUS_PIN); // Read initial state
    Serial.print("Battery Monitor initialized on pin ");
    Serial.print(BATTERY_STATUS_PIN);
    Serial.print(". Initial state: ");
    Serial.println(previousState == HIGH ? "Not Charging" : "Charging");
}

// Function to check the battery status and handle state changes
// This should be called repeatedly in the main loop
void checkBatteryStatus() {
    currentState = digitalRead(BATTERY_STATUS_PIN);

    // Detect potential state change (edge detection)
    if (currentState != previousState && !checking) {
        checking = true;
        checkStartTime = millis(); // Start the debounce timer
        // Serial.println("Potential state change detected, starting debounce timer..."); // Debug
    }

    // After debounce time, confirm the state change
    if (checking && millis() - checkStartTime >= BATTERY_DEBOUNCE_TIME) {
        // Re-read the pin state to confirm it's stable
        bool confirmedState = digitalRead(BATTERY_STATUS_PIN);
        
        if (confirmedState == currentState) { // State change is confirmed
            // Serial.print("State change confirmed: "); // Debug
            // Serial.println(currentState == HIGH ? "Not Charging" : "Charging"); // Debug

            previousState = currentState; // Update the stable state
            checking = false; // Reset checking flag

            if (currentState == LOW) { // LOW state indicates charging started (assuming active low signal)
                chargeStartTime = getRTCDateTimeString(); // Get timestamp from RTC module
                Serial.print("Charging started at: ");
                Serial.println(chargeStartTime);
                // Optionally log "Charging Started" event to Supabase immediately if needed
                // insertChargeRecordToSupabase(chargeStartTime, "Charging"); // Example

            } else if (currentState == HIGH) { // HIGH state indicates charging stopped
                chargeEndTime = getRTCDateTimeString(); // Get timestamp from RTC module
                Serial.print("Charging stopped at: ");
                Serial.println(chargeEndTime);

                // Insert the completed charge record into Supabase
                if (chargeStartTime != "") { // Ensure we have a start time
                    insertChargeRecordToSupabase(chargeStartTime, chargeEndTime);
                    chargeStartTime = ""; // Reset start time after logging
                    cycleCount ++;
                    EEPROM.writeUInt(EEPROM_CYCLE_COUNT_LOCATION,cycleCount);
                } else {
                    Serial.println("Error: Charging stopped but no start time recorded.");
                }
            }
        } else {
            // State bounced back during debounce period, reset checking
            // Serial.println("State change not confirmed (bounced), resetting debounce."); // Debug
            checking = false; 
        }
    }
}


