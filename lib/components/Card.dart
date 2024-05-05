import 'package:flutter/material.dart';
import 'package:videoapp/components/video.dart';

class CardInfo extends StatefulWidget {
  final String title, description, location, category, url;
  const CardInfo(
      {super.key,
      required this.title,
      required this.description,
      required this.location,
      required this.category,
      required this.url});

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              "title: ${widget.title}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "description ${widget.description}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            Text(
              "location ${widget.location}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
             Text(
              "category ${widget.category}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
             VideoApp(url: widget.url)
          ],
        ),
      ),
    );
  }
}
