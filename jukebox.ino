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
int count = 0;
int coinPin = 2;
int pulse = 0;

void setup() {
  // Debugging output
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
    String credits = String(count);
    lcd.print("CREDITS: " + credits);
    lcd.setCursor(0,1);
    lcd.print("INSERT COIN    ");
    delay(5000);
    lcd.clear();
    lcd.setCursor(0,0);  
    lcd.print("NOW PLAYING:");
    lcd.setCursor(0,1);
    lcd.print("DISC 04 SONG 02");
    delay(5000);
    lcd.clear();
  }
  while (count > 0) {
    String credits = String(count);
    lcd.setCursor(0,0);
    lcd.print("CREDITS: " + credits + "  ");
    lcd.setCursor(0,1);
    lcd.print("SELECTION: " + track);
    trackEntry();    
  }
}

void addCredits() {
  pulse = pulse + 1;
  while (pulse == 5) {
    count = count + 1; 
    pulse = 0; 
  }
}

void trackEntry(){
  String key = String(keypad.getKey());
  if (key != NO_KEY) {
    while (track.length() < 4) {
      track += key;
      Serial.println(track); 
    }
    while (track.length() == 4) {
      String key = String(keypad.getKey());
      if (key != NO_KEY) {
        track = key;
      }
    }
  }    
}





