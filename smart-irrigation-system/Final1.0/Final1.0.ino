int water;  // Variable to store the soil moisture sensor reading
bool manualOverride = false;  // Manual override flag
bool relayState = LOW;  // Current state of the relay

const int relayPin = 3;     // Output pin for the relay
const int sensorPin = A0;   // Analog pin connected to the soil sensor
const int manualButtonPin = 7;  // Digital pin connstatected to the manual toggle button

void setup() {
  pinMode(relayPin, OUTPUT);  // Output pin for the relay
  pinMode(sensorPin, INPUT);  // Analog pin for soil sensor
  pinMode(manualButtonPin, INPUT_PULLUP);  // Manual button with pullup resistor

  Serial.begin(9600);  // Start serial communication
}

void loop() {
  // Read the soil moisture sensor value (use analogRead for soil sensors)
  water = analogRead(sensorPin);
  Serial.print("Soil Moisture Sensor Value: ");
  Serial.println(water);  // Print sensor value

  // Check the status of the manual override button
  if (digitalRead(manualButtonPin) == LOW) {
    manualOverride = !manualOverride;  // Toggle the manual override
    delay(300);  // Debounce delay for the button
  }

  // If manual override is active, do not change the relay state based on soil moisture
  if (manualOverride) {
    Serial.println("Manual Override Active");
    digitalWrite(relayPin, relayState);  // Keep relay in the manually set state
  } 
  else {
    // Automatic mode: control relay based on soil moisture
    if (water > 500) {  // Adjust the threshold based on your sensor
      digitalWrite(relayPin, LOW);  // Turn off water supply (relay OFF)
      Serial.println("Relay OFF - Water supply stopped");
    } 
    else {
      digitalWrite(relayPin, HIGH);  // Turn on water supply (relay ON)
      Serial.println("Relay ON - Water supply active");
    }
  }

  delay(1000);  // Delay to avoid rapid switching
}
