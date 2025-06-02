#include "uart_handler.h"
#include "sensors.h" // Needed for sensor reading functions
#include "config.h"  // For pin numbers and baud rate

// Define UART pins using config.h
const int RXD2 = UART_RXD2;
const int TXD2 = UART_TXD2;

// Define the flag (declared as extern in the header)
volatile bool sendDataRequested = false;

// Callback function for UART2 receive event
// This function is called when data is available to read on Serial2
// It runs in a high-priority task, keep it short and fast.
void IRAM_ATTR onSerial2Receive() {
  // Check if data is available
  while (Serial2.available() > 0) {
    char receivedChar = Serial2.read();
    if (receivedChar == 'R') {
      // Set the flag to signal the main loop to send data
      // Avoid doing complex operations or Serial prints inside this callback
      sendDataRequested = true;
    }
    // Ignore other characters
  }
}

// Function to initialize UART2 and attach interrupt
void setupUART() {
  // Initialize UART2 (Serial2) for communication
  Serial2.begin(UART_BAUD_RATE, SERIAL_8N1, RXD2, TXD2);
  Serial.print("Serial2 initialized at ");
  Serial.print(UART_BAUD_RATE);
  Serial.println(" baud.");

  // Attach the callback function to the UART2 receive event
  Serial2.onReceive(onSerial2Receive);
  Serial.println("Serial2 receive callback attached.");
}

// Function to read sensors and send data over UART
void sendSensorDataOverUART() {
    Serial.println("Reading sensors and sending data via UART...");

    // 1. Read Sensors using functions from sensors module
    float current = readCurrentSensor();
    float voltage = readVoltageSensor();
    float temperature = readTemperatureSPI(); // Call the placeholder function

    // 2. Format the data string
    String dataToSend = "Current:";
    dataToSend += String(current, 2); // Format float with 2 decimal places
    dataToSend += ",Voltage:";
    dataToSend += String(voltage, 2);
    dataToSend += ",Temp:";
    dataToSend += String(temperature, 2);

    // 3. Send the data string over UART2
    Serial2.println(dataToSend);
    Serial.print("Data sent via Serial2: ");
    Serial.println(dataToSend);
}

