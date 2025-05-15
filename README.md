# Smart Battery Management System (SBMS) for Electric Vehicles 🚗🔋

This repository contains the complete implementation of our graduation project: a Smart Battery Management System (SBMS) designed to enhance electric vehicle (EV) battery performance, safety, and lifespan through predictive analytics, hardware integration, IoT, and mobile development.

## Project Overview

The SBMS project aims to solve key challenges in EV battery management by:

- Predicting **State of Charge (SoC)** and **State of Health (SoH)** using machine learning models.
- Designing a custom **power electronics board** with optimized voltage/current regulation and protection.
- Implementing an **IoT monitoring system** via ESP32 for real-time sensor data collection.
- Developing a **mobile application** to display battery health metrics and user alerts.

## Key Features

- **Hardware Design**: Buck converter with inductor-capacitor filtering, voltage regulators, and safety components.
- **ML-Based Battery Prediction**: Accurate SoC/SoH estimations based on real-world datasets and feature importance analysis.
- **IoT Integration**: Real-time monitoring using ESP32, sensors (ACS712, MAX6675), EEPROM, RTC, and cloud communication.
- **Mobile App**: Displays current charge, health status, and system alerts for user-friendly interaction.

## 📁 Repository Structure

```
/hardware           - Schematics, PCB design files, simulation results  
/ml_model           - Jupyter notebooks, trained models, dataset preprocessing  
/iot_firmware       - ESP32 firmware code (Arduino/PlatformIO)  
/mobile_app         - Flutter or Android app source code  
/documents          - Project report, presentation, and reference materials
```

## Tools & Technologies

- Python (ML), Scikit-learn, Pandas, Matplotlib  
- ESP32, Arduino IDE, C/C++  
- KiCad / EasyEDA for hardware design  
- Flutter / Android Studio for mobile app  
- Firebase / MQTT for data communication  

## Educational Purpose

> **Disclaimer:**  
> This project was developed as part of an undergraduate graduation project at Benha University, Faculty of Engineering (Shoubra). It is intended solely for **educational and demonstration purposes**. The system is a prototype and is not certified for commercial or safety-critical applications.

## Developers

- Mahmoud Mohamed Mahmoud  
- Abdelrahman Khaled Sobhi  
- Youssef Ashraf Abdel-Moez  
- Alaa Mohamed Mekawi  
- Karima Mahmoud Elnady  

## License

This repository is open-source and for Educational Purpose.
