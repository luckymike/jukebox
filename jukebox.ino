#include <Keypad.h>

String track;

const byte ROWS = 4; 
const byte COLS = 3;
char keys[ROWS][COLS] = {
  {'1','2','3'},
  {'4','5','6'},
  {'7','8','9'},
  {'*','0','#'}
};
byte rowPins[ROWS] = {12, 11, 10};
byte colPins[COLS] = {9, 8, 7};

Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );

void setup(){
  Serial.begin(9600);
}

void loop(){
  while (track.length() < 4) {
    String key = String(keypad.getKey());
    if (key != NO_KEY) {
      track += key;
      if (track.length() ==4) {
        Serial.println(track); 
      }
    }
  }
  while (track.length() == 4) {
    String key = String(keypad.getKey());
    if (key != NO_KEY) {
      track = key;
    }
  }    
}

