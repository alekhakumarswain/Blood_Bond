import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:blood_bond/screen/Health/medication_reminder_page.dart';
import 'package:blood_bond/screen/Health/vitals_page.dart';

class HealthRecord extends StatefulWidget {
  @override
  _HealthMonitorState createState() => _HealthMonitorState();
}

class _HealthMonitorState extends State<HealthRecord> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  final Color primaryColor = Color(0xFF6A1B9A);
  final Color secondaryColor = Color(0xFF9C27B0);

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/Data/profile.json');
      setState(() {
        profileData = json.decode(jsonString);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Hello, ${profileData?['personalInformation']?['name'] ?? 'User'}!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[800]!, Colors.lightBlue[400]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  pinned: true,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MedicationHealthMonitor()),
                        );
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _AnimatedStatCard(
                              title: 'Heart Rate',
                              value: profileData?['healthMetrics']?['heartRate']
                                      ?.toString() ??
                                  '72',
                              unit: 'bpm',
                              icon: Icons.favorite,
                              color: Colors.red[400]!,
                            ),
                            _AnimatedStatCard(
                              title: 'Blood Pressure',
                              value: profileData?['healthMetrics']
                                      ?['bloodPressure'] ??
                                  '120/80',
                              icon: Icons.monitor_heart,
                              color: Colors.purple[400]!,
                            ),
                            _AnimatedStatCard(
                              title: 'Weight',
                              value: profileData?['healthMetrics']?['weight']
                                      ?.toString() ??
                                  '80',
                              unit: 'kg',
                              icon: Icons.line_weight,
                              color: Colors.teal[400]!,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildDailyIntakeSummary(),
                        SizedBox(height: 16),
                        _buildHealthTrendsGraph(),
                        SizedBox(height: 16),
                        _buildMedicationToday(),
                        SizedBox(height: 16),
                        _buildQuickActions(context),
                        SizedBox(height: 16),
                        _buildWeeklyHistory(),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildDashboardCard(context, index),
                      childCount: 8,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _AnimatedStatCard({
    required String title,
    required String value,
    String? unit,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (unit != null) Text(unit, style: TextStyle(fontSize: 12)),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyIntakeSummary() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Intake',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Icon(Icons.restaurant, color: Colors.orange[400]),
                    SizedBox(height: 4),
                    Text(
                      '1800',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('kcal', style: TextStyle(fontSize: 12)),
                    Text('Food', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.local_drink, color: Colors.blue[400]),
                    SizedBox(height: 4),
                    Text(
                      '1500',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('ml', style: TextStyle(fontSize: 12)),
                    Text('Water', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _showLogIntakeDialog(context);
              },
              child: Text('Log Intake'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Fixed: Changed from 'primary'
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTrendsGraph() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Heart Rate Trends (Last 7 Days)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 150,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: 60,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 72),
                        FlSpot(1, 75),
                        FlSpot(2, 80),
                        FlSpot(3, 78),
                        FlSpot(4, 76),
                        FlSpot(5, 74),
                        FlSpot(6, 72),
                      ],
                      isCurved: true,
                      color: Colors.red[400],
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationToday() {
    final medicationReminders =
        profileData?['healthReminders']?['medicationReminders'] ?? [];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Medications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (medicationReminders.isEmpty)
              Text('No medications scheduled for today.',
                  style: TextStyle(color: Colors.grey[600])),
            ...medicationReminders.map<Widget>((reminder) {
              return ListTile(
                leading: Icon(Icons.medication, color: Colors.green[400]),
                title: Text(reminder['medicationName'] ?? 'Medication'),
                subtitle: Text(
                    '${reminder['dosage']} at ${(reminder['times'] as List).join(', ')}'),
                trailing: IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      // Placeholder for updating state
                    });
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyHistory() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly History',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.restaurant, color: Colors.orange[400]),
              title: Text('Food Intake'),
              subtitle: Text('Avg 1700 kcal/day'),
            ),
            ListTile(
              leading: Icon(Icons.local_drink, color: Colors.blue[400]),
              title: Text('Water Intake'),
              subtitle: Text('Avg 1400 ml/day'),
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.red[400]),
              title: Text('Heart Rate'),
              subtitle: Text('Avg 73 bpm'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _QuickActionButton(
          icon: Icons.restaurant,
          label: 'Log Food',
          color: Colors.orange[400]!,
          onTap: () {
            _showLogIntakeDialog(context, type: 'Food');
          },
        ),
        _QuickActionButton(
          icon: Icons.local_drink,
          label: 'Log Water',
          color: Colors.blue[400]!,
          onTap: () {
            _showLogIntakeDialog(context, type: 'Water');
          },
        ),
        _QuickActionButton(
          icon: Icons.medication,
          label: 'Refill',
          color: Colors.green[400]!,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildDashboardCard(BuildContext context, int index) {
    final List<Map<String, dynamic>> cards = [
      {
        'title': 'Medications',
        'icon': Icons.medication,
        'color': Colors.green[400],
        'action': () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MedicationHealthMonitor()),
            ),
      },
      {
        'title': 'Appointments',
        'icon': Icons.calendar_today,
        'color': Colors.orange[400],
        'subtitle': 'Next: Apr 25',
      },
      {
        'title': 'Blood Tests',
        'icon': Icons.science,
        'color': Colors.purple[400],
        'subtitle': 'CBC on Apr 15',
      },
      {
        'title': 'Health Goals',
        'icon': Icons.flag,
        'color': Colors.teal[400],
        'subtitle': '75kg by Dec 2025',
      },
      {
        'title': 'Vitals',
        'icon': Icons.monitor_heart,
        'color': Colors.red[400],
        'action': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VitalsPage()),
            ),
      },
      {
        'title': 'Insurance',
        'icon': Icons.health_and_safety,
        'color': Colors.blue[400],
        'subtitle': 'Star Health',
      },
      {
        'title': 'Food Log',
        'icon': Icons.restaurant,
        'color': Colors.orange[400],
        'action': () => _showLogIntakeDialog(context, type: 'Food'),
      },
      {
        'title': 'Water Log',
        'icon': Icons.local_drink,
        'color': Colors.blue[400],
        'action': () => _showLogIntakeDialog(context, type: 'Water'),
      },
    ];

    final card = cards[index];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: card['action'] as void Function()?,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(card['icon'], size: 32, color: card['color']),
              SizedBox(height: 8),
              Text(
                card['title'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (card['subtitle'] != null)
                Text(
                  card['subtitle'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogIntakeDialog(BuildContext context, {String type = 'Food'}) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log $type Intake'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: type == 'Food' ? 'Calories (kcal)' : 'Amount (ml)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$type logged successfully!')),
              );
              Navigator.pop(context);
            },
            child: Text('Save'),
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor), // Fixed: Changed from 'primary'
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              color.withValues(alpha: 0.1), // Fixed: Changed from 'withOpacity'
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: color.withValues(
                  alpha: 0.3)), // Fixed: Changed from 'withOpacity'
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            SizedBox(height: 4),
            Text(label, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}
