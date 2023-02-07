import processing.io.*;
// int btnPin = 2;
// int btnLEDPin = 3;

// int potentiometerPin = 4;  // not yet used....

/* int rotaryPinA = 26;
int rotaryPinB = 19;
// int rotaryBtnPin = 13;
long rotaryValue = 0;

// long lastRotaryValue = 0;
int lastEncoded = 0; */
/* 
int[][] rotaryEncoders = {
  // {pinA, pinB, value, lastEncoded},
  {26, 19, amplitude, amplitude},  // amplitude, physical pin #37+35
  {13, 6, frequency, frequency},   // frequency, physical pin #33+31
  {5, 11, scale, scale},           // scale,     physical pin #29+23
  {9, 10, noise, noise}            // de-noise,  physical pin #21+19
};
 */
int value0 = amplitude;
int lastEncoded0 = amplitude;
int value1 = frequency;
int lastEncoded1 = frequency;
int value2 = scale;
int lastEncoded2 = scale;
int value3 = noise;
int lastEncoded3 = noise;

void gpioSetup() {
  // ROTARY ENCODER SETUP
  // DEFINE PINOUTS
  GPIO.pinMode(26, GPIO.INPUT_PULLUP);
  GPIO.pinMode(19, GPIO.INPUT_PULLUP);
  // DEFINE INTERRUPTS
  GPIO.attachInterrupt(26, this, "chooseEncoder0", GPIO.CHANGE);
  GPIO.attachInterrupt(19, this, "chooseEncoder0", GPIO.CHANGE);
  // DEFINE PINOUTS
  GPIO.pinMode(13, GPIO.INPUT_PULLUP);
  GPIO.pinMode(6, GPIO.INPUT_PULLUP);
  // DEFINE INTERRUPTS
  GPIO.attachInterrupt(13, this, "chooseEncoder1", GPIO.CHANGE);
  GPIO.attachInterrupt(6, this, "chooseEncoder1", GPIO.CHANGE);
  // DEFINE PINOUTS
  GPIO.pinMode(5, GPIO.INPUT_PULLUP);
  GPIO.pinMode(11, GPIO.INPUT_PULLUP);
  // DEFINE INTERRUPTS
  GPIO.attachInterrupt(5, this, "chooseEncoder2", GPIO.CHANGE);
  GPIO.attachInterrupt(11, this, "chooseEncoder2", GPIO.CHANGE);
  // DEFINE PINOUTS
  GPIO.pinMode(9, GPIO.INPUT_PULLUP);
  GPIO.pinMode(10, GPIO.INPUT_PULLUP);
  // DEFINE INTERRUPTS
  GPIO.attachInterrupt(9, this, "chooseEncoder3", GPIO.CHANGE);
  GPIO.attachInterrupt(10, this, "chooseEncoder3", GPIO.CHANGE);
}


void gpioRead() {
  /* if(rotaryValue != lastRotaryValue) {
    println("Rotary value: " + rotaryValue);
    lastRotaryValue = rotaryValue;
  }
  
  if(GPIO.digitalRead(btnPin) == GPIO.LOW) {
   //btn is pressed
   fill(255,182,0);
   println("btn pressed");
   GPIO.digitalWrite(btnLEDPin, GPIO.HIGH);
  } else {
   // btn is not pressed
   fill(30,30,30);
   GPIO.digitalWrite(btnLEDPin, GPIO.LOW);
  }
  ellipse(width/2, wHeight/2, 75, 75);
  
  if(GPIO.digitalRead(rotaryBtnPin) == GPIO.LOW) {
   //btn is pressed
   println("rotary btn pressed");
  } else {
   // btn is not pressed
  } */
}

// Not very elegant. cannot deliver parameters to function
void chooseEncoder0(int pin) {  // int pin from attach interrupt function. i dont care.
  updateEncoder(0, 26, 19, value0, lastEncoded0);
}

