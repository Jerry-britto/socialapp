import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:videoapp/auth/auth.dart';
import 'package:videoapp/screens/Home/showVideo.dart';
import 'package:videoapp/screens/Home/uploadVideo.dart';
import 'package:videoapp/screens/Login/phone_number.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIdx = 0;

  List<Widget> screens = const [
    SearchVideo(),
    UploadVideo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FloatingActionButton(
            onPressed: () => Auth().logout().then((val) =>
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const PhoneNumber()))),
            tooltip: "Log out",
            child: const Icon(Icons.logout),
          )
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: const [Icon(Icons.home), Icon(Icons.add), Icon(Icons.settings)],
        // backgroundColor: Colors.black,
        color: Colors.orange,
        buttonBackgroundColor: Colors.white,
        onTap: (value) => setState(() {
          currentIdx = value;
        }),
      ),
      body: screens[currentIdx],
    );
  }
}
