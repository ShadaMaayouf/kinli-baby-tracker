import 'package:flutter/material.dart';
import 'package:kinli/screens/pumping_log_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {'title': 'Feeding', 'icon': Icons.local_drink},
      {'title': 'Sleep', 'icon': Icons.bedtime},
      {'title': 'Diapers', 'icon': Icons.baby_changing_station},
      {'title': 'Growth', 'icon': Icons.monitor_weight},
      {'title': 'Pumping', 'icon': Icons.pregnant_woman},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kinli Dashboard'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: features.length,
        itemBuilder: (context, index) {
          final feature = features[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(feature['icon'] as IconData, size: 32),
              title: Text(feature['title'] as String),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to feature screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PumpingLogScreen()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
