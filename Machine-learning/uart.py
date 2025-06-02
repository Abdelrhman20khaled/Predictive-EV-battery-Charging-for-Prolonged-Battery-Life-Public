import serial

PORT = '/dev/serial0'
BAUD_RATE = 9600

def receive_uart_data():
    values = []
    try:
        with serial.Serial(PORT, BAUD_RATE, timeout=1) as ser:
            print(f"Listening on {PORT} at {BAUD_RATE} baud...")
            while len(values) < 3:
                if ser.in_waiting > 0:
                    line = ser.readline().decode('utf-8', errors='replace').strip()
                    if line:
                        print(f"Received: {line}")
                        values.append(line)
        cycle = int(values[0])
        voltage = float(values[1])
        current = float(values[2])
        return cycle, voltage, current
    except Exception as e:
        print(f"❌ Error receiving UART data: {e}")
        return None, None, None
