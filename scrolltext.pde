int scrollIndex = 0;
long nextText = 0;
boolean fin = false;

void scrollText(String[] data, int interval, int accuracy, int x, int y, int w, int h, boolean cursor) {
    if(DEBUG) {
        stroke(mainFontColor);
        fill(0,0,0,0);
        rect(x,y, w,h);
    }

    for (int i = 0; i < scrollIndex+1; i++) {
        // TODO: deletes text after out of bounds
        if(i < data.length) {
            // When text is longer than screen, correct for scrolling.
            int corr = scrollIndex * lineHeight > h ? (scrollIndex+1-(h/lineHeight))*lineHeight : 0;
            int marginTop = lineHeight + y + i * lineHeight - corr;
            fill(mainFontColor);
            if(marginTop > y) {  // cut off lines above starting point when scrolling
                text(data[i], x, marginTop);
            }
        }
        // Cursor at the end
        if(i == data.length-1 && cursor) {
            if (millis() % 1000 <= 500) {
                fill(mainFontColor, 100);
                noStroke();
                rect(textWidth(data[i]) + x + fontSize/3, y + i * lineHeight + lineHeight/2.5, fontSize/1.75, fontSize/1.1);
            }
        }
    }

    if (nextText < millis() && scrollIndex < data.length-1) {
        println("next line " + scrollIndex);
        float accuracyMargin = interval*(accuracy/100);
        nextText = millis()+int(random(interval-accuracyMargin, interval+accuracyMargin));
        scrollIndex++;
    }

    if(stage == 2 && scrollIndex == data.length-1) {
        nextStage();
        println("booted_up");
    }
    if(stage == 6 && scrollIndex == data.length-1 && !fin) {
        println("FIN");
        // TODO: sends this when first monitor reaches end of text
        udp.send("sync_end_of_thoughts", ip, port );
        fin = true;
    }
}