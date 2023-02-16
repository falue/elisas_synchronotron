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

  IF LIBRARIES MISSING
    No library found for controlP5       -> in library manager look for "controlP5"
    No library found for processing.io   -> in library manager look for "processing-io"
    No library found for hypermedia.net  -> in library manager look for "UDP" by Stephane Cousot (!!)
*/

import java.util.Arrays;

//// FROM HERE: ADJUST FOR PREFERENCES -----------------------

// GLOBALS
boolean GPIO_AVAILABLE = true;   // True for raspberry pi or computers with GPIOs
boolean DEBUG = true;           // Display infos and dials to play without GPIO
boolean CROSSHAIR = true;       // To calibrate monitors; displays frames and centerlines etc
boolean AUTOSCALE = false;       // If preloading takes ages or never finishes, turn this on.
                                 //   It rescales the viewing window until a framerate of 10 is matched.

// UDP settings
String ip = "192.168.1.45";      // The remote IP address - your local network. Should be static.
int port = 8888;                 // The destination port
int portIncoming = 6000;         // Port to listen to for incoming messages

// GAME MECHANICS
// Initial "wrong" values
// Note, to adjust these numbers, enable DEBUG
//   and enter the numbers on the dials, not the one in the orange dialog box.
int amplitude = 12;
int frequency = 80;
int scale = 24;
int noise = 380;
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
int ampWin = 12;    // In GUI +333: 345
int freqWin = 183;  // In GUI +124: 307
int scaleWin = 12;  // In GUI +0:    12
int noiseWin = 8;   // In GUI +416: 424

// Tolerance +/- of user input to accomplish total brain synchronicity
//   the higher, the easier it is to win.
int ampTolerance = 18;
int freqTolerance = 18;
int scaleTolerance = 10;
int noiseTolerance = 50;

// Factor to increase speed of dials ("less turning, more changing" etc)
int ampDialSpeedFactor = 1;
int freqDialSpeedFactor = 1;
int scaleDialSpeedFactor = 1;
int noiseDialSpeedFactor = 8;

// For resetting stage - dont touch 
int amplitudeReset = amplitude;
int frequencyReset = frequency;
int scaleReset = scale;
int noiseReset = noise;

// STYLES
int wHeight = 240;                         // windowed content in frame to trick the 2x2 video wall converter
int mainBg = color(0,0,0);                 // RGB values
int mainFontColor = color(255,182,0);      // RGB values
int mainBgInitial = mainBg;                // used after invertig foreground & background. leave alone.
int mainFontColorInitial = mainFontColor;  // used after invertig foreground & background. leave alone.
int fontSize = wHeight/30;
int lineHeight = int(fontSize*1.4);
int lineWeight = 2;


//// FROM HERE: DONT TOUCH -----------------------

// GENERAL
int stage = 0;                // keeps track of stages
int maxStage = 6;

// CLUTCHES
boolean startUpLoaded = false;
PImage cursorImg;


void setup() {
  size(640,480);  // VGA
  // fullScreen();

  cursorImg = loadImage("cursor.gif");

  udpSetup();
  if(GPIO_AVAILABLE) gpioSetup();

  // Font
  PFont font;
  // The font must be located in the sketch's 
  // "data" directory to load successfully
  // font = createFont("3270SemiCondensed-Regular.otf", fontSize);
  // font = createFont("3270-Regular.otf", fontSize);        // too thin :(
  // font = createFont("ONESIZE_.TTF", fontSize);            // mokey island - no box chars :(
  // font = createFont("MonkeyIsland-1991", fontSize);       // mokey island, more chars (umlaute) - but doesn't work and still no box chars :(
  // font = createFont("Flexi_IBM_VGA_True.ttf", fontSize);  // no pixelation but real IBM :(
  font = createFont("Topaz8-xxO8.ttf", fontSize);            // maybe the one
  textFont(font);

  if(DEBUG) {
    debugSetup();
  }

  popUp("Installed version: "+version, width/4, 8*lineHeight, 6000);

  prepareExitHandler();
}


void draw() {
  background(mainBg);
  // frameRate(12);

  if(DEBUG) {
    debug();
    // if(!startUpLoaded) udp.send("sync_ready", ip, port);
    // startUpLoaded = true;  // Do not preload for debugging
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
    drawCurve(curve, width/2+25,lineHeight*2, width/2-50, wHeight-lineHeight*4, scale, amplitude, frequency, noise);
    
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
    if(DEBUG) centerText("[SCREEN ELISA]", wHeight/2, 0,width/2);
    if(DEBUG) centerText("[SCREEN EMPTY]", wHeight/2, width/2,width);

    /* if (millis() % 1000 <= 50 && hasTakenScreenshot) {
      ghostingPaste(screenshot[0], 25,75, width/2-50, wHeight-100);
      ghostingPaste(screenshot[1], width/2+25,75, width/2-50, wHeight-100);
    } */

    // Elisas curve
    // ampWin, freqWin, scaleWin, noiseWin
    drawCurve(curve, 25,lineHeight*2, width/2-50, wHeight-lineHeight*4, scaleWin, ampWin, freqWin, noiseWin);

    if(stage == 3) {
      // display "disconnected" data with low noise
      drawCurve(nullCurve, width/2+25,lineHeight*2, width/2-50, wHeight-lineHeight*4, scale, amplitude, frequency, noise/20);
    }
    
    // Grids
    drawGrid(25,lineHeight*2, width/2-50, wHeight-lineHeight*4, scaleWin);
    drawGrid(width/2+25,lineHeight*2, width/2-50, wHeight-lineHeight*4, scale);
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

    popUp(">BRAIN SYNC ESTABLISHED", width/4, 0);
    popUp(">BRAIN SYNC ESTABLISHED", width/4*3, 0);
  }

  if(stage == 6) {
    // Elisas thoughts sequence
    scrollText(thoughtsDe, 2000, 0, 25,25, width/2-50, wHeight-50, true);
    scrollText(thoughtsEn, 2000, 0, width/2+25,25, width/2-50, wHeight-50, true);
  }

  if(!startUpLoaded) {
    preloadAllStages(16);
  }

  if(DEBUG) {
    debugTail();
  }

  // Display Pop ups longer than triggered
  popUpAfterglow();
}

// Send message from the grave if closed or is mauled by death or bad programming
private void prepareExitHandler () {
  // TODO: Most of the time, port closes befoore this gets executed but meh
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run () {
      println("Program closed or died");
      udp.send("sync_died", ip, port);
    }
  }));
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

  if(stage-1 == 3) popUp(">BRAINALIZER DISCONNECTED", width/4*3, 1250);

  if(stage-1 >= 0) {
    stage--;
  } else {
    stage = maxStage;
  }
}
