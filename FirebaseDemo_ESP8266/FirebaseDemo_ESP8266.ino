
// FirebaseDemo_ESP8266 is a sample that demo the different functions
// of the FirebaseArduino API.

#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include <OneWire.h>
#include <DallasTemperature.h>

// Set these to run example.
#define FIREBASE_HOST "esp8266-project-f2fc7-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "fDE6quibaeUch9MQfoEaNH0Gxvm8zU5DCAWQYiUY"

// ----- Usuário ----- 
#define WIFI_SSID ""
// ----- Senha ----- 
#define WIFI_PASSWORD ""

// O fio de dados é conectado no pino digital 2 no Arduino
#define ONE_WIRE_BUS D5
#define ONE_WIRE_MAX_DEV 4 //The maximum number of devices

// Prepara uma instância oneWire para comunicar com qualquer outro dispositivo oneWire
OneWire oneWire(ONE_WIRE_BUS);  
// Passa uma referência oneWire para a biblioteca DallasTemperature
DallasTemperature DS18B20(&oneWire);

int numberOfDevices; //Number of temperature devices found
DeviceAddress devAddr[ONE_WIRE_MAX_DEV];  //An array device temperature sensors
float tempDev[ONE_WIRE_MAX_DEV]; //Saving the last measurement of temperature

void setup() {
  Serial.begin(9600);

  // connect to wifi.
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());
  
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);

  DS18B20.begin();
  SetupDS18B20();
}

//Convert device id to String
String GetAddressToString(DeviceAddress deviceAddress){
  String str = "";
  for (uint8_t i = 0; i < 8; i++){
    if( deviceAddress[i] < 16 ) str += String(0, HEX);
    str += String(deviceAddress[i], HEX);
  }
  return str;
}

//Setting the temperature sensor
void SetupDS18B20(){
  numberOfDevices = DS18B20.getDeviceCount();
  Serial.print( "Device count: " );
  Serial.println( numberOfDevices );
  Serial.println("");

  DS18B20.requestTemperatures();

  // Loop through each device, print out address
  for(int i=0;i<numberOfDevices; i++){
    // Search the wire for address
    if( DS18B20.getAddress(devAddr[i], i) ){
      Serial.print("Found device ");
      Serial.print(i+1, DEC);
      Serial.print(" with address: " + GetAddressToString(devAddr[i]));
      Serial.println();
    }else{
      Serial.print("Found ghost device at ");
      Serial.print(i, DEC);
      Serial.print(" but could not detect address. Check power and cabling");
    }

    //Get resolution of DS18b20
    Serial.print("Resolution: ");
    Serial.print(DS18B20.getResolution( devAddr[i] ));
    Serial.println();

    //Read temperature from DS18b20
    float tempC = DS18B20.getTempC( devAddr[i] );
    Serial.print("Temp C: ");
    Serial.println(tempC);
    Serial.println();
    Serial.println("-------------------");
    Serial.println();
  }

}

void loop() {
  // set value
  // Escreve a temperatura em Celsius
  for(int i=0;i<numberOfDevices; i++){
    Serial.print("Temperatura: ");
    float tempC = DS18B20.getTempC( devAddr[i] );
    Serial.print(tempC);
    Serial.println(" graus");

    String tempName = "Temp" + String(i+1);
    
    Firebase.setFloat(tempName, tempC);
    // handle error
    if (Firebase.failed()) {
        Serial.print("setting /number failed:");
        Serial.println(Firebase.error());
        return;
    }
  }
  delay(1000);
}
