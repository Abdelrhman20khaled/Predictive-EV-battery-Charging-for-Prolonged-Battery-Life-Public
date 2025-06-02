import tkinter as tk
from tkinter import ttk

class BatteryGUI(tk.Tk):
    def __init__(self, soc, soh):
        super().__init__()
        self.title("Smart Battery Monitor")
        self.geometry("1024x600")
        self.configure(bg="white")
        self.soc = soc
        self.soh = soh
        self.set_indicator_colors()
        self.device_status = {
            "AC": True, "Headlights": True, "Seats Heaters": True,
            "Seat Massage": True, "Ambient Light": True, "Salon Lights": True,
            "Dashboard": True, "Other Unnecessary Device": True
        }
        self.create_widgets()

    def set_indicator_colors(self):
        self.soc_indicator = "red" if self.soc < 30 else "orange" if self.soc < 50 else "green"
        self.soh_indicator = "red" if self.soh < 30 else "orange" if self.soh < 50 else "green"

    def create_widgets(self):
        ttk.Label(self, text="Smart Battery System", font=("Helvetica", 18), background="white").pack(pady=10)
        main_frame = tk.Frame(self, bg="white")
        main_frame.pack(fill="both", expand=True, padx=20, pady=10)

        self.canvas = tk.Canvas(main_frame, width=600, height=300, bg="white", highlightthickness=0)
        self.canvas.grid(row=0, column=0, sticky="w")

        self.canvas.create_line(590, 20, 590, 280, fill="gray", width=2)

        self.suggestion_frame = tk.Frame(main_frame, bg="white")
        self.suggestion_frame.grid(row=0, column=1, padx=30, sticky="n")

        self.draw_gauge(180, 150, 100, self.soc, "SOC")
        self.draw_gauge(420, 150, 100, self.soh, "SOH")

        status_text = "Battery status: good" if self.soc >= 50 else "Battery status: low"
        tk.Label(self, text=status_text, font=("Helvetica", 14), fg="blue", bg="white").pack(pady=10)

        tk.Label(self.suggestion_frame, text="Suggestions", font=("Helvetica", 14, "underline"), fg="black", bg="white").pack(pady=10)
        suggestions = self.get_suggestions(self.soc)
        for item in suggestions:
            tk.Label(self.suggestion_frame, text=f"• {item}", font=("Helvetica", 12), fg="black", bg="white", anchor="w", justify="left").pack(anchor="w")

        footer = tk.Label(self, text="Smart prediction system", font=("Georgia", 12, "italic"), fg="gray", bg="white")
        footer.place(relx=1.0, rely=1.0, anchor="se", x=-10, y=-10)

    def draw_gauge(self, x, y, r, percent, label):
        start_angle = -135
        total_extent = 270
        fill_extent = total_extent * percent / 100

        self.canvas.create_arc(x - r, y - r, x + r, y + r, start=start_angle, extent=total_extent,
                               style="arc", outline="lightgray", width=12)
        self.canvas.create_arc(x - r, y - r, x + r, y + r, start=start_angle, extent=fill_extent,
                               style="arc", outline="red", width=12)

        self.canvas.create_text(x, y, text=label, fill="black", font=("Helvetica", 14, "bold"))
        self.canvas.create_text(x, y + 30, text=f"{percent:.2f}%", fill="red", font=("Helvetica", 16, "bold"))

    def get_suggestions(self, soc):
        levels = [
            (70, []),
            (60, ["Seats Heaters"]),
            (50, ["AC", "Headlights", "Seats Heaters"]),
            (40, ["AC", "Headlights", "Seats Heaters", "Seat Massage", "Ambient Light"]),
            (30, ["AC", "Headlights", "Seats Heaters", "Seat Massage", "Ambient Light", "Salon Lights"]),
            (0, ["AC", "Headlights", "Seats Heaters", "Seat Massage", "Ambient Light", "Salon Lights", "Dashboard", "Other Unnecessary Device"])
        ]
        for threshold, devices in levels:
            if soc >= threshold:
                return [f"Close {device}" for device in devices if self.device_status.get(device, False)]
        return []
