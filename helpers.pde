// DISPLAY HELPERS

int centerX(int widthObject) {
  return width/2-widthObject/2;
}

// center between points
int centerX(int widthObject, int minX, int maxX) {
  return (maxX-minX)/2+minX-widthObject/2;
}

int centerY(int heightObject) {
  return wHeight/2-heightObject/2;
}

// center between points
int centerY(int heightObject, int minY, int maxY) {
  return (maxY-minY)/2+minY-heightObject/2;
}

int right(int widthObject, int margin) {
  return width-margin-widthObject;
}

int bottom(int heightObject, int margin) {
  return wHeight-margin-heightObject;
}

void centerText(String text, int y) {
    centerText(text, y, mainFontColor);
}
void centerText(String text, int y, color fontColor) {
  fill(fontColor);
  text(text, centerX(int(textWidth(text))), y);
}

void centerText(String text, int y, int minX, int maxX) {
  centerText(text, y, minX, maxX, mainFontColor);
}

void centerText(String text, int y, int minX, int maxX, color fontColor) {
    fill(fontColor);
  text(text, centerX(int(textWidth(text)), minX, maxX), y);
}

boolean isAboutEqual(int a, int b, int errorMargin) {
    return a < b+errorMargin && a > b-errorMargin;
}

int clamp(int value, int min, int max) {
  return value < min ? min : value > max ? max : value;
}

public static float round(float number, int scale) {
    int pow = 10;
    for (int i = 1; i < scale; i++)
        pow *= 10;
    float tmp = number * pow;
    return ( (float) ( (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) ) ) / pow;
}


String popUpText = "";
long popUpTimeout = 0;
int popUpX = 0;
int popUpY = 0;

void popUp(String text, int x, int y, int timeOut) {
  textSize(fontSize*1.25);
  int w = int(textWidth(text));
  int h = lineHeight;
  stroke(mainBg);
  fill(mainBg);
  rect(x-(w+110)/2,y-h-5, w+110,h*2+10, 5);

  fill(mainFontColor);
  rect(x-(w+100)/2,y-h, w+100,h*2, 5);

  textAlign(CENTER);
  fill(mainBg);
  text(text, x, y+h/4);
  textAlign(LEFT);
  textSize(fontSize);
  
  if(timeOut>0){
    popUpText = text;
    popUpTimeout = millis()+timeOut;
    popUpX = x;
    popUpY = y;
  }
}

void popUpAfterglow() {
  if(millis() < popUpTimeout) {
    popUp(popUpText,  popUpX,  popUpY, 0);
  } else {
    popUpText = "";
    popUpTimeout = 0;
    popUpX = 0;
    popUpY = 0;
  }
}

void popUp(String text, int timeOut) {
  popUp(text, width/2, wHeight/2, timeOut);
}

void popUp(String text, int x, int timeOut) {
  popUp(text, x, wHeight/2, timeOut);
}