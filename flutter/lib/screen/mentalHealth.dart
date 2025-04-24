import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MentalHealthDashboard extends StatefulWidget {
  @override
  _MentalHealthDashboardState createState() => _MentalHealthDashboardState();
}

class _MentalHealthDashboardState extends State<MentalHealthDashboard> {
  String selectedMood = '😐';
  List<String> moodIcons = ['😢', '😠', '😐', '😊', '😴'];
  String quoteOfTheDay = "You are stronger than you think";
  double wellnessScore = 72.0;
  List<FlSpot> moodData = [
    FlSpot(0, 3),
    FlSpot(1, 4),
    FlSpot(2, 2),
    FlSpot(3, 5),
    FlSpot(4, 3),
    FlSpot(5, 4),
    FlSpot(6, 5)
  ];
  int _streakDays = 5; // New feature: tracking streak
  bool _isDarkMode = false; // New feature: dark mode toggle

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = _getBackgroundColor(selectedMood);

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor.withOpacity(_isDarkMode ? 0.6 : 0.8),
              backgroundColor.withOpacity(_isDarkMode ? 0.2 : 0.4),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Mental Wellness',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isDarkMode = !_isDarkMode;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                quoteOfTheDay,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: _isDarkMode ? Colors.white70 : Colors.white70,
                ),
              ),
              SizedBox(height: 30),

              // Mood Selection
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: _isDarkMode ? Colors.grey[800] : Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'How are you feeling today?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        children: moodIcons.map((icon) {
                          bool isSelected = icon == selectedMood;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedMood = icon;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              padding: EdgeInsets.all(isSelected ? 12 : 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _getBackgroundColor(icon).withOpacity(0.3)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                icon,
                                style: TextStyle(
                                  fontSize: isSelected ? 36 : 24,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Wellness Score
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: _isDarkMode ? Colors.grey[800] : Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Wellness Score',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: CircularPercentIndicator(
                          radius: 80.0,
                          lineWidth: 15.0,
                          percent: wellnessScore / 100,
                          center: Text(
                            "${wellnessScore.toInt()}%",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          progressColor: _getWellnessColor(wellnessScore),
                          backgroundColor: _isDarkMode
                              ? const Color.fromARGB(255, 234, 125, 125)!
                              : const Color.fromARGB(255, 203, 59, 59)!,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          _getWellnessMessage(wellnessScore),
                          style: TextStyle(
                            fontSize: 16,
                            color: _isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Mood History Chart
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: _isDarkMode ? Colors.grey[800] : Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Mood This Week',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            minX: 0,
                            maxX: 6,
                            minY: 0,
                            maxY: 5,
                            lineBarsData: [
                              LineChartBarData(
                                spots: moodData,
                                isCurved: true,
                                barWidth: 4,
                                color: _getBackgroundColor(selectedMood),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: _getBackgroundColor(selectedMood)
                                      .withOpacity(0.3),
                                ),
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                                .map((day) => Text(
                                      day,
                                      style: TextStyle(
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ))
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Streak Counter (New Feature)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: _isDarkMode ? Colors.grey[800] : Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Check-in Streak',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: _isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Keep it up!',
                            style: TextStyle(
                              color: _isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '🔥 $_streakDays days',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Quick Access Cards
              Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          icon: Icons.chat,
                          title: 'Suusri Chat AI',
                          color: Colors.green,
                          onTap: () {
                            // Navigate to chat
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildFeatureCard(
                          icon: Icons.self_improvement,
                          title: 'Meditation Room',
                          color: Colors.orange,
                          onTap: () {
                            // Navigate to meditation
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildFeatureCard(
                    icon: Icons.music_note,
                    title: 'Mood Music',
                    color: Colors.pink,
                    onTap: () {
                      // Navigate to music
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Journal Feature (New Feature)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: _isDarkMode ? Colors.grey[800] : Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Journal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Write about your day...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor:
                              _isDarkMode ? Colors.grey[700] : Colors.grey[100],
                        ),
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Save Entry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getBackgroundColor(selectedMood),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Weekly Suggestions
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: _isDarkMode ? Colors.grey[800] : Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Suggestions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildSuggestionTile(
                        'Try 10 minutes of meditation today',
                        Icons.self_improvement,
                        Colors.purple,
                      ),
                      _buildSuggestionTile(
                        'Your screen time was high yesterday - consider a digital detox',
                        Icons.phone_android,
                        Colors.blue,
                      ),
                      _buildSuggestionTile(
                        'Connect with friends - social interaction boosts mood',
                        Icons.people,
                        Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionTile(String text, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(
          color: _isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      minLeadingWidth: 0,
    );
  }

  Color _getBackgroundColor(String mood) {
    switch (mood) {
      case '😢':
        return Colors.blue;
      case '😠':
        return Colors.red;
      case '😐':
        return Colors.grey;
      case '😊':
        return Colors.green;
      case '😴':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Color _getWellnessColor(double score) {
    if (score < 40) return Colors.red;
    if (score < 70) return Colors.orange;
    return Colors.green;
  }

  String _getWellnessMessage(double score) {
    if (score < 40) return "Let's work on improving this together";
    if (score < 70) return "Good progress! Keep it up";
    return "Excellent! You're doing great";
  }
}
