/*
  Elisas Strange Case - Processing sketch 
  =====================================================

  By f.lüscher / fluescher.ch 2023 for Next Level Escape AG.
  "AS IS" pi pa po etc.

  Main file.
  Run this with processing.org/download on mac/win/linux/raspberry pi.
  When not on raspberry pi with GPIO pins and 4 connected rotary encoders,
    set GPIO_AVAILABLE to false and DEBUG to true.
  press 0-6 or arrow keys to change stages.
  esc to leave.

  STAGES
  #   Action                                                  At end of script..
  0:  Blackout                                                ..waits for dungeon master / udp signal
  1:  Message"AWAITING INPUT"                                 ..waits for dungeon master / udp signal
  2:  Startup sequence of computer                            ..auto-jumps to next stage
  3:  Elisas curves, but without brainalizer on players head  ..waits for dungeon master / udp signal
  4:  Elisas curves, with brainalizer. Adjust dials to sync.  ..jumps to next stage when synched
  5:  Message "SUCCESS"                                       ..waits for dungeon master / udp signal
  6:  Elisas thoughts as sequence in DE & EN                  ..waits for dungeon master / udp signal

  UDP & WINNING NUMBERS
  Refer to the README.md file to see messages that are sent and being received.

*/

import java.util.Arrays;

//// FROM HERE: ADJUST FOR PREFERENCES -----------------------

// GLOBALS
boolean GPIO_AVAILABLE = false;  // True for raspberry pi or computers with GPIOs
boolean DEBUG = true;           // Display infos and dials to play without GPIO
boolean CROSSHAIR = false;       // To calibrate monitors; displays frames and centerlines etc
boolean PLAYTESTING = false;     // TODO: if true, hide crosshair/frames but keep all the buttons.
                                 //   TODO: also, auto-increment stages where appropriate.

// UDP settings
String ip = "192.168.1.45";      // The remote IP address - your local network. Should be static.
int port = 8888;                 // The destination port
int portIncoming = 6000;         // Port to listen to for incoming messages

// GAME MECHANICS
// Initial "wrong" values
// Note, to adjust these numbers, enable DEBUG
//   and enter the numbers on the dials, not the one in the orange dialog box.
int amplitude = 25;
int frequency = 170;
int scale = 9; 
int noise = 290;
// Min/Max values
int ampMin = 0;
int ampMax = 50;
int freqMin = 65;
int freqMax = 333;
int scaleMin = 4;
int scaleMax = 75;
int noiseMin = -420;
int noiseMax = 420;
// Winning numbers on dials (also, initial adjustments for elisas curves)
int ampWin = 4;     // In GUI: 337
int freqWin = 120;  // In GUI: 224
int scaleWin = 36;  // In GUI: 36
int noiseWin = 0;   // In GUI: 416

// Tolerance +/- of user input to accomplish total brain synchronicity
//   the higher, the easier is it to win.
int ampTolerance = 18;
int freqTolerance = 18;
int scaleTolerance = 10;
int noiseTolerance = 22;

// For resetting stage - dont touch 
int amplitudeReset = amplitude;
int frequencyReset = frequency;
int scaleReset = scale;
int noiseReset = noise;

// STYLES
int mainBg = color(0,0,0);                 // RGB values
int mainFontColor = color(255,182,0);      // RGB values
int mainBgInitial = mainBg;                // used after invertig foreground & background. leave alone.
int mainFontColorInitial = mainFontColor;  // used after invertig foreground & background. leave alone.
int fontSize = 16;                         // pixel
int lineHeight = int(fontSize*1.4);
int lineWeight = 2;


//// FROM HERE: DONT TOUCH -----------------------

// GENERAL
int wHeight = 480;            // windowed content in frame to trick the 2x2 video wall converter
int stage = 0;                // keeps track of stages
int maxStage = 6;

// CLUTCHES
boolean startUpLoaded = false;
PImage cursorImg;
// TODO glitcheffect
// boolean hasTakenScreenshot = false;


void setup() {
  size(640*2,480*2);  // 2xVGA
  // fullScreen();

  cursorImg = loadImage("cursor.gif");

  udpSetup();
  if(GPIO_AVAILABLE) gpioSetup();

  // Font
  PFont font;
  // The font must be located in the sketch's 
  // "data" directory to load successfully
  font = createFont("3270SemiCondensed-Regular.otf", fontSize);
  textFont(font);

  if(DEBUG) debugSetup();
}


