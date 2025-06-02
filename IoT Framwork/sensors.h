#ifndef SENSORS_H
#define SENSORS_H

#include <Arduino.h>
#include <SPI.h>
#include "config.h" // Include configuration for pin definitions

// SPIClass object (defined in sensors.cpp)
extern SPIClass spi;

// Function prototypes
void setupSensors();
float readCurrentSensor();
float readVoltageSensor();
float readTemperatureSPI(); // Placeholder

#endif // SENSORS_H

