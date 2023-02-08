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
// long value0 = amplitude;
int lastEncoded0 = 0;

// frequency
// long value1 = frequency;
int lastEncoded1 = 0;

// scale
// long value2 = scale;
int lastEncoded2 = 0;

// noise
// long value3 = noise;
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
}


// amplitude
void updateEncoder0(int pin) {
  GPIO.noInterrupts();
	int MSB = GPIO.digitalRead(pin_0a);
	int LSB = GPIO.digitalRead(pin_0b);
	int encoded = (MSB << 1) | LSB;
	int sum = (lastEncoded0 << 2) | encoded;
	if (sum == unbinary("1101") || sum == unbinary("0100") || sum == unbinary("0010") || sum == unbinary("1011")) {
		amplitude++;
	}
	if (sum == unbinary("1110") || sum == unbinary("0111") || sum == unbinary("0001") || sum == unbinary("1000")) { 
		amplitude--;
	}
	lastEncoded0 = encoded;
	amplitudeKnob(amplitude); // DEBUG
  GPIO.interrupts();
}

// frequency
void updateEncoder1(int pin) {
  GPIO.noInterrupts();
	int MSB = GPIO.digitalRead(pin_1a);
	int LSB = GPIO.digitalRead(pin_1b);
	int encoded = (MSB << 1) | LSB;
	int sum = (lastEncoded1 << 2) | encoded;
	if (sum == unbinary("1101") || sum == unbinary("0100") || sum == unbinary("0010") || sum == unbinary("1011")) {
		frequency++;
	}
	if (sum == unbinary("1110") || sum == unbinary("0111") || sum == unbinary("0001") || sum == unbinary("1000")) { 
		frequency--;
	}
	lastEncoded1 = encoded;
	frequencyKnob(frequency); // DEBUG
  GPIO.interrupts();
}

// scale
void updateEncoder2(int pin) {
  GPIO.noInterrupts();
	int MSB = GPIO.digitalRead(pin_2a);
	int LSB = GPIO.digitalRead(pin_2b);
	int encoded = (MSB << 1) | LSB;
	int sum = (lastEncoded2 << 2) | encoded;
	if (sum == unbinary("1101") || sum == unbinary("0100") || sum == unbinary("0010") || sum == unbinary("1011")) {
		scale++;
	}
	if (sum == unbinary("1110") || sum == unbinary("0111") || sum == unbinary("0001") || sum == unbinary("1000")) { 
		scale--;
	}
	lastEncoded2 = encoded;
	scaleKnob(scale); // DEBUG
  GPIO.interrupts();
}

// noise
void updateEncoder3(int pin) {
  GPIO.noInterrupts();
	int MSB = GPIO.digitalRead(pin_3a);
	int LSB = GPIO.digitalRead(pin_3b);
	int encoded = (MSB << 1) | LSB;
	int sum = (lastEncoded3 << 2) | encoded;
	if (sum == unbinary("1101") || sum == unbinary("0100") || sum == unbinary("0010") || sum == unbinary("1011")) {
		noise++;
	}
	if (sum == unbinary("1110") || sum == unbinary("0111") || sum == unbinary("0001") || sum == unbinary("1000")) { 
		noise--;
	}
	lastEncoded3 = encoded;
	noiseKnob(noise); // DEBUG
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