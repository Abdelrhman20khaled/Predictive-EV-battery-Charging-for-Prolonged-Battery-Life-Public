#ifndef UART_HANDLER_H
#define UART_HANDLER_H

#include <Arduino.h>
#include "config.h" // Include configuration for pin definitions

// Flag to indicate if data sending is requested
// Declared as extern, defined in uart_handler.cpp
extern volatile bool sendDataRequested;

// Function prototypes
void setupUART();
void IRAM_ATTR onSerial2Receive(); // Keep IRAM_ATTR for ISR
void sendSensorDataOverUART(); // Handles reading sensors and sending via UART

#endif // UART_HANDLER_H