void chooseEncoder1(int pin) {  // int pin from attach interrupt function. i dont care.
  updateEncoder(1, 13, 6, value1, lastEncoded1);
}

void chooseEncoder2(int pin) {  // int pin from attach interrupt function. i dont care.
  updateEncoder(2, 5, 11, value2, lastEncoded2);
}

void chooseEncoder3(int pin) {  // int pin from attach interrupt function. i dont care.
  updateEncoder(3, 9, 10, value3, lastEncoded3);
}


void updateEncoder(int index, int pinA, int pinB, int value, int lastEncoded) {
  int MSB = GPIO.digitalRead(pinA);
  int LSB = GPIO.digitalRead(pinB);

  int encoded = (MSB << 1) | LSB;
  int sum = (lastEncoded << 2) | encoded;

  int temp = 0;

  if (sum == unbinary("1101") || sum == unbinary("0100") || sum == unbinary("0010") || sum == unbinary("1011")) {
    temp = value++;
  }
  if (sum == unbinary("1110") || sum == unbinary("0111") || sum == unbinary("0001") || sum == unbinary("1000")) { 
    temp = value--;
  }

  if(index == 0) { value0 = temp; }
  else if(index == 1) { value1 = temp; }
  else if(index == 2) { value2 = temp; }
  else if(index == 3) { value3 = temp; }

  if(index == 0) { lastEncoded0 = encoded; }
  else if(index == 1) { lastEncoded1 = encoded; }
  else if(index == 2) { lastEncoded2 = encoded; }
  else if(index == 3) { lastEncoded3 = encoded; }

  routeValue(index, temp);
  //println(value); //DEBUG
}

/// TODO: Generalize for 4+ rotary encoders
/* 
void updateEncoder(int pin) {
  int MSB = GPIO.digitalRead(rotaryPinA);
  int LSB = GPIO.digitalRead(rotaryPinB);

  int encoded = (MSB << 1) | LSB;
  int sum = (lastEncoded << 2) | encoded;

  if (sum == unbinary("1101") || sum == unbinary("0100") || sum == unbinary("0010") || sum == unbinary("1011")) {
    rotaryValue++;
  }
  if (sum == unbinary("1110") || sum == unbinary("0111") || sum == unbinary("0001") || sum == unbinary("1000")) { 
    rotaryValue--;
  }

  lastEncoded = encoded;
  // TODO SOMETHING LIKE THAT
  amplitudeKnob(encoded);
  //println(rotaryValue); //DEBUG
} */

void routeValue(int index, int value) {
  switch(index) {
    case('0'): amplitudeKnob(value); break;
    case('1'): frequencyKnob(value); break;
    case('2'): scaleKnob(value); break;
    case('3'): noiseKnob(value); break;
  }
}


// These functions are also used by the controlP5 dials
void amplitudeKnob(int value) {
  value = clamp(value, ampMin, ampMax);
  if(stage == 3 || stage == 4) {
      amplitude = value;
      println("Setting amplitude to "+value);
      popUp("AMPLITUDE: "+(value+333), width/4*3, 1250);  // skew printout to not have boring numbers as solution
  }
}
void frequencyKnob(int value) {
  value = clamp(value, freqMin, freqMax);
  if(stage == 3 || stage == 4) {
      frequency = value;
      println("Setting frequency to "+value);
      popUp("FREQUENCY: "+(value+124), width/4*3, 1250);  // skew printout to not have boring numbers as solution
  }
}
void scaleKnob(int value) {
  value = clamp(value, scaleMin, scaleMax);
  if(stage == 3 || stage == 4) {
      // scale = width/value;
      scale = value;
      println(scale);
      popUp("SCALE: "+value, width/4*3, 1250);
  }
}
void noiseKnob(int value) {
  value = clamp(value, noiseMin, noiseMax);
  if(stage == 3 || stage == 4) {
      noise = value;
      println(value);
      popUp("DE-NOISE: "+(value+416), width/4*3, 1250);  // skew printout to not have boring numbers as solution
  }
}