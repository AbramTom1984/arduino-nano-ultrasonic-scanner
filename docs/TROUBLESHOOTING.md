# Troubleshooting

## No incoming measurements

- Confirm that the sketch is uploaded and the board is connected with a USB data cable.
- Check that the selected serial port matches the board.
- Keep both programs at `115200` baud.
- Allow for the five-second startup delay.
- Close Serial Monitor before running Processing.

## Port busy or cannot be opened

Close other applications using the board. Check the port list printed by Processing. The default `/dev/ttyUSB0` is specific to the prototype setup; your device may have a different name. If the error explicitly says permission denied, check your operating system's serial-device permissions rather than assuming the code is at fault.

The supplied photographs show the IDEs running as superuser. That is a record of the build environment, not a requirement of this project.

## All readings are -1.0

Check VCC, GND, TRIG on D7, and ECHO on D8. Test with a stationary box placed directly in front of the sensor. A missing echo is not proof that the area is clear.

## Servo resets, jitters, or stops

Check the separate servo supply, voltage, current limiting, and common ground. Verify that wires and the USB cable do not obstruct motion. Disconnect power immediately if the mechanism binds.

## Sectors become gray

Gray is intentional for invalid, missing, or stale measurements. Measurements expire after 12 seconds. If you slow the scan considerably, increase `STALE_MS` to suit the new cycle time.

## Arial font message

The prototype photo shows Processing reporting that Arial is unavailable and another font will be used. The program requests Arial in `createFont("Arial", 16)`. To choose a font explicitly, use the name of an installed font; `printArray(PFont.list());` lists available names in Processing. This changes text appearance, not the serial protocol.

## Range changed but grid labels look wrong

The grid loop uses fixed 25 cm intervals up to 100 cm. Update that loop when changing `DISPLAY_CM`.
