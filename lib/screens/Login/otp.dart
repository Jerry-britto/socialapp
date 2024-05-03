import 'package:flutter/material.dart';
import 'package:videoapp/auth/auth.dart';
import 'package:videoapp/screens/Login/phone_number.dart';

// ignore: must_be_immutable
class OTPScreen extends StatefulWidget {
  String verificationId;
  OTPScreen({super.key, required this.verificationId});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
                width: 100,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://imgs.search.brave.com/QxblUjK9CXmeXcsxbsPy-KMk4PvJ7w1yIbUtrm3o1sU/rs:fit:500:0:0/g:ce/aHR0cHM6Ly91cGxv/YWRzLnR1cmJvbG9n/by5jb20vdXBsb2Fk/cy9kZXNpZ24vcHJl/dmlld19pbWFnZS83/NDU5NS9wcmV2aWV3/X2ltYWdlMjAyMTA4/MjAtMjM1ODEtYmRq/Y3BpLnBuZw",
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: otpInput,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: "Enter OTP"),
              ),
              const SizedBox(
                height: 10,
              ),
              FloatingActionButton.extended(
                  onPressed: () async {
                    await Auth().verifyOtp(
                        context, widget.verificationId, otpInput.text.toString());
                  },
                  label: const Text("Get Started"))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const PhoneNumber()));
        },
        child: const Text("Back"),
      ),
    );
  }
}
