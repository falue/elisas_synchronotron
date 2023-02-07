import controlP5.*;
ControlP5 gui;
// https://sojamo.de/libraries/controlP5/#examples

Button nextBtn, prevBtn;  // brainalizerBtn,  // For later use to show/hide btn


void debugSetup() {
    gui = new ControlP5(this);

    gui.addKnob("amplitudeKnob")
        .setLabel("AMPLITUDE")
        .setRange(ampMin,ampMax)
        .setValue(amplitude)
        .setPosition(20,20)
        .setRadius(30)
        .setDragDirection(Knob.VERTICAL)
        ;

    gui.addKnob("frequencyKnob")
        .setLabel("FREQUENCY")
        .setRange(freqMin,freqMax)
        .setValue(frequency)
        .setPosition(120,20)
        .setRadius(30)
        .setDragDirection(Knob.VERTICAL)
        ;

    gui.addKnob("scaleKnob")
        .setLabel("SCALE")
        .setRange(scaleMin,scaleMax)
        //.setValue(scale*width)
        .setValue(scale)
        .setPosition(220,20)
        .setRadius(30)
        .setDragDirection(Knob.VERTICAL)
        ;

    gui.addKnob("noiseKnob")
        .setLabel("DE-NOISE")
        .setRange(noiseMin,noiseMax)
        .setValue(noise)
        .setPosition(320,20)
        .setRadius(30)
        .setDragDirection(Knob.VERTICAL)
        ;


    nextBtn = gui.addButton("nextStage")  // same as function name 
        .setLabel("Next")  // overwrite btn text
        .setPosition(right(100, 20),20)
        .setSize(100,20)
        .setVisible(true);

    prevBtn = gui.addButton("prevStage")  // same as function name 
        .setLabel("Prev")  // overwrite btn text
        .setPosition(right(100, 20),45)
        .setSize(100,20)
        .setVisible(true);

    /* brainalizerBtn = gui.addButton("brainalizer")  // same as function name 
        .setLabel("Connect brainalizer")  // overwrite btn text
        .setPosition(right(100, 20),70)
        .setSize(100,40)
        .setVisible(false); */
}

// in draw()
void debug() {
    textAlign(RIGHT);
    textSize(33); 
    fill(mainFontColor);
    text("Stage "+stage, width-150, 65);
    textSize(fontSize);

    text(round(frameRate, 2)+"fps", width-150, 35);
    textAlign(LEFT);
   
    stroke(mainFontColor);
    line(width/2,0, width/2,wHeight);  // vertical monitor separator

    if(CROSSHAIR) {
        // arrows
        fill(mainFontColor);
        triangle(0,0, 25,15, 15,25);
        triangle(width,0, width-25,15, width-15,25);
        triangle(width,wHeight, width-25,wHeight-15, width-15,wHeight-25);
        triangle(0,wHeight, 25,wHeight-15, 15,wHeight-25);

        // cross
        stroke(mainFontColor);
        line(0,wHeight/2, width,wHeight/2);  // horz 
        line(0,0, width,wHeight);  // diagonal
        line(0,wHeight, width,0);  // diagonal
        
        // center
        fill(0,0,0,0);
        rect(0,0, width-1,wHeight-1);
        rect(0,0, width-1,height-1);
        rect(width/2-50,wHeight/2-50, 100,100);
        rect(width/4-50,wHeight/2-50, 100,100);
        rect(width/4*3-50,wHeight/2-50, 100,100);
    }

    // Display button to "connect" & next/prev stage cable when testing
    // brainalizerBtn.setVisible(PLAYTESTING && stage == 3);
    /* 
    brainalizerBtn.unlock();
    nextBtn.setVisible(!PLAYTESTING || (PLAYTESTING && (stage == 0 || stage == 1 || stage == 5 || stage == 6)));  //  0,1,5,6
    prevBtn.setVisible(!PLAYTESTING || (PLAYTESTING && (stage == 1 || stage == 2 || stage == 3 || stage == 5 || stage == 6))); // 1,2,3,5,6
     */
}

// Looking for the functions of the dials? check the gpio.pde file

void brainalizer(int value) {
    nextStage();
}