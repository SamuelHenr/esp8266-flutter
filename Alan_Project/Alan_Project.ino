#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <OneWire.h>
#include <DallasTemperature.h>

// O fio de dados é conectado no pino digital 2 no Arduino
#define ONE_WIRE_BUS D5

// Prepara uma instância oneWire para comunicar com qualquer outro dispositivo oneWire
OneWire oneWire(ONE_WIRE_BUS);  
// Passa uma referência oneWire para a biblioteca DallasTemperature
DallasTemperature sensors(&oneWire);

/* Set these to your desired credentials. */
const char *ssid = "SERGIOFAMILIA";
const char *password = "anastacio123";

float tempc, potenciometro;

ESP8266WebServer server(80);

void handleRoot() {
  // Sending sample message if you try to open configured IP Address
  server.send(200, "text/html", "<h1>You are connected</h1>");
}

void setup() {
  pinMode(BUILTIN_LED, OUTPUT);
  delay(1000);
  Serial.begin(9600);
  
  //Trying to connect to the WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print("*");
  }

  // Setting IP Address to 192.168.1.200, you can change it as per your need, you also need to change IP in Flutter app too.
  
  IPAddress ip(192, 168, 1, 200);
  IPAddress gateway(192, 168, 1, 1);
  IPAddress subnet(255, 255, 255, 0);
  WiFi.config(ip, gateway, subnet);
  Serial.println(WiFi.localIP());

  server.on("/", handleRoot);
  server.on("/temperature", readTemp);
  server.begin();
  Serial.println("HTTP server started");
}

void readTemp() {

  // Manda comando para ler temperaturas
  sensors.requestTemperatures();
  // Escreve a temperatura em Celsius
  Serial.print("Temperatura: ");
  Serial.print(sensors.getTempCByIndex(0));
  Serial.println(" graus");
    
  float t1 = sensors.getTempCByIndex(0);
  float t2 = random(0, 50);
  float t3 = random(0, 50);
  float t4 = random(0, 50);

  server.send(200, "text/plain", String(t1)+"/"+String(t2)+"/"+String(t3)+"/"+String(t4));
}

void loop() {

  // Manda comando para ler temperaturas
  sensors.requestTemperatures();
  // Escreve a temperatura em Celsius
  Serial.print("Temperatura: ");
  Serial.print(sensors.getTempCByIndex(0));
  Serial.println(" graus");
  server.handleClient();

  delay(1000);
}
