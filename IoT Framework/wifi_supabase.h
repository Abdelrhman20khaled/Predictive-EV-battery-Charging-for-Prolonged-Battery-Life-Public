#ifndef WIFI_SUPABASE_H
#define WIFI_SUPABASE_H

#include <Arduino.h>
#include "config.h" // Include configuration for WiFi/Supabase credentials

// Function prototypes
void setupWiFi();
void ensureWiFiConnected(); // Function to check and reconnect WiFi if needed
void insertChargeRecordToSupabase(const String& startTime, const String& endTime);

#endif // WIFI_SUPABASE_H

