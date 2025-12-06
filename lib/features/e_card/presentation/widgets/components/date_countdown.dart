import 'package:flutter/material.dart';

class DateCountdown extends StatefulWidget {
  final DateTime date;
  const DateCountdown({super.key, required this.date});
  @override
  State<DateCountdown> createState() => _DateCountdownState();
}

class _DateCountdownState extends State<DateCountdown> {
  late Duration remaining;
  @override
  void initState() {
    super.initState();
    remaining = widget.date.difference(DateTime.now());
  }
  @override
  Widget build(BuildContext context) {
    final d = remaining.inDays;
    final h = remaining.inHours % 24;
    final m = remaining.inMinutes % 60;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text('$d ngày • $h giờ • $m phút'),
    );
  }
}

