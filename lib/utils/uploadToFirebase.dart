import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:videoapp/models/video.model.dart';

class Upload {
  ImagePicker picker = ImagePicker();

  Future<String> captureVideo() async {
    // this method will return the video url

    XFile? file = await picker.pickVideo(source: ImageSource.camera);

    if (file == null) {
      Future.error("Video not found");
    }

    return file!.path;
  }

  Future<String> getDownloadUrl(String url) async {
    // this method will upload the video to firebase storage

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference refRoot = FirebaseStorage.instance.ref();

    Reference refDirImages = refRoot.child("videos");

    Reference refVideoToBeUploaded = refDirImages.child("$uniqueFileName.mp4");

    try {
      await refVideoToBeUploaded.putFile(File(url));

      return await refVideoToBeUploaded.getDownloadURL();
    } catch (e) {
      print("could not upload video due to ${e.toString()}");
      throw "Video was not upload to firebase storage";
    }
  }

  Future<void> uploadPost(String user, String location, String videoTitle,
      String description, String category, String url) async {
    Video videObj = Video(
        user:user,
        url: url,
        videoTitle: videoTitle,
        description: description,
        category: category,
        location: location);

    FirebaseFirestore.instance
        .collection("posts")
        .add(videObj.toJson()).then((value) {
          print("uploaded post");
        },).catchError((error){
          print("Error due to $error");
        });
  }
}
