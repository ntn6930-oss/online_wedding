import 'package:flutter/material.dart';

class GuestNameBadge extends StatelessWidget {
  final String name;
  const GuestNameBadge({super.key, required this.name});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(name),
    );
  }
}

