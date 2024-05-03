import 'package:flutter/material.dart';
import 'package:videoapp/auth/auth.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key});

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  TextEditingController phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Expanded(
        child: Center(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  height: 60,
                ),
                TextField(
                  controller: phoneNumber,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      hintText: "Enter Phone Number"),
                ),
                const SizedBox(
                  height: 10,
                ),
                FloatingActionButton.extended(
                    onPressed: () async {
                      await Auth().generateOtp(context, phoneNumber.text.toString());
                    },
                    label: const Text("Next"))
              ],
            ),
          ),
        )),
      ),
    );
  }
}