void draw() {
  background(mainBg);
  // frameRate(12);

  if(DEBUG) {
    debug();
    startUpLoaded = true;  // Do not preload for debugging
  } else {
    cursor(cursorImg);  // Set to transparent png
    noCursor();         // Doesn't work at all on MAC
  }
  
  if(GPIO_AVAILABLE) gpioRead();

  if(stage == 0) {
    // BLACKOUT
    if(DEBUG) {
      centerText("[BLACKOUT]", wHeight/2, 0,width/2);
      centerText("[BLACKOUT]", wHeight/2, width/2,width);
    }
  }

  if(stage == 1) {
    // AWAITING INPUT
    if (millis() % 1000 <= 500) {
      popUp("AWAITING INPUT", width/4, 0);
      popUp("AWAITING INPUT", width/4*3, 0);
    }
  }

  if(stage == 2) {
    // Startup sequence
    scrollText(boot, 180, 350, 25,25, width/2-50, wHeight-50, false);
    scrollText(boot, 180, 350, width/2+25,25, width/2-50, wHeight-50, false);
  }

  if(stage == 4 || stage == 5) {
    // Kappe auf
    if(DEBUG) centerText("XXXXX USER]", wHeight/2, width/2+100,width);
    //   data, x, y, w, h, scale, amp, freq, noise, thightness
    drawCurve(curve, width/2+25,75, width/2-50, wHeight-100, scale, amplitude, frequency, noise);
    
    if( stage == 4 &&
      isAboutEqual(amplitude, ampWin, ampTolerance) &&
      isAboutEqual(frequency, freqWin, freqTolerance) &&
      isAboutEqual(noise, noiseWin, noiseTolerance) &&
      isAboutEqual(scale, scaleWin, scaleTolerance)
    ) {
      // Player has synced brains properly
      // Ascend
      nextStage();
      
      // Send the good message to the controlino
      udp.send("sync_success", ip, port );
    }
  }

  if(stage == 3 || stage == 4 || stage == 5) {
    if(DEBUG) centerText("[GRID ELISA]", wHeight/2, 0,width/2);
    if(DEBUG) centerText("[GRID EMPTY]", wHeight/2, width/2,width);

    /* if (millis() % 1000 <= 50 && hasTakenScreenshot) {
      ghostingPaste(screenshot[0], 25,75, width/2-50, wHeight-100);
      ghostingPaste(screenshot[1], width/2+25,75, width/2-50, wHeight-100);
    } */

    // Elisas curve
    //   data, x, y, w, h, scale, amp, freq, noise
    drawCurve(curve, 25,75, width/2-50, wHeight-100, 36, 4, 120, 25);

    if(stage == 3) {
      // display "disconnected" data with low noise
      drawCurve(nullCurve, width/2+25,75, width/2-50, wHeight-100, scale, amplitude, frequency, noise/20);
    }
    
    // Grids
    drawGrid(25,75, width/2-50, wHeight-100, 36);
    drawGrid(width/2+25,75, width/2-50, wHeight-100, scale);
    /*
    MakeShadowOfBothCurves();
    } */
    drawFakeApplicationNonsense();


    /* if (millis() % 1000 <= 50) {
      hasTakenScreenshot = true;
      screenshot[0] = ghostingCopy(25,75, width/2-50, wHeight-100);
      screenshot[1] = ghostingCopy(width/2+25,75, width/2-50, wHeight-100);
    } */
  }

  if(stage == 5) {
    // SUCCESS
    // FLIP COLORS
    if (millis() % 1000 <= 500) {
      mainFontColor= color(mainBgInitial);
      mainBg = color(mainFontColorInitial);
    } else {
      mainBg = color(mainBgInitial);
      mainFontColor = color(mainFontColorInitial);
    }

    /* stroke(mainBg);
    fill(mainBg);
    rect(width/4-130,wHeight/2-lineHeight*2-5, 260,43, 5);
    fill(mainFontColor);
    rect(width/4-125,wHeight/2-lineHeight*2, 250,33, 5);
    centerText("BRAIN SYNC ESTABLISHED", wHeight/2-lineHeight, 0,width/2, mainBg); */
    popUp(">BRAIN SYNC ESTABLISHED", width/4, 0);

    /* stroke(mainBg);
    fill(mainBg);
    rect(width/4*3-130,wHeight/2-lineHeight*2-5, 260,43, 5);
    fill(mainFontColor);
    rect(width/4*3-125,wHeight/2-lineHeight*2, 250,33, 5);
    centerText("BRAIN SYNC ESTABLISHED", wHeight/2-lineHeight, width/2, width, mainBg); */
    popUp(">BRAIN SYNC ESTABLISHED", width/4*3, 0);
  }

  if(stage == 6) {
    // Elisas thoughts sequence
    scrollText(thoughtsDe, 2000, 0, 25,25, width/2-50, wHeight-50, true);
    scrollText(thoughtsEn, 2000, 0, width/2+25,25, width/2-50, wHeight-50, true);
  }

  if(!startUpLoaded) {
    preloadAllStages(6.2);
  }

  // Display Pop ups longer than triggered
  popUpAfterglow();
}

void goToStage(int index) {
  // reset global stuffs
  scrollIndex = 0;  // reset index of text scroller
  mainBg = color(mainBgInitial);  // FLIP COLORS BACK
  mainFontColor = color(mainFontColorInitial);  // FLIP COLORS BACK
  stage = index;
}

void nextStage() {
  // reset global stuffs
  scrollIndex = 0;  // reset index of text scroller
  mainBg = color(mainBgInitial);  // FLIP COLORS BACK
  mainFontColor = color(mainFontColorInitial);  // FLIP COLORS BACK

  if(stage+1 == 3 || stage+1 == 6) {
    // Reset values when entering brainalizer territorium or leaving "success" page
    amplitude = amplitudeReset;
    frequency = frequencyReset;
    scale = scaleReset;
    noise = noiseReset;
  }

  if(stage+1 == 4) popUp(">BRAINALIZER CONNECTED", width/4*3, 2500);

  if(stage+1 <= maxStage) {
    stage++;
  } else {
    stage = 0;
  }
}
void prevStage() {
  // reset global stuffs
  scrollIndex = 0;  // reset index of text scroller
  mainBg = color(mainBgInitial);  // FLIP COLORS BACK
  mainFontColor = color(mainFontColorInitial);  // FLIP COLORS BACK

  if(stage-1 == 3) popUp(">BRAINALIZER DISCONNECTED 🮲🮳", width/4*3, 1250);

  if(stage-1 >= 0) {
    stage--;
  } else {
    stage = maxStage;
  }
}
