/* 
Terminating interrupt handling for pin X after catching: null
absturz:irgendwas mit PFFont getname()
cannot use "curveVertex()" bevore "beginShape()" in waves.pde
absturz: Nullpointerexception mit verweis zu zeile 77 (ein rect() mit nur globals?????) in helpers.pde
  */
import processing.io.*;
// amplitude
int pin_0a = 26;  
int pin_0b = 19;

// frequency
int pin_1a = 13;  
int pin_1b = 6;

// scale
int pin_2a = 5;   // Maybe reversed on those products
int pin_2b = 11;  // Maybe reversed on those products

// noise
int pin_3a = 9;   // Maybe reversed on those products
int pin_3b = 10;  // Maybe reversed on those products


// amplitude
int value0 = 0;
int lastEncoded0 = 0;

// frequency
int value1 = 0;
int lastEncoded1 = 0;

// scale
int value2 = 0;
int lastEncoded2 = 0;

// noise
int value3 = 0;
int lastEncoded3 = 0;


void gpioSetup() {
	// amplitude
	GPIO.pinMode(pin_0a, GPIO.INPUT_PULLUP);  // !PULLUP!
	GPIO.pinMode(pin_0b, GPIO.INPUT_PULLUP);  // !PULLUP!
	GPIO.attachInterrupt(pin_0a, this, "updateEncoder0", GPIO.CHANGE);
	GPIO.attachInterrupt(pin_0b, this, "updateEncoder0", GPIO.CHANGE);

	// frequency
	GPIO.pinMode(pin_1a, GPIO.INPUT_PULLUP);  // !PULLUP!
	GPIO.pinMode(pin_1b, GPIO.INPUT_PULLUP);  // !PULLUP!
	GPIO.attachInterrupt(pin_1a, this, "updateEncoder1", GPIO.CHANGE);
	GPIO.attachInterrupt(pin_1b, this, "updateEncoder1", GPIO.CHANGE);

	// scale
	GPIO.pinMode(pin_2a, GPIO.INPUT_PULLUP);  // !PULLUP!
	GPIO.pinMode(pin_2b, GPIO.INPUT_PULLUP);  // !PULLUP!
	GPIO.attachInterrupt(pin_2a, this, "updateEncoder2", GPIO.CHANGE);
	GPIO.attachInterrupt(pin_2b, this, "updateEncoder2", GPIO.CHANGE);

	// noise
	GPIO.pinMode(pin_3a, GPIO.INPUT_PULLUP);  // !PULLUP!
	GPIO.pinMode(pin_3b, GPIO.INPUT_PULLUP);  // !PULLUP!
	GPIO.attachInterrupt(pin_3a, this, "updateEncoder3", GPIO.CHANGE);
	GPIO.attachInterrupt(pin_3b, this, "updateEncoder3", GPIO.CHANGE);
}

void gpioRead() {
  // this is in draw();
  GPIO.noInterrupts();
  if(lastEncoded0 != 0) {
    amplitudeKnob(amplitude + value0);
    lastEncoded0 = 0;
  }

  if(lastEncoded1 != 0) {
    frequencyKnob(frequency + value1);
    lastEncoded1 = 0;
  }

  if(lastEncoded2 != 0) {
    scaleKnob(scale + value2);
    lastEncoded2 = 0;
  }

  if(lastEncoded3 != 0) {
    noiseKnob(noise + value3);
    lastEncoded3 = 0;
  }
  GPIO.interrupts();
}


// amplitude
void updateEncoder0(int pin) {  // int pin) {
  	GPIO.noInterrupts();
	int MSB = GPIO.digitalRead(pin_0a);
	int LSB = GPIO.digitalRead(pin_0b);
	int encoded = (MSB << 1) | LSB;
	int sum = (lastEncoded0 << 2) | encoded;
	if (sum == unbinary("1101") || sum == unbinary("0100") || sum == unbinary("0010") || sum == unbinary("1011")) {
		value0++;
	}
	if (sum == unbinary("1110") || sum == unbinary("0111") || sum == unbinary("0001") || sum == unbinary("1000")) { 
		value0--;
	}
	lastEncoded0 = encoded;
	println("value0: "+value0);
  	GPIO.interrupts();
}

// frequency
void updateEncoder1(int pin) {  // int pin) {
  	GPIO.noInterrupts();
	int MSB = GPIO.digitalRead(pin_1a);
	int LSB = GPIO.digitalRead(pin_1b);
	int encoded = (MSB << 1) | LSB;
	int sum = (lastEncoded1 << 2) | encoded;
	if (sum == unbinary("1101") || sum == unbinary("0100") || sum == unbinary("0010") || sum == unbinary("1011")) {
		value1++;
	}
	if (sum == unbinary("1110") || sum == unbinary("0111") || sum == unbinary("0001") || sum == unbinary("1000")) { 
		value1--;
	}
	lastEncoded1 = encoded;
	println("value1: "+value1);
  	GPIO.interrupts();
}

// scale
void updateEncoder2(int pin) {  // int pin) {
  	GPIO.noInterrupts();
	int MSB = GPIO.digitalRead(pin_2a);
	int LSB = GPIO.digitalRead(pin_2b);
	int encoded = (MSB << 1) | LSB;
	int sum = (lastEncoded2 << 2) | encoded;
	if (sum == unbinary("1101") || sum == unbinary("0100") || sum == unbinary("0010") || sum == unbinary("1011")) {
		value2++;
	}
	if (sum == unbinary("1110") || sum == unbinary("0111") || sum == unbinary("0001") || sum == unbinary("1000")) { 
		value2--;
	}
	lastEncoded2 = encoded;
	println("value2: "+value2);
  	GPIO.interrupts();
}

// noise
void updateEncoder3(int pin) {  // int pin) {
  	GPIO.noInterrupts();
	int MSB = GPIO.digitalRead(pin_3a);
	int LSB = GPIO.digitalRead(pin_3b);
	int encoded = (MSB << 1) | LSB;
	int sum = (lastEncoded3 << 2) | encoded;
	if (sum == unbinary("1101") || sum == unbinary("0100") || sum == unbinary("0010") || sum == unbinary("1011")) {
		value3++;
	}
	if (sum == unbinary("1110") || sum == unbinary("0111") || sum == unbinary("0001") || sum == unbinary("1000")) { 
		value3--;
	}
	lastEncoded3 = encoded;
	println("value3: "+value3);
  	GPIO.interrupts();
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