// #if defined(ESP32)

// #include <WiFi.h>

// #elif defined(ESP8266)

#include <ESP8266WiFi.h>
// #endif

#include <Firebase_ESP_Client.h>

// Provide the token generation process info.
#include <addons/TokenHelper.h>

// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "Rayan"
#define WIFI_PASSWORD "Rayan007@"

// For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino

/* 2. Define the API Key */
#define API_KEY "AIzaSyB4cTuEbjigR2eixF5DOzpAZ4yWKoR_jzo"

/* 3. Define the RTDB URL */
#define DATABASE_URL "comms-car-parking-default-rtdb.asia-southeast1.firebasedatabase.app" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app

/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "aman@example.com"
#define USER_PASSWORD "testpass123"

// Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;

unsigned long count = 0;

int d_slot1 = 0, d_slot2 = 0, d_avail = 0, d_avail1, d_avail0;
bool sVal = false;
bool slot1Prev, slot2Prev;

void setup()
{

  Serial.begin(115200);


  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h


#if defined(ESP8266)
  // In ESP8266 required for BearSSL rx/tx buffer for large data handle, increase Rx size as needed.
  fbdo.setBSSLBufferSize(2048 /* Rx buffer size in bytes from 512 - 16384 */, 2048 /* Tx buffer size in bytes from 512 - 16384 */);
#endif

  // Limit the size of response payload to be collected in FirebaseData
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);

  // Comment or pass false value when WiFi reconnection will control by your code or third party library
  Firebase.reconnectWiFi(true);

  Firebase.setDoubleDigits(5);

  config.timeout.serverResponse = 10 * 1000;

  Firebase.RTDB.setInt(&fbdo, F("/test/avail"), d_avail); // initialising available slots data
}


void loop() {
  // put your main code here, to run repeatedly:
  Serial.println(digitalRead(5));
  Serial.println(digitalRead(4));
  Serial.println(digitalRead(14));
  readSlots();
  if (d_slot1 != slot1Prev || d_slot2 != slot2Prev)
    writeSlots();
  Firebase.RTDB.setInt(&fbdo, F("/test/avail"), d_avail);
}



void writeSlots(){
  if(d_slot1 == 1){
    slot1Prev = 1;
    // if(d_avail != 0){
    //   --d_avail;
    //   Firebase.RTDB.setInt(&fbdo, F("/test/avail"), d_avail);
    // }
    Firebase.RTDB.setBool(&fbdo, F("/test/Slot1"), !&sVal);
  }
  else if(d_slot1 == 0){
    slot1Prev = 0;
    // if(d_avail != 2){
    //   ++d_avail;
    //   Firebase.RTDB.setInt(&fbdo, F("/test/avail"), d_avail);
    // }
    Firebase.RTDB.setBool(&fbdo, F("/test/Slot1"), &sVal);
  }
  if(d_slot2 == 1){
    slot2Prev = 1;
    // if(d_avail != 0){
    //   --d_avail;
    //   Firebase.RTDB.setInt(&fbdo, F("/test/avail"), d_avail);
    // }
    Firebase.RTDB.setBool(&fbdo, F("/test/Slot2"), !&sVal);
  }
  else if(d_slot2 == 0){
    slot2Prev = 0;
    // if(d_avail != 2){
    //   ++d_avail;
    //   Firebase.RTDB.setInt(&fbdo, F("/test/avail"), d_avail);
    // }
    Firebase.RTDB.setBool(&fbdo, F("/test/Slot2"), &sVal);
  }
  
}

void readSlots(){
  d_slot1 = digitalRead(5);  
  d_slot2 = digitalRead(4);
  d_avail0 = digitalRead(12);
  d_avail1 = digitalRead(14);
  d_avail = d_avail0*2 + d_avail1;
}