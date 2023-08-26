#include <Servo.h>
#include <Wire.h>

// #include <LiquidCrystal_I2C.h>
// LiquidCrystal_I2C lcd(0x27, 2, 1, 0, 4, 5, 6, 7, 3, POSITIVE);


Servo myservo;

#define ir_entry 2
#define ir_exit 4

#define ir_avail0 9
#define ir_avail1 10
#define ir_car1 5
#define ir_car2 6


int slot1Occupied = 0, slot2Occupied = 0;

bool didEntryOpen = 0;

int availSlots = 2;
int total_slots = 2;
int d_slot1 = 12;
int d_slot2 = 13;

bool carAtEntry = 0;
bool carAtExit = 0;
bool lastTimeCarAtEntry = 0;
bool lastTimeCarAtExit = 0;

bool isFatakOpen = 0;

bool isSleepTimestampSet = 0;
unsigned long sleepStartTimestamp = 0;
int sleepDurationMs = 2000;

enum State { s_idle, s_inEntry, s_inExit, s_sleep };

State state = s_idle;

void setup() {
  Serial.begin(9600);

  pinMode(ir_car1, INPUT);
  pinMode(ir_car2, INPUT);

  pinMode(ir_entry, INPUT);
  pinMode(ir_exit, INPUT);

  pinMode(d_slot1, OUTPUT);
  pinMode(d_slot2, OUTPUT);

  pinMode(ir_avail0,OUTPUT);
  pinMode(ir_avail1,OUTPUT);

  myservo.attach(3);
  myservo.write(180);

  Read_Sensor();
  availSlots = total_slots;
  availSlots -= slot1Occupied + slot2Occupied;

  state = s_idle;
}

// void toggleFatak() {
//   if (isFatakOpen) {
//     myservo.write(180);
//   }
//   else {
//     myservo.write(90);
//   }

//   isFatakOpen = !isFatakOpen;
// }

void openFatak() { myservo.write(90); }
void closeFatak() { myservo.write(180); }

void loop() {

  Read_Sensor();
  digitalWrite(ir_avail0, (availSlots / 2));
  digitalWrite(ir_avail1, (availSlots % 2));
  // lastTimeCarAtEntry = carAtEntry;
  // lastTimeCarAtExit = carAtExit;

  carAtEntry = digitalRead(ir_entry);
  carAtExit = digitalRead(ir_exit);

  if (state == s_sleep)
  {
    if (!isSleepTimestampSet)
    {
      isSleepTimestampSet = true;
      sleepStartTimestamp = millis();
    }

    if (sleepStartTimestamp < millis() - sleepDurationMs)
    {
      state = s_idle;
      isSleepTimestampSet = false;
    } 
  }
  if (state == s_idle)
  {
    if (carAtEntry && availSlots > 0)
    {
      state = s_inEntry;
      openFatak();
    }
    else if (carAtExit && availSlots < total_slots)
    {
      state = s_inExit;
      openFatak();
    }
  }
  else if (state == s_inEntry)
  {
    Serial.println(carAtExit);
    if (carAtExit)
    {
      closeFatak();
      availSlots--;
      state = s_sleep;
    }
  }
  else if (state == s_inExit)
  {
    if (carAtEntry)
    {
      closeFatak();
      availSlots++;
      state = s_sleep;
    }
  }
}

void Read_Sensor() {
  slot1Occupied = 0, slot2Occupied = 0;

  if (digitalRead(ir_car1) == 1) {
    digitalWrite(d_slot1, 1);
    Serial.println(digitalRead(12));
    // digitalRead(d_slot1);
  }
  else if (digitalRead(ir_car1) == 0) {
    digitalWrite(d_slot1, 0);
    Serial.println(digitalRead(12));
    // digitalRead(d_slot1);
  }

  if (digitalRead(ir_car2) == 1) {
    digitalWrite(d_slot2, 1);
    Serial.println(digitalRead(13));
    // digitalRead(d_slot2);
  }
  else if (digitalRead(ir_car2) == 0) {
    digitalWrite(d_slot2, 0);
    Serial.println(digitalRead(13));
    // digitalRead(d_slot2);
  }
}