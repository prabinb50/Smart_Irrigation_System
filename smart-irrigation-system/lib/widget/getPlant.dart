import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_guard/model/plantmodel.dart';
import 'package:green_guard/pages/plantDetail.dart';
import 'package:http/http.dart' as http;

class GetPlant extends StatefulWidget {
  const GetPlant({super.key});

  @override
  State<GetPlant> createState() => _GetPlantState();
}

class _GetPlantState extends State<GetPlant> {
  PlantModel? plantModel;
  bool isLoading = true; // State variable to track loading status

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://trefle.io/api/v1/plants?token=3FaSs5vPbXeYPRNhOrw7tvYD6qliy7ck-hHNtdCw_RQ'));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          plantModel = PlantModel.fromJson(jsonResponse);
          isLoading = false; // Update loading status
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        setState(() {
          isLoading = false; // Update loading status even on failure
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false; // Update loading status on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading // Check loading status
          ? CircularProgressIndicator() // Show loading indicator
          : plantModel != null && plantModel!.data!.isNotEmpty
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        0.6, // Adjust aspect ratio for better layout
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: plantModel!.data!.length,
                  itemBuilder: (context, index) {
                    final plant = plantModel!.data![index];
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlantDetail(
                                plantDetail: plant,
                              ),
                            ),
                          ),
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.network(
                                plant.imageUrl ?? '',
                                fit: BoxFit.cover,
                                width: 150,
                              ),
                            ),
                            SizedBox(height: 8), // Space between image and name
                            Text(
                              plant.commonName ??
                                  'Unknown Plant', // Display plant name
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Text('No plants available'), // Handle empty data case
    );
  }
}
