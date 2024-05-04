// ignore: file_names
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:videoapp/auth/auth.dart';
import 'package:videoapp/utils/uploadToFirebase.dart';

class UploadVideo extends StatefulWidget {
  const UploadVideo({super.key});

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  String? locationName;
  bool isVisible = false;
  TextEditingController location = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController category = TextEditingController();
  String videoUrl = "";
  bool uploadStatus = false;

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
          isVisible = true;
        });
      } else {
        setState(() {
          locationName = 'Unknown';
          isVisible = true;
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
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListView(
        children: [
          Center(
            child: Visibility(
              visible: !isVisible,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final position = await getCurrentLocation();
                    await getLocationName(
                        position!.latitude, position.longitude);
                    setState(() {
                      location.text = locationName as String;
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                    print(e.toString());
                  }
                },
                child: const Text("Get Location"),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: isVisible,
            child: Column(
              children: [
                TextField(
                  controller: location,
                  readOnly: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      hintText: "Location"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                      hintText: "Enter Video Title"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: description,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                      hintText: "Enter Video description"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: category,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                      hintText: "Enter Video Category"),
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingActionButton.extended(
                    onPressed: () async {
                      setState(() {
                    uploadStatus = true;
                      });
                      await Upload().captureVideo().then((String url) async {
                        print("Video url $url");
                        await Upload().getDownloadUrl(url).then((val) {
                          print("Firebase storage string $val");
                          setState(() {
                            videoUrl = val;
                            uploadStatus=false;
                          });
                        });
                      }).catchError((error) {
                        setState(() {
                        uploadStatus=false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Kindly upload your video")));
                      });
                    },
                    label: !uploadStatus?const Text("Upload Video"):const CircularProgressIndicator()),
                const SizedBox(
                  height: 30,
                ),
                FloatingActionButton.extended(
                    onPressed: () async {
                      if (title.text == "" ||
                          description.text == "" ||
                          category.text == "" ||
                          videoUrl == "") {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Kindly fill in the details before submitting")));
                        return;
                      } else {
                        String? user = Auth().getCurrentUser();
                        print("user $user");
                        Upload()
                            .uploadPost(user!, location.text, title.text,
                                description.text, category.text, videoUrl)
                            .then((val) {
                          // print("uploaded post");
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Uploaded Post")));
                        })
                            // ignore: body_might_complete_normally_catch_error
                            .catchError((e) {
                          print("Error ${e.toString()}");
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Post was not uploaded")));
                        });
                      }
                    },
                    label: const Text("POST"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
