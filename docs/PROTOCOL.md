# Serial protocol

## Transport

- Baud rate: `115200`.
- Plain-text records.
- Arduino `Serial.println()` produces a line ending; Processing reads up to `\n` and trims whitespace.
- No header, checksum, or acknowledgement is implemented.

## Record format

```text
angle,distance_cm
```

| Field | Meaning |
|---|---|
| `angle` | Integer commanded servo position in degrees |
| `distance_cm` | Distance formatted to one decimal place, or `-1.0` |

Examples:

```text
30,74.2
33,73.8
36,42.1
39,-1.0
```

The firmware returns `-1.0` for a pulse timeout or a calculated distance outside 2–400 cm. These numeric acceptance limits are software checks, not a promise of reliable detection throughout the entire interval.

## Measurement calculation

The sketch sends a 10 microsecond trigger pulse, waits up to 30000 microseconds for an echo pulse, and calculates `distance_cm = duration_microseconds / 58.0`.

Each commanded position is followed by a 90 ms settling delay before measurement. Startup commands 90° and pauses for five seconds.

## Visualization behavior

Malformed records, non-finite distances, and angles outside the configured display limits are ignored. Sectors expire after 12000 ms without an update. A negative distance is shown as an invalid reading. The sweep line is hidden if no accepted record has arrived for two seconds; the last numeric readout remains visible with a waiting message.
