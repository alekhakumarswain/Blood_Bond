import 'package:flutter/material.dart';

class VitalsPage extends StatelessWidget {
  final vitals = {
    'Blood Pressure': '120/80',
    'Heart Rate': '72 bpm',
    'Weight': '80 kg',
    'Height': '123 cm',
    'BMI': '52.9 (Overweight)',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vitals', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[400],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: vitals.length,
        itemBuilder: (context, index) {
          final key = vitals.keys.elementAt(index);
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(_getIcon(key), color: Colors.red[400]),
              title: Text(key, style: TextStyle(color: Colors.grey[600])),
              subtitle: Text(vitals[key]!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon(String key) {
    switch (key) {
      case 'Blood Pressure':
        return Icons.favorite;
      case 'Heart Rate':
        return Icons.favorite_border;
      case 'Weight':
        return Icons.monitor_weight;
      case 'Height':
        return Icons.height;
      case 'BMI':
        return Icons.calculate;
      default:
        return Icons.help;
    }
  }
}
