#include <Keypad.h>
#include <Wire.h>
#include <Adafruit_MCP23017.h>
#include <Adafruit_RGBLCDShield.h>

Adafruit_RGBLCDShield lcd = Adafruit_RGBLCDShield();

// These #defines make it easy to set the backlight color
#define RED 0x1
#define YELLOW 0x3
#define GREEN 0x2
#define TEAL 0x6
#define BLUE 0x4
#define VIOLET 0x5
#define WHITE 0x7

// String for track number
String track;
//Empty string to clear other strings
String nil;
// String for current track
String current_track;
boolean stringComplete = false;  // whether the string is complete

//Matrix Keypad Setup
const byte ROWS = 4; 
const byte COLS = 3;
char keys[ROWS][COLS] = {
  {'1','2','3'},
  {'4','5','6'},
  {'7','8','9'},
  {'*','0','#'}
};
byte rowPins[ROWS] = { 4, 5, 6, 7 };
byte colPins[COLS] = { 8, 9, 10 };

Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );

//Coin/Credit Setup
int count = 1;
int coinPin = 2;
int pulse = 0;

void setup() {
  Serial.begin(9600);
  // set up the LCD's number of columns and rows: 
  lcd.begin(16, 2);
  pinMode(coinPin, INPUT);
  lcd.print("HELLO");
  lcd.setBacklight(YELLOW);
  attachInterrupt(0, addCredits, RISING);
}
uint8_t i=0;
void loop() {
  uint8_t buttons = lcd.readButtons();
  while (count == 0) {
    lcd.setCursor(0,0);
    lcd.setBacklight(TEAL);  
    String credits = String(count);
    lcd.print("CREDITS: " + credits);
    lcd.setCursor(0,1);
    lcd.print("INSERT COIN    ");
    Serial.println("done");
    delay(2500);
    lcd.clear();
    lcd.setBacklight(VIOLET);  
    lcd.setCursor(0,0);  
    lcd.print("NOW PLAYING:");
    lcd.setCursor(0,1);
    nowPlaying();
    lcd.print(current_track);
    delay(2500);
    lcd.clear();
  }
  while (count > 0) {
    String credits = String(count);
    lcd.setBacklight(GREEN);      
    lcd.setCursor(0,0);
    lcd.print("CREDITS: " + credits + "  ");
    lcd.setCursor(0,1);
    lcd.print("SELECTION: " + track);
    if (track.length() < 4) {
      String key = String(keypad.getKey());
      if (key != NO_KEY) {
        track += key;
        lcd.setCursor(0,1);
        lcd.print("SELECTION: " + track);
      }
    }
    while (track.length() == 4) {
      Serial.println(track);
      delay(1000);
      char track_found = (char)Serial.read();
      if (track_found==('n')) {
        lcd.clear();
        lcd.setBacklight(RED);
        lcd.print("TRACK NOT FOUND!");
        lcd.setCursor(0,1);
        lcd.print("Try Again");
        delay(1000); 
        track = nil;
        lcd.clear();
        break;
      }
      else if (track_found==('y')) {
        count--;     
        String credits = String(count);
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("CREDITS: " + credits + "  ");
        lcd.setCursor(0,1);
        lcd.print("Thank You      ");
        delay(1000);
        track = nil;
        break; 
      }
    }
  }
}
void addCredits() {
  pulse++;
  while (pulse == 5) {
    count = count++; 
    pulse = 0; 
  }
}

void nowPlaying() {
      current_track = nil;
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read(); 
    // add it to the inputString:
      current_track += inChar;
    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inChar == '\n') {
      stringComplete = true;
    } 
  }
}
