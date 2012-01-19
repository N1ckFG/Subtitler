//***************************************
// useBreakChars ignores line breaks; better for large amounts of text.
// Turn off to use line breaks; better for precision.
boolean useBreakChars = false;  
//***************************************

String[] textFile;
String textBreak = "*.,…!—"; 
// note the ellipsis character; don't use three dots.
// char in position 0, default *, makes a break without being printed in output.
String textSource;
String textBuffer = "";
String[] textArray;
int numLines = 0;
int numCurrent = 0;
int numDisplay = 0;

PFont font;
int fontSize = 28;
String fontFace = "Gill Sans";
color textColor = color(255,200,0);

int sW = 720;
int sH = 540;
float margins = 0.70; //1.0 goes to the edge of the screen.

float posX = sW/2;
float posY = (sH*margins)+((sH*(1.0-margins))/2);
boolean showGuides = true;
boolean recordMode = false;
float crossHairSize = sW/60;
float delaySecMax = 0.33; // 1.0 = 1 sec
float delaySecMin = 0;
float delaySecNow = delaySecMax;

String fileName = "foo";
String filePath = "render";
String fileType = "png";
int startNum = 1;

//----------------------------------------
//----------------------------------------

void setup() {
  size(sW,sH);
  smooth();
  font = createFont(fontFace,fontSize);
  textFile = loadStrings("test.txt");
  initArray();
}

//---

void draw() {
  background(0);
  drawArray();
  drawGuides();
  delay(int(delaySecNow * 1000));
}

//----------------------------------------
//----------------------------------------

void keyPressed() {
  if(key==' ') {
    if(recordMode) {
      recordOff();
    }
    else if(!recordMode) {
      recordOn();
    }
  }
}

void recordOff() {
  recordMode=false;
  showGuides=true;
  delaySecNow = delaySecMax;
  numDisplay=0;
}

void recordOn() {
  recordMode=true;
  showGuides=false;
  delaySecNow = delaySecMin;
  numDisplay=0;
}

void drawGuides() {
  if(showGuides) {
    strokeWeight(1);
    stroke(255);
    noFill();
    rectMode(CENTER);
    rect(sW/2,sH/2,sW*margins,sH*margins);
    drawCrossHairs(sW/2,sH/2,crossHairSize);
    drawCrossHairs(posX,posY,crossHairSize);
  }
}

void drawCrossHairs(float _posX, float _posY, float _width) {
  line(_posX,_posY-(_width),_posX,_posY+(_width));
  line(_posX-(_width),_posY,_posX+(_width),_posY);
}

void drawArray() {
  fill(textColor);
  textAlign(CENTER);
  textFont(font,fontSize);
  text(textArray[numDisplay],posX,posY);
  if(recordMode) {
    String q = filePath + "/" + fileName + "_" + (numDisplay+startNum) + "." + fileType;
    saveFrame(q);
    println("saved " + q);
  }
  if(numDisplay<numLines-1) {
    numDisplay++;
  }
  else {
    recordOff();
  }
}

//---

void initArray() {
  if(useBreakChars) {
    textSource = join(textFile,' ');
    for(int i=0;i<textSource.length();i++) {
      for(int j=0;j<textBreak.length();j++) {
        if(textSource.charAt(i)==textBreak.charAt(j)) {
          numLines++;
        }
      }
    }
    println("Counting break characters...lines found: " + numLines);
    println("Press SPACE to record.");
    textArray = new String[numLines];


    for(int k=0;k<textSource.length();k++) {
      boolean q = false;
      String qq = "";

      for(int l=0;l<textBreak.length();l++) {
        if(!q) {
          if(textSource.charAt(k)!=textBreak.charAt(l)) {
            q=false;
          } 
          else {
            q=true;
            if(textSource.charAt(k)==textBreak.charAt(0)) {// char in position 0, default *, makes a break without being printed in output.
              qq="";
            }
            else {
              qq=""+textBreak.charAt(l);
            }
          }
        }
      }

      if(!q) {
        textBuffer += textSource.charAt(k);
      } 
      else if(q) {
        q=false;
        textArray[numCurrent] = textBuffer+qq;
        textBuffer="";
        numCurrent++;
      }
    }
  } 
  else {
    numLines=textFile.length;
    textArray = textFile;
    println("Counting line breaks...lines found: " + numLines);
    println("Press SPACE to record.");
  }
}

//---   END   ---

