#include "FS.h"
#include "SD.h"
#include "SPI.h"
#include <Adafruit_BMP280.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include "soc/soc.h"
#include "soc/rtc_cntl_reg.h"
#include "WiFi.h"
#include "ESPAsyncWebServer.h"
String datta;
Adafruit_MPU6050 mpu;
Adafruit_BMP280 bmp;
#define TRIGPIN 12
#define ECHOPIN 13
float duration,distance;
AsyncWebServer server(80);
void setup() {
  WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0);
  pinMode(ECHOPIN, INPUT);
  pinMode(TRIGPIN, OUTPUT);
    Serial.begin(9600);
  if (!bmp.begin(0x76)) { 
    while (1)
    {
      Serial.println("err_bmp280");
      delay(500);
    }
  }
  if (!mpu.begin()) {  
    while (1) 
    {
      Serial.println("err_mpu6050");
      delay(500);
    }
  }
  mpu.setAccelerometerRange(MPU6050_RANGE_2_G);
  mpu.setGyroRange(MPU6050_RANGE_250_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);
  
  delay(100);
  WiFi.softAP("Parapanta", "Parapanta");
  server.on("/date", HTTP_GET, [](AsyncWebServerRequest * request) {
    request->send_P(200, "text/plain", getdata().c_str());
  });
  server.begin();
}


String getdata()
{
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);
  digitalWrite(TRIGPIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIGPIN, HIGH);
  delayMicroseconds(20);
  digitalWrite(TRIGPIN, LOW);
  duration = pulseIn(ECHOPIN, HIGH);
  distance = (duration / 2) * 0.343;
  datta = (String)bmp.readTemperature() + ',' + (String)(bmp.readPressure()/100) + ',' + (String)distance + ',' + (String)a.acceleration.x + ',' + (String)a.acceleration.y + ',' + (String)a.acceleration.z + ',' + (String)g.gyro.x + ',' + (String)g.gyro.y + ',' + (String)g.gyro.z;
  return datta; 
}

void loop()
{
  delay(1);
}
