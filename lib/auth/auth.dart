import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:videoapp/screens/Home/home.dart';
import 'package:videoapp/screens/Login/otp.dart';

class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<void> generateOtp(BuildContext context, String contactNumber) async {
    try {
      await auth.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (error) {
          print("error ${error.toString()}");
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => OTPScreen(
                    verificationId: verificationId,
                  )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        phoneNumber: contactNumber);
    } catch (e) {
      print("Error occured due to ${e.toString()}");
    }
    
  }

  Future<void> verifyOtp(
      BuildContext context, String verificationId, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      auth.signInWithCredential(credential).then((value) =>
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Home())));
    } catch (e) {
      print("Error occured due to ${e.toString}");
    }
  }

  String? getCurrentUser() {
    return  auth.currentUser?.phoneNumber;
  }
  
}
