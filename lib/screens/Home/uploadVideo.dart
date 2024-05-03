// ignore: file_names
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class UploadVideo extends StatefulWidget {
  const UploadVideo({super.key});

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  String? locationName;

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Kindly turn on your location");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location Permission is denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied");
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getLocationName(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        setState(() {
          locationName =
              "${placemarks[0].subLocality},${placemarks[0].locality}";
        });
      } else {
        setState(() {
          locationName = 'Unknown';
        });
      }
    } catch (e) {
      print("Error $e");
      setState(() {
        locationName = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          try {
            final position = await getCurrentLocation();
            await getLocationName(position!.latitude, position.longitude);
          } catch (e) {
            print(e.toString());
          }
        },
        child: const Text("Get Location"),
      ),
    );
  }
}
