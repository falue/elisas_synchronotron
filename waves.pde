float perlinNoiseCoordY = 0.0;
PImage[] screenshot;
int scaleMargin = int(fontSize*1.75);

void drawGrid(int x, int y, int w, int h, int scale) {
    // MAIN LINES   
    stroke(mainFontColor);
    line(x,y+h-scaleMargin, x+w,y+h-scaleMargin);  // horz
    line(x+scaleMargin,y, x+scaleMargin,y+h);  // vert

    // subgrid horz
    stroke(mainFontColor, 100);
    for (int i = 0; i < h-scaleMargin; i+=scale) {
        // scale*(amplitude/100)
        line(x+scaleMargin,y+h-scaleMargin-i, x+w,y+h-scaleMargin-i);
    }
    // subgrid vert
    for (int i = 0; i < w-scaleMargin; i+=scale) {
        // scale*(frequency/100)
        line(x+scaleMargin+i,y, x+scaleMargin+i,y+h-scaleMargin);
    }

    // TEXT
    textAlign(RIGHT);
    fill(mainFontColor);
    pushMatrix();
        float angle2 = radians(270);
        translate(x+fontSize, y);
        rotate(angle2);
        text("AMPLITUDE", 0,0);
    popMatrix();

    text("FREQUENCY", x+w, y+h);
    textAlign(LEFT);
    text("0", x, y+h);
    centerText("Scale "+scale+":1", y+h, x+scaleMargin, x+w);
};

void drawCurve(int[] data, int x, int y, int w, int h, int scale, int amp, int freq, int noise) {
    stroke(mainFontColor);
    strokeWeight(lineWeight*2);  // Thicc
    noFill();
    // curveTightness(0);  // 0 ultra smooth, 1 no smoothing
    float thightness = map(noise, noiseMin, noiseMax, -1.0, 1.0);
    curveTightness(thightness < 0 ? thightness*-1 : thightness);

    float noiseCorr = 0;
    float perlinNoise = 0;
    noise = noise < 5 && noise > -5 ? 5 : noise;
    
    GPIO.noInterrupts();
    beginShape();
    for (int i = 0; i < data.length && (i-2)*scale*(freq/100.0) <= w-scaleMargin; i++) {
        if(frameRate > 5) {
            // Do not completely eradicate jitter

            // Calculate jitter based on de-noise knob
            perlinNoiseCoordY = perlinNoiseCoordY + map(noise, 10, noiseMax, 0.001, .1);
            perlinNoise = noise(perlinNoiseCoordY, perlinNoiseCoordY);
            noiseCorr = perlinNoise*noise;

            // Some random spikes are more spikey
            if(i % Math.round(perlinNoise*12+1) == 0) {
                noiseCorr *= noiseCorr;
            }

            // Invert every other spike to not move the complete wave in +Y or -Y.
            //   It evens out the displacement, and basically doubles the noise effect. Noice!
            if(i % 2 == 0) noiseCorr *= -1;

            // Increase noise now and again - cannot see a difference
            /* if(perlinNoise < 0.2) {
                noiseCorr *= noiseCorr/4;
            } */
        }
        curveVertex(x+scaleMargin+(i-1)*scale*(freq/100.0),  map(data[i]*scale*(amp/100.0)-int(noiseCorr), 0,1024, y+h-scaleMargin, y));
    }
    endShape();
    GPIO.interrupts();

    //Cover up overshooting curve top and bottom
    fill(mainBg);
    noStroke();
    rect(x+21, y+h-scaleMargin, w-scaleMargin, wHeight);
    rect(x+21, 0, w-scaleMargin, y);

    strokeWeight(lineWeight);
};

PImage ghostingCopy(int x, int y, int w, int h) {
    return get(x, y, w, h);
}
void ghostingPaste(PImage img, int x, int y, int w, int h) {
    image(img, x+scaleMargin, y-scaleMargin);
}

void drawFakeApplicationNonsense() {
    textAlign(RIGHT);
    fill(mainFontColor);
    String text1 = "My fake application is running on a cheesburger";
    text(text1, right(0,25), wHeight-10);
    textAlign(LEFT);
}