# Wiring and mechanical assembly

## Connection diagram

```text
COMPUTER
  | USB
  v
ARDUINO NANO
  +-- 5V ----------------- HC-SR04 VCC
  +-- GND ---------------- HC-SR04 GND
  +-- D7 ----------------- HC-SR04 TRIG
  +-- D8 ----------------- HC-SR04 ECHO
  +-- D9 ----------------- MG90S signal
  +-- GND --------+------- External supply negative
                  +------- MG90S ground

EXTERNAL SUPPLY +5.0 V ---- MG90S positive
```

## Power checklist

- Disconnect power before changing connections.
- Power the Nano through USB and the HC-SR04 from Nano 5V.
- Use a separate regulated 5.0 V supply for the servo.
- Connect Nano GND and external supply negative together.
- Do not connect external supply positive to Nano 5V in this arrangement.
- Check the supply voltage before attaching the servo. Never apply 12 V.
- An initial current limit of approximately 1 A was selected for this prototype. Monitor the supply and avoid mechanical stalls.
- Check your servo wiring rather than relying only on color.

| Servo connection | Typical color |
|---|---|
| Positive | Red |
| Ground | Brown or black |
| Signal | Orange, yellow, or white |

## Mechanical alignment

1. Secure the servo to a stable base.
2. Initially leave the sensor bracket off the servo horn.
3. Start the sketch and allow the servo to reach its commanded 90° position.
4. Disconnect power, then attach the horn and bracket with the sensor facing forward.
5. Leave a loose loop of wiring and check the full movement for obstructions.
6. Restart and observe the first complete sweep.

Do not force a powered servo shaft by hand. Reduce the angular range if the mechanism binds. In this build the breadboard and Nano move with the sensor, so allow the USB cable to move freely too.

![Servo and sensor assembly](images/servo-sensor-assembly.jpg)

![Breadboard connections](images/breadboard-wiring.jpg)
