import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:green_guard/widget/nav.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

class PlantHealth extends StatefulWidget {
  File? plantImage;
  PlantHealth({super.key, required this.plantImage});

  @override
  State<PlantHealth> createState() => _PlantHealthState();
}

class _PlantHealthState extends State<PlantHealth> {
  String? plantDisease='';
  String? plantName;
  String temperature = '';
  String humidity = '';
  String moisture = '';
  String heatIndex = '';

  Map<String, List<String>> preventiveMeasures = {
    'Apple___healthy': [
      "Maintain good orchard hygiene.",
      "Prune and remove dead or diseased branches.",
      "Monitor for early signs of diseases."
    ],
    'Apple___Apple_scab': [
      "Prune and remove infected leaves and branches.",
      "Apply fungicides in early spring before buds open.",
      "Ensure good air circulation by proper spacing of apple trees.",
      "Keep the area around the apple tree clean from fallen leaves and debris."
    ],
    'Apple___Black_rot': [
      "Prune and destroy infected branches.",
      "Apply fungicides during the growing season.",
      "Remove mummified fruit from the tree and the ground.",
      "Promote good air circulation by proper pruning."
    ],
    'Apple___Cedar_apple_rust': [
      "Prune and remove galls on cedar trees.",
      "Apply fungicides during wet periods in the spring.",
      "Remove any nearby cedar trees if possible.",
      "Maintain good sanitation around apple trees."
    ],
    'Potato___Early_blight': [
      "Remove infected leaves and destroy them.",
      "Apply fungicides early in the season.",
      "Avoid overhead watering, as it can spread the disease.",
      "Crop rotation can help reduce the risk of recurrence."
    ],
    'Potato___Late_blight': [
      "Apply fungicides preventively during wet conditions.",
      "Remove and destroy infected plants immediately.",
      "Avoid overhead watering.",
      "Properly space potato plants for good air circulation."
    ],
    'Potato___healthy': [
      "Maintain good cultural practices, including proper watering and fertilization.",
      "Implement crop rotation to reduce disease risk.",
      "Inspect plants regularly for early signs of disease and take action promptly."
    ],
    'Tomato___Bacterial_spot': [
      "Remove and destroy infected plants.",
      "Apply copper-based or streptomycin-based sprays.",
      "Avoid overhead watering.",
      "Rotate crops to prevent the build-up of the bacteria in the soil."
    ],
    'Tomato___Early_blight': [
      "Remove infected leaves and destroy them.",
      "Apply fungicides early in the season.",
      "Mulch around tomato plants to prevent soil splash.",
      "Properly space and stake tomato plants for air circulation."
    ],
  };

  Future<void> getInformation() async {
    var response = await http.get(
        Uri.parse('https://d675-120-89-104-102.ngrok.io/view_sensor_data'));
    print(response.body);
    final finalResponse = jsonDecode(response.body);
    print(finalResponse);
    setState(() {
      temperature = finalResponse['temperature'];
      humidity = finalResponse['humid'];
      moisture = finalResponse['moisturevalue'];
      heatIndex = finalResponse['heatindex'];
    });
    try {
      if (response.statusCode == 200) {
        print("sucess to upload image");
      } else {
        print(response.statusCode);
        print('Failed');
      }
    } catch (err) {
      print("error");
      print(err);
    }
  }

  final dio = Dio();
  Future<void> uploadImage() async {
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(widget.plantImage!.path,
          filename: widget.plantImage!.path)
    });
    try {
      var response = await dio.post(
        'https://d675-120-89-104-102.ngrok.io/upload/',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print("sucess to upload image");

        setState(() {
          plantDisease = response.data['class'];
          List<String> parts = plantDisease!.split("___");
          if (parts.length > 0) {
            plantName = parts[0];
          }
        });
      } else {
        print(response.statusCode);
        print('Failed');
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploadImage();
    getInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 248, 248),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, // Change this color to the desired color
        ),
        backgroundColor: Color.fromARGB(255, 251, 248, 248),
        title: Text(
          'My plant',
          style: TextStyle(color: Colors.black),
        ),
        toolbarHeight: 65,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(
              File(widget.plantImage!.path).absolute,
              width: double.infinity,
              height: 280,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
              child: Text(
                '${plantName}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Philosopher',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white,
                child: ListTile(
                  title: Text("Model prediction result:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${plantDisease} detected',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "More Details:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        tileColor: Color.fromARGB(255, 242, 251, 242),
                        leading: Image.asset('assets/images/temperature.png'),
                        title: Text("Temperature:"),
                        subtitle: Text("${temperature}"),
                      ),
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      leading: Image.asset('assets/images/humidity.png'),
                      title: Text("Humidity:"),
                      subtitle: Text("${humidity}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        tileColor: Color.fromARGB(255, 242, 251, 242),
                        leading: Image.asset('assets/images/soil moisture.png'),
                        title: Text("Soil Moisture:"),
                        subtitle: Text("${moisture}"),
                      ),
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      leading: Image.asset('assets/images/HeatIndex.png'),
                      title: Text("Heat Index:"),
                      subtitle: Text("${heatIndex}"),
                    ),
                   
                  ],
                ),
              ),
            ),
             Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Preventive Measures:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (preventiveMeasures
                                .containsKey(plantDisease ?? '')) ...[
                              for (final measure
                                  in preventiveMeasures[plantDisease ?? '']!)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Text("• $measure"),
                                  ),
                                ),
                            ] else ...[
                              ListTile(
                                title: Text(
                                  "Preventive measures not available for this disease.",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
