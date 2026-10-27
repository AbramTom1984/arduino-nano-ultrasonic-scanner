// Copyright (c) 2026 Tomasz Abramowicz
// SPDX-License-Identifier: MIT

import processing.serial.*;

Serial port;
final String PORT_NAME = "/dev/ttyUSB0";
final int BAUD = 115200;
final int A_MIN = 30;
final int A_MAX = 150;
final int STEP = 3;
final float DISPLAY_CM = 100;
final float ALARM_CM = 50;
final int STALE_MS = 12000;

float[] distances = new float[181];
int[] updatedAt = new int[181];
int currentAngle = 90;
float currentDistance = -1;
int lastReceived = -1;
float cx, cy, radius;

void setup() {
  size(1000, 650);
  smooth(4);
  cx = width / 2.0;
  cy = height - 65;
  radius = 440;
  for (int i = 0; i < distances.length; i++) {
    distances[i] = -1;
    updatedAt[i] = -1;
  }
  println("Available serial ports:");
  printArray(Serial.list());
  port = new Serial(this, PORT_NAME, BAUD);
  port.clear();
  textFont(createFont("Arial", 16));
}

void readMeasurements() {
  while (port.available() > 0) {
    String line = port.readStringUntil('\n');
    if (line == null) {
      break;
    }
    String[] values = split(trim(line), ',');
    if (values.length != 2) {
      continue;
    }
    try {
      int a = Integer.parseInt(values[0]);
      float d = Float.parseFloat(values[1]);
      if (a < A_MIN || a > A_MAX ||
          Float.isNaN(d) || Float.isInfinite(d)) {
        continue;
      }
      distances[a] = d;
      updatedAt[a] = millis();
      currentAngle = a;
      currentDistance = d;
      lastReceived = millis();
    }
    catch (Exception e) {
      // Ignore incomplete or malformed input.
    }
  }
}

boolean fresh(int a) {
  return updatedAt[a] >= 0 && millis() - updatedAt[a] < STALE_MS;
}

void drawSector(float angle, float halfWidth, int fillColor) {
  fill(fillColor);
  noStroke();
  beginShape();
  vertex(cx, cy);
  for (float a = angle - halfWidth;
       a <= angle + halfWidth + 0.01; a += 0.5) {
    vertex(cx + radius * cos(radians(a)),
           cy - radius * sin(radians(a)));
  }
  endShape(CLOSE);
}

void draw() {
  readMeasurements();
  background(12, 17, 22);
  for (int a = A_MIN; a <= A_MAX; a += STEP) {
    int c = color(45, 50, 57);
    if (fresh(a) && distances[a] >= 2) {
      c = distances[a] <= ALARM_CM
          ? color(175, 35, 40) : color(20, 105, 55);
    }
    drawSector(a, STEP / 2.0, c);
  }

  // Distance grid: adjust the labels if DISPLAY_CM changes.
  noFill();
  stroke(105, 135, 125);
  strokeWeight(1);
  for (int cm = 25; cm <= 100; cm += 25) {
    float r = radius * cm / DISPLAY_CM;
    arc(cx, cy, 2*r, 2*r,
        radians(180 - A_MAX), radians(180 - A_MIN));
    fill(190);
    textAlign(LEFT);
    text(cm + " cm", cx + 8, cy - r + 17);
    noFill();
  }
  for (int a = A_MIN; a <= A_MAX; a += 30) {
    line(cx, cy, cx + radius * cos(radians(a)),
         cy - radius * sin(radians(a)));
  }

  // Plot measurements within the visible range.
  noStroke();
  for (int a = A_MIN; a <= A_MAX; a += STEP) {
    float d = distances[a];
    if (fresh(a) && d >= 2 && d <= DISPLAY_CM) {
      float r = radius * d / DISPLAY_CM;
      fill(d <= ALARM_CM ? color(255, 110, 100)
                         : color(130, 255, 170));
      ellipse(cx + r * cos(radians(a)),
              cy - r * sin(radians(a)), 8, 8);
    }
  }

  boolean connected = lastReceived >= 0 &&
                      millis() - lastReceived < 2000;
  if (connected) {
    stroke(100, 255, 150);
    strokeWeight(3);
    line(cx, cy, cx + radius * cos(radians(currentAngle)),
         cy - radius * sin(radians(currentAngle)));
  }

  fill(235);
  textAlign(LEFT);
  textSize(23);
  text("Ultrasonic Scanner", 30, 36);
  textSize(16);
  text("Display range: " + int(DISPLAY_CM) +
       " cm  |  Alert threshold: " + int(ALARM_CM) + " cm", 30, 65);
  String reading = currentDistance >= 2
      ? nf(currentDistance, 0, 1) + " cm" : "no valid echo";
  text("Angle: " + currentAngle + " degrees  |  Distance: " + reading,
       30, 92);
  if (!connected) {
    fill(255, 190, 80);
    text("Waiting for Arduino data...", 30, 119);
  }
  fill(200);
  textSize(14);
  text("Green: above threshold    Red: at/below threshold" +
       "    Gray: no current valid reading", 30, height - 20);
}
