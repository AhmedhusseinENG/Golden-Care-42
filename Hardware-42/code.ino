#include <Wire.h>
#include <MAX30105.h>
#include <heartRate.h>
#include <spo2_algorithm.h>
#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#include <time.h>

// WiFi
#define WIFI_SSID "TEdata"
#define WIFI_PASSWORD "21112003HTs"

// Firebase
#define FIREBASE_HOST "https://goldencare-68364-default-rtdb.firebaseio.com/"
#define FIREBASE_API_KEY "AIzaSyC_9DMn_FT58REj0D0jhw7LBb3e4CAAgAU"
#define FIREBASE_USER_EMAIL "slmyhmdy@gmail.com"
#define FIREBASE_USER_PASSWORD "Husealm123"

FirebaseData firebaseData;
FirebaseAuth auth;
FirebaseConfig config;

MAX30105 particleSensor;
#define ECG_PIN A0

const int bufferLength = 125;
uint32_t irBuffer[bufferLength];
uint32_t redBuffer[bufferLength];
int ecgBuffer[bufferLength];

int32_t spo2 = 0, heartRate = 0;
int8_t validSpO2 = 0, validHeartRate = 0;

void setupWiFi() {
  Serial.println(" Connecting to WiFi...");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  int retries = 0;
  while (WiFi.status() != WL_CONNECTED && retries < 20) {
    delay(500);
    Serial.print(".");
    retries++;
  }
  if (WiFi.status() == WL_CONNECTED) Serial.println("\n✅ WiFi connected!");
  else Serial.println("\n❌ Failed to connect to WiFi!");
}

void initFirebase() {
  Serial.println(" Initializing Firebase...");
  config.api_key = FIREBASE_API_KEY;
  config.database_url = FIREBASE_HOST;
  auth.user.email = FIREBASE_USER_EMAIL;
  auth.user.password = FIREBASE_USER_PASSWORD;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void setupSensor() {
  Serial.println(" Initializing MAX30102 sensor...");
  if (!particleSensor.begin(Wire, I2C_SPEED_STANDARD)) {
    Serial.println("❌ MAX30102 not found! Check wiring.");
    while (1);
  }

  Serial.println("✅ MAX30102 initialized.");

  particleSensor.setup(60, 4, 2, 411, 4096, 100);
  particleSensor.setPulseAmplitudeRed(0x24);
  particleSensor.setPulseAmplitudeIR(0x24);
  particleSensor.setPulseAmplitudeGreen(0);
}

void sendDataToFirebase(int hr, int spo2, int* ecgSeq, uint32_t* irSeq) {
  if (hr == -999 || spo2 == -999) {
    Serial.println("⚠ Skipping invalid data, not sending to Firebase.");
    return;
  }

  time_t now = time(nullptr);
  struct tm* timeInfo = localtime(&now);
  char timestamp[25];
  strftime(timestamp, sizeof(timestamp), "%Y-%m-%dT%H:%M:%S", timeInfo);
  String readableTimestamp = String(timestamp);

  String uniqueKey = readableTimestamp + "_" + String(millis() % 1000);
  String basePath = "/patients/patient_123/readings/" + uniqueKey;
  String latestPath = "/patients/patient_123/readings/latest";

  if (Firebase.ready()) {
    Serial.println(" Sending data to Firebase...");

    String ecgStr = "", irStr = "";
    for (int i = 0; i < bufferLength; i++) {
      ecgStr += String(ecgSeq[i]);
      irStr += String(irSeq[i]);
      if (i != bufferLength - 1) {
        ecgStr += ",";
        irStr += ",";
      }
    }

    // حفظ القراءة بالتوقيت الفريد
    Firebase.setInt(firebaseData, basePath + "/heart_rate", hr);
    Firebase.setInt(firebaseData, basePath + "/spo2", spo2);
    Firebase.setString(firebaseData, basePath + "/ecg_sequence", ecgStr);
    Firebase.setString(firebaseData, basePath + "/ppg_ir_sequence", irStr);
    Firebase.setString(firebaseData, basePath + "/timestamp", readableTimestamp);

    // تحديث بيانات الـ latest
    Firebase.deleteNode(firebaseData, latestPath);
    Firebase.setInt(firebaseData, latestPath + "/heart_rate", hr);
    Firebase.setInt(firebaseData, latestPath + "/spo2", spo2);
    Firebase.setString(firebaseData, latestPath + "/ecg_sequence", ecgStr);
    Firebase.setString(firebaseData, latestPath + "/ppg_ir_sequence", irStr);
    Firebase.setString(firebaseData, latestPath + "/timestamp", readableTimestamp);

    Serial.println("✅ Data sent to Firebase.");
  } else {
    Serial.println("❌ Firebase not ready.");
  }
}

void setup() {
  Serial.begin(115200);
  delay(1000);
  Serial.println(" Starting setup...");

  setupWiFi();

  // إعداد الوقت الفعلي عبر NTP
  configTime(2 * 3600, 0, "pool.ntp.org", "time.nist.gov"); // UTC+2
  Serial.print("Waiting for NTP time sync...");
  while (time(nullptr) < 100000) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\n⏰ Time synchronized!");

  initFirebase();
  setupSensor();
  pinMode(ECG_PIN, INPUT);

  Serial.println(" Waiting 5s for sensor stabilization...");
  delay(5000);
  Serial.println("Setup complete!");
}

void loop() {
  bool stuck = true;
  Serial.println("Reading sensor data...");

  for (int i = 0; i < bufferLength; i++) {
    while (!particleSensor.check()) {
      delay(1);
    }

    redBuffer[i] = particleSensor.getRed();
    irBuffer[i] = particleSensor.getIR();
    ecgBuffer[i] = analogRead(ECG_PIN);

    if (redBuffer[i] != 262143 && irBuffer[i] != 262143) {
      stuck = false;
    }

    delay(8);
  }

  if (stuck) {
    Serial.println(" Sensor stuck! (All values = 262143)");
    return;
  }

  int totalHR = 0, totalSpO2 = 0;
  int validCount = 0;

  for (int i = 0; i < 5; i++) {
    maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer,
                                           &spo2, &validSpO2, &heartRate, &validHeartRate);

    if (validSpO2 && validHeartRate) {
      totalHR += heartRate;
      totalSpO2 += spo2;
      validCount++;
    }
    delay(50);
  }

  if (validCount > 0) {
    heartRate = totalHR / validCount;
    spo2 = totalSpO2 / validCount;
  } else {
    heartRate = -999;
    spo2 = -999;
  }

  Serial.printf("❤ HR: %d bpm | SpO2: %d%%\n", heartRate, spo2);
  sendDataToFirebase(heartRate, spo2, ecgBuffer, irBuffer);

  delay(1000);
}
