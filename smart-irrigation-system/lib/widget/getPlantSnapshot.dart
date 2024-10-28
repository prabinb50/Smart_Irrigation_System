import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_guard/model/plantmodel.dart';
import 'package:http/http.dart'as http;
import 'package:green_guard/model/plantmodel.dart';
import 'package:green_guard/pages/plantDetail.dart';

class PlantSnap extends StatefulWidget {
  const PlantSnap({super.key});

  @override
  State<PlantSnap> createState() => _PlantSnapState();
}

class _PlantSnapState extends State<PlantSnap> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  PlantModel? plantModel;
Future<void> fetchData() async {
  final response = await http.get(Uri.parse(
      'https://trefle.io/api/v1/plants?token=mO00Pcm7MWkGhFwKgLQTEvV366mlOCbf1OpYkrTR4po'));

  if (response.statusCode == 200) {
    final jsonResponse =jsonDecode(response.body);
    plantModel = PlantModel.fromJson(jsonResponse);
   setState(() {
     
   });
    

  } else {
    print('Failed to load data');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Center(
      child: plantModel != null
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: plantModel!.data!.length,
              itemBuilder: (context, index) {
                final plant = plantModel!.data![index];
                return Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      height: 250,
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              plant.imageUrl ?? '',
                              height: 80,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 10,),
                            Text(
                              '${plant.commonName}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              '${plant.scientificName}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                ),
                            )
                          ],
                        ),
                      ),
                    ));
              })
          : CircularProgressIndicator(), // Show a loading indicator while fetching data
    ),
  );
  }
}