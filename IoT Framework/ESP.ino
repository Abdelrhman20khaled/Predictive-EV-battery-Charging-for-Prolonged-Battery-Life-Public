// Main sketch file for combined UART interrupt and Battery Monitoring project

#include "config.h"
#include "sensors.h"
#include "uart_handler.h"
#include "rtc_handler.h"
#include "wifi_supabase.h"
#include "battery_monitor.h"

void setup() {
  // Initialize Serial Monitor for debugging
  Serial.begin(SERIAL_MONITOR_BAUD_RATE);
  Serial.println("\n--- ESP32 Combined Project Initializing ---");

  // Initialize hardware components through their respective modules
  setupRTC();            // Initialize RTC first for accurate timestamps
  setupSensors();        // Initialize Analog and SPI sensors
  setupUART();           // Initialize UART2 and attach interrupt
  setupWiFi();           // Initialize WiFi connection
  setupBatteryMonitor(); // Initialize battery monitoring pin and state

  EEPROM.begin(1);
  Serial.println("--- Initialization Complete --- Waiting for events ---");
}

void loop() {
  // 1. Check for UART request to send sensor data
  if (sendDataRequested) {
    // Call the function from uart_handler to read sensors and send data
    sendSensorDataOverUART();

    // Reset the flag (managed within uart_handler, but good practice to clear here too if needed)
    noInterrupts(); // Temporarily disable interrupts for safe flag access
    sendDataRequested = false;
    interrupts(); // Re-enable interrupts
  }
  
  // 2. Check battery status (handles state changes and Supabase logging)
  checkBatteryStatus();

  // 3. Optional: Ensure WiFi stays connected (can be useful for long-running tasks)
  // ensureWiFiConnected(); // Note: Supabase function already checks connection before sending

  delay(10); 
}

