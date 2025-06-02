#ifndef CONFIG_H
#define CONFIG_H

// --- WiFi Settings ---
#define WIFI_SSID "your-SSID"         // Replace with your WiFi SSID
#define WIFI_PASSWORD "your-PASSWORD" // Replace with your WiFi Password

// --- Supabase Settings ---
#define SUPABASE_URL "your-supabase-url" // Replace with your Supabase project URL
#define SUPABASE_API_KEY "your-api-key"    // Replace with your Supabase anon/public API key
#define SUPABASE_TABLE "your_table"       // Replace with your Supabase table name

// --- Pin Definitions ---
// Analog Sensors
#define CURRENT_SENSOR_PIN 34 // ADC1_CH6 (Changed from 12 to avoid WiFi conflict)
#define VOLTAGE_SENSOR_PIN 35 // ADC1_CH7

// SPI Temperature Sensor
#define SPI_SCK_PIN 18
#define SPI_MISO_PIN 5
#define SPI_CS_PIN 19
#define SPI_MOSI_PIN 23 // Standard MOSI pin for VSPI

// UART2
#define UART_RXD2 16
#define UART_TXD2 17

// Battery Monitor
#define BATTERY_STATUS_PIN 4 // GPIO pin to monitor charging status (INPUT_PULLUP)

// I2C for RTC (Defaults for ESP32: SDA=21, SCL=22)
// #define I2C_SDA_PIN 21 
// #define I2C_SCL_PIN 22

// --- Timing and Constants ---
#define UART_BAUD_RATE 9600
#define SERIAL_MONITOR_BAUD_RATE 115200
#define BATTERY_DEBOUNCE_TIME 10000 // 10 seconds wait time to confirm state change
#define TIMEZONE_OFFSET_HOURS 2     // Adjust based on your location (e.g., UTC+2)

// EEPROM 
#define EEPROM_SIZE 1
#define EEPROM_CYCLE_COUNT_LOCATION 0
#endif // CONFIG_H

