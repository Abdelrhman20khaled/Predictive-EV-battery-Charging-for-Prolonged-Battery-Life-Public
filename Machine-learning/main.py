import time
from uart_handler import receive_uart_data
from model_predictor import predict_soc_soh
from mqtt_publisher import publish_to_mqtt
from battery_gui import BatteryGUI

if __name__ == "__main__":
    while True:
        print("Waiting for UART data...")
        cycle, voltage, current = receive_uart_data()

        if None in (cycle, voltage, current):
            print("Failed to get valid UART data. Retrying in 3 seconds...")
            time.sleep(3)
            continue

        soc, soh = predict_soc_soh(cycle, voltage, current)

        print(f"\nPredicted SOC: {soc:.2f}%")
        print(f"Predicted SOH: {soh:.2f}%")

        publish_to_mqtt(soc, soh)

        print("Launching GUI. Close it to fetch new UART data.")
        app = BatteryGUI(soc, soh)
        app.mainloop()
