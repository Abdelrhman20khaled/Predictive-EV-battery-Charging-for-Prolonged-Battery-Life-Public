#ifndef BATTERY_MONITOR_H
#define BATTERY_MONITOR_H


#include <Arduino.h>
#include "config.h" // Include configuration for pin and timing
#include <EEPROM.h>
// Function prototypes
void setupBatteryMonitor();
void checkBatteryStatus(); // Main function to be called in the loop

#endif // BATTERY_MONITOR_H

