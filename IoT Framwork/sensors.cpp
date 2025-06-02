#include "sensors.h"

// Define Analog sensor pins using config.h
const int currentSensorPin = CURRENT_SENSOR_PIN; // Now uses ADC1
const int voltageSensorPin = VOLTAGE_SENSOR_PIN;

// Define SPI pins for Temperature Sensor using config.h
const int spiSckPin = SPI_SCK_PIN;
const int spiMisoPin = SPI_MISO_PIN;
const int spiCsPin = SPI_CS_PIN;
const int spiMosiPin = SPI_MOSI_PIN;

// Initialize SPIClass object for VSPI
SPIClass spi = SPIClass(VSPI);

// Function to initialize sensor pins and SPI
void setupSensors() {
  // Initialize SPI for the temperature sensor
  pinMode(spiCsPin, OUTPUT); // Set CS pin as output
  digitalWrite(spiCsPin, HIGH); // Deselect SPI device initially
  // Initialize SPI with specified pins (SCK, MISO, MOSI, CS)
  spi.begin(spiSckPin, spiMisoPin, spiMosiPin, -1); // SCK, MISO, MOSI, CS (-1 means CS is controlled manually)
  Serial.println("SPI initialized.");

  // Configure Analog pins (optional, analogRead configures them on first call)
  pinMode(currentSensorPin, INPUT);
  pinMode(voltageSensorPin, INPUT);
  Serial.println("Analog pins configured.");
}

// Function to read Current Sensor
float readCurrentSensor() {
  int rawCurrent = analogRead(currentSensorPin);
  // Convert raw reading to actual current (example conversion, adjust as needed)
  float current = rawCurrent * (3.3 / 4095.0); // Example: Simple voltage reading
  return current;
}

// Function to read Voltage Sensor
float readVoltageSensor() {
  int rawVoltage = analogRead(voltageSensorPin);
  // Convert raw reading to actual voltage (example conversion, adjust as needed)
  float voltage = rawVoltage * (3.3 / 4095.0); // Example: Simple voltage reading
  return voltage;
}

// Placeholder function for reading temperature via SPI
// *** YOU NEED TO IMPLEMENT THIS based on your specific temperature sensor ***
// It should return the temperature value (e.g., float)
float readTemperatureSPI() {
  float temperature = 0.0;
  
  // Example structure (replace with your sensor's library calls):
  spi.beginTransaction(SPISettings(1000000, MSBFIRST, SPI_MODE0)); // Example settings (1MHz, MSB first, Mode 0)
  digitalWrite(spiCsPin, LOW); // Select SPI device
  
  // --- Add SPI communication code here --- 
  // Example: Send command byte
  // spi.transfer(0x01); 
  // Example: Read data bytes
  // byte highByte = spi.transfer(0x00);
  // byte lowByte = spi.transfer(0x00);
  // temperature = ((highByte << 8) | lowByte) * 0.0625; // Example calculation
  // --- End of SPI communication code --- 
  
digitalWrite(spiCsPin, HIGH); // Deselect SPI device
  spi.endTransaction();

  // For now, return a dummy value
  temperature = 25.5; // Replace with actual reading
  return temperature;
}

