#ifndef RTC_HANDLER_H
#define RTC_HANDLER_H

#include <Arduino.h>
#include "RTClib.h"
#include "config.h" // Include configuration for timezone offset

// RTC object (defined in rtc_handler.cpp)
extern RTC_DS3231 rtc;

// Function prototypes
void setupRTC();
String getRTCDateTimeString(); // Gets formatted date/time string with timezone adjustment

#endif // RTC_HANDLER_H

