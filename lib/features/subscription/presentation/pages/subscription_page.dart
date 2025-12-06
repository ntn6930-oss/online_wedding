import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});
  @override
  Widget build(BuildContext context) {
    final tiers = [
      _Tier(name: 'Free', features: ['Ảnh hạn chế', 'Lưu trữ cơ bản']),
      _Tier(name: 'Basic', features: ['Ảnh nhiều hơn', 'Tùy biến màu/font']),
      _Tier(name: 'Premium', features: ['Nhúng video/nhạc', 'Báo cáo chi tiết', 'Analytics']),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Gói dịch vụ')),
      body: ListView.builder(
        itemCount: tiers.length,
        itemBuilder: (_, i) {
          final t = tiers[i];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.name, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  ...t.features.map((f) => Text('• $f')),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: () {}, child: const Text('Chọn gói')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Tier {
  final String name;
  final List<String> features;
  _Tier({required this.name, required this.features});
}
