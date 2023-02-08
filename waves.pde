float perlinNoiseCoordY = 0.0;
PImage[] screenshot;

void drawGrid(int x, int y, int w, int h, int scale) {
    // MAIN LINES   
    stroke(mainFontColor);
    line(x,y+h-20, x+w,y+h-20);  // horz
    line(x+20,y, x+20,y+h);  // vert

    // subgrid horz
    stroke(mainFontColor, 100);
    for (int i = 0; i < h-20; i+=scale) {
        // scale*(amplitude/100)
        line(x+20,y+h-20-i, x+w,y+h-20-i);
    }
    // subgrid vert
    for (int i = 0; i < w-20; i+=scale) {
        // scale*(frequency/100)
        line(x+20+i,y, x+20+i,y+h-20);
    }

    // TEXT
    pushMatrix();
        textAlign(RIGHT);
        float angle2 = radians(270);
        translate(x+fontSize, y);
        rotate(angle2);
        text("AMPLITUDE", 0,0);
    popMatrix();

    text("FREQUENCY", x+w, y+h);
    textAlign(LEFT);
    text("0", x, y+h);
    centerText("Scale "+scale+":1", y+h, x+20, x+w);
};

void drawCurve(int[] data, int x, int y, int w, int h, int scale, int amp, int freq, int noise) {
    stroke(mainFontColor);
    strokeWeight(lineWeight*2);  // Thicc
    noFill();
    // curveTightness(0);  // 0 ultra smooth, 1 no smoothing
    float thightness = map(noise, -420, 420, -1.0, 1.0);
    curveTightness(thightness < 0 ? thightness*-1 : thightness);

    beginShape();
    float noiseCorr = 0;
    for (int i = 0; i < data.length && (i-2)*scale*(freq/100.0) <= w-20; i++) {
        perlinNoiseCoordY = perlinNoiseCoordY + map(noise, 10, 420, 0.001, .1);  /// 0.01
        noiseCorr = noise(perlinNoiseCoordY, perlinNoiseCoordY)*noise;
        // add random spikes sometimes
        if(i % 2 == 0) noiseCorr *= -1;
        if(random(0, 450-noise) <= 6 ) noiseCorr *= -random(0,16);
        // TODO: this does not "scale" in Y
        curveVertex(x+20+(i-1)*scale*(freq/100.0),  map(data[i]*(amp/100.0)-int(noiseCorr), 0,1024, y+h-20, y));
    }
    endShape();

    //Cover up overshooting curve top and bottom
    fill(mainBg);
    noStroke();
    rect(x+21, y+h-20, w-20, wHeight);
    rect(x+21, 0, w-20, y);

    strokeWeight(lineWeight);
};

PImage ghostingCopy(int x, int y, int w, int h) {
    return get(x, y, w, h);
}
void ghostingPaste(PImage img, int x, int y, int w, int h) {
    image(img, x+20, y-20);
}

void drawFakeApplicationNonsense() {
    textAlign(RIGHT);
    fill(mainFontColor);
    String text1 = "My fake application is running on a cheesburger";
    text(text1, right(0,25), wHeight-10);
    textAlign(LEFT);
}