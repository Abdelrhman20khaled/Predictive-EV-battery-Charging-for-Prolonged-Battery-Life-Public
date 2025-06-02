#include "wifi_supabase.h"
#include <WiFi.h>          // For WiFi connectivity
#include <HTTPClient.h>    // For making HTTP requests
#include <ArduinoJson.h>   // For creating JSON payloads

// Function to setup and connect to WiFi
void setupWiFi() {
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to WiFi...");
    int retries = 0;
    while (WiFi.status() != WL_CONNECTED && retries < 20) { // Limit retries
        delay(500);
        Serial.print(".");
        retries++;
    }
    if (WiFi.status() == WL_CONNECTED) {
        Serial.println(" Connected!");
        Serial.print("IP Address: ");
        Serial.println(WiFi.localIP());
    } else {
        Serial.println(" Failed to connect to WiFi.");
        // Handle connection failure if necessary (e.g., retry later, enter low power mode)
    }
}

// Function to check WiFi connection and reconnect if necessary
void ensureWiFiConnected() {
    if (WiFi.status() != WL_CONNECTED) {
        Serial.println("WiFi disconnected. Reconnecting...");
        WiFi.disconnect(); // Ensure clean state before reconnecting
        WiFi.reconnect();
        int retries = 0;
        while (WiFi.status() != WL_CONNECTED && retries < 10) { // Limit reconnection retries
            delay(500);
            Serial.print(".");
            retries++;
        }
        if (WiFi.status() == WL_CONNECTED) {
            Serial.println(" Reconnected!");
        } else {
            Serial.println(" Failed to reconnect.");
        }
    }
}

// Function to insert charging start and end times into Supabase
void insertChargeRecordToSupabase(const String& startTime, const String& endTime) {
    ensureWiFiConnected(); // Make sure we are connected before trying to send data
    if (WiFi.status() != WL_CONNECTED) {
        Serial.println("Cannot insert data: WiFi not connected.");
        return;
    }

    HTTPClient http;
    String supabaseUrl = String(SUPABASE_URL) + "/rest/v1/" + String(SUPABASE_TABLE);
    String authHeader = "Bearer " + String(SUPABASE_API_KEY);

    Serial.print("Connecting to Supabase: ");
    Serial.println(supabaseUrl);

    if (http.begin(supabaseUrl)) { // Use String object for URL
        http.addHeader("Content-Type", "application/json");
        http.addHeader("apikey", SUPABASE_API_KEY);
        http.addHeader("Authorization", authHeader);

        // Create JSON payload
        StaticJsonDocument<200> jsonDoc; // Adjust size if needed
        // Assuming your table columns are named "start_time" and "end_time"
        // *** Adjust column names if they are different in your Supabase table ***
        jsonDoc["start_time"] = startTime;
        jsonDoc["end_time"] = endTime;

        String jsonData;
        serializeJson(jsonDoc, jsonData);

        Serial.print("Sending JSON: ");
        Serial.println(jsonData);

        // Send POST request
        int httpResponseCode = http.POST(jsonData);

        // Check response
        if (httpResponseCode > 0) {
            Serial.print("Supabase HTTP Response code: ");
            Serial.println(httpResponseCode);
            String responsePayload = http.getString();
            Serial.println("Supabase Response payload: " + responsePayload);
            if (httpResponseCode == 201) { // 201 Created is typical for successful Supabase insert
                Serial.println("Data inserted successfully!");
            } else {
                Serial.println("Failed to insert data (non-201 response).");
            }
        } else {
            Serial.print("HTTP POST request failed. Error: ");
            Serial.println(http.errorToString(httpResponseCode).c_str());
        }

        http.end(); // Free resources
    } else {
        Serial.println("HTTPClient failed to begin connection.");
    }
}

