import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_guard/widget/nav.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;

class RealTimeData extends StatefulWidget {
  const RealTimeData({super.key});

  @override
  State<RealTimeData> createState() => _RealTimeDataState();
}

class _RealTimeDataState extends State<RealTimeData> {
  String temperature = '';
  String humidity = '';
  String moisture = '';
  String heatIndex = '';
  String motorStatus = 'Off'; // Track motor status

  Future<void> getInformation() async {
    try {
      final response = await http.get(
          Uri.parse('https://d675-120-89-104-102.ngrok.io/view_sensor_data'));

      if (response.statusCode == 200) {
        final finalResponse = jsonDecode(response.body);

        setState(() {
          temperature = finalResponse['temperature'];
          humidity = finalResponse['humid'];
          moisture = finalResponse['moisturevalue'];
          heatIndex = finalResponse['heatindex'];
        });
      } else {
        throw Exception('Failed to load sensor data');
      }
    } catch (err) {
      print("Error fetching data: $err");
    }
  }

  Future<void> controlMotor(String action) async {
    // Add your motor control API endpoint here
    final response = await http.post(
      Uri.parse('https://localhost:3000/motor_control'),
      body: jsonEncode({'action': action}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        motorStatus = motorStatus == 'On' ? 'Off' : 'On'; // Toggle motor status
      });
      print("Motor $action successfully");
    } else {
      print('Failed to control motor');
    }
  }

  @override
  void initState() {
    super.initState();
    getInformation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 171, 253, 173),
          title: Text(
            "Plant Details",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: "Philosopher",
              fontSize: 25,
            ),
          ),
        ),
        body: SingleChildScrollView(
          // Enable scrolling
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDataCard(
                    "Temperature: ${temperature}°C", 0.23, Colors.orange),
                SizedBox(height: 15),
                buildDataCard("Humidity: ${humidity}%", 0.44, Colors.green),
                SizedBox(height: 15),
                buildDataCard(
                    "Soil Moisture: ${moisture}%", 0.08, Colors.brown),
                SizedBox(height: 15),
                // buildDataCard("Heat Index: ${heatIndex}°C", 0.08, Colors.blue),
                SizedBox(height: 25),
                Center(
                  child: Text(
                    "Motor Status: $motorStatus", // Show motor status
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        controlMotor("toggle"), // Toggle motor state
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      backgroundColor: Colors.green, // Background color
                    ),
                    child: Text(
                      motorStatus == 'On'
                          ? "Turn Off"
                          : "Turn On", // Change button text based on status
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const NavBar(),
      ),
    );
  }

  Widget buildDataCard(String title, double percent, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 50,
              animation: true,
              lineHeight: 25.0,
              animationDuration: 2500,
              percent: percent,
              barRadius: Radius.circular(10),
              progressColor: color,
            ),
          ],
        ),
      ),
    );
  }
}
