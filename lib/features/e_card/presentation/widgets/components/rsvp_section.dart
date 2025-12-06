import 'package:flutter/material.dart';

class RsvpSection extends StatelessWidget {
  final String brideLabel;
  final String groomLabel;
  const RsvpSection({
    super.key,
    this.brideLabel = 'Nhà gái',
    this.groomLabel = 'Nhà trai',
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Xác nhận tham dự', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('RSVP nhà gái')),
                    );
                  },
                  child: Text(brideLabel),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('RSVP nhà trai')),
                    );
                  },
                  child: Text(groomLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

