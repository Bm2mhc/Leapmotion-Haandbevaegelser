//This demo triggers a letter display with each new message
// Works with 1 classifier output, any number of classes
//Listens on port 11500 for message /wek/outputs (defaults)

//Nødvændig for kommuiaktion med Wekinator
import oscP5.*;
import netP5.*;
OscP5 oscP5;
String[] letters = {"A","B","C","D","E", "F", "G", "H", "I", "J","K", "L", "M","N", "O", "P", "Q", "R", "S", "T",
                     "U","V", "W", "X", "Y", "Z ", "-"};


PFont skriftType, skriftTypeSTOR;
final int myHeight = 400;
final int myWidth = 400;
int frameNum = 0;
int currentHue = 100;
int currentTextHue = 255;
String currentMessage = "";


void setup() {
  //Opsætter kommunikation med Wekinator
  oscP5 = new OscP5(this,11500); //Lytter efter OSC beskeder på port 11500
 
  
  //opsætning af sketch
  colorMode(HSB);
  size(400,400, P3D);
  smooth();
  background(255);
  
  skriftType = createFont("Arial", 16);
  skriftTypeSTOR = createFont("Arial", 60);
}

void draw() {
  frameRate(30);
  background(currentHue, 255, 255);
  drawText();
}

//Automatisk kaldt når OSC message modtages.
void oscEvent(OscMessage theOscMessage) {
 println("received message");
    if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
      if(theOscMessage.checkTypetag("f")) {
      float f = theOscMessage.get(0).floatValue();
      
       showMessage((int)f);
      }
    }
 
}
void showMessage(int i) {
    currentHue = (int)generateColor(i);
    currentTextHue = (int)generateColor((i+1));
    currentMessage = letters[i-1];
}

//Skriver information på skærmen
void drawText() {
    stroke(0);
    textFont(skriftType);
    textAlign(LEFT, TOP); 
    fill(currentTextHue, 255, 255);

    text("Receives 1 classifier output message from wekinator", 10, 10);
    text("Listening for OSC message /wek/outputs, port 11500", 10, 30);
    
    textFont(skriftTypeSTOR);
    text(currentMessage, 190, 180);
}


float generateColor(int which) {
  
  int i = which;
  if (i <= 0) {
     return 100;
  } 
  else {
     return (generateColor(which-1) + 1.61*255) %255; 
  }
}
