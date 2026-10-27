// Copyright (c) 2026 Tomasz Abramowicz
// SPDX-License-Identifier: MIT

#include <Servo.h>

const byte TRIG_PIN = 7;
const byte ECHO_PIN = 8;
const byte SERVO_PIN = 9;
const int ANGLE_MIN = 30;
const int ANGLE_MAX = 150;
const int ANGLE_STEP = 3;

Servo scanner;
int angle = ANGLE_MIN;
int direction = 1;

float measureDistanceCm() {
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(3);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  unsigned long duration = pulseIn(ECHO_PIN, HIGH, 30000UL);
  if (duration == 0) {
    return -1.0;
  }
  float distance = duration / 58.0;
  if (distance < 2.0 || distance > 400.0) {
    return -1.0;
  }
  return distance;
}

void setup() {
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  digitalWrite(TRIG_PIN, LOW);
  Serial.begin(115200);
  scanner.attach(SERVO_PIN);
  scanner.write(90);
  // Hold the center position before starting the scan.
  delay(5000);
}

void loop() {
  scanner.write(angle);
  // Allow the mechanism to settle before measuring.
  delay(90);
  float distance = measureDistanceCm();
  Serial.print(angle);
  Serial.print(',');
  Serial.println(distance, 1);

  angle += direction * ANGLE_STEP;
  if (angle > ANGLE_MAX) {
    direction = -1;
    angle = ANGLE_MAX - ANGLE_STEP;
  } else if (angle < ANGLE_MIN) {
    direction = 1;
    angle = ANGLE_MIN + ANGLE_STEP;
  }
}
