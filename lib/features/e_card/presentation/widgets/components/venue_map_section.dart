import 'package:flutter/material.dart';

class VenueMapSection extends StatelessWidget {
  final String query;
  const VenueMapSection({super.key, required this.query});
  @override
  Widget build(BuildContext context) {
    final url = 'https://www.google.com/maps/search/?api=1&query='
        '${Uri.encodeComponent(query)}';
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(),
                body: Center(child: Text(url)),
              ),
            ),
          );
        },
        child: const Text('Xem bản đồ'),
      ),
    );
  }
}

