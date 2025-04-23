import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MentalHealthDashboard extends StatefulWidget {
  @override
  _MentalHealthDashboardState createState() => _MentalHealthDashboardState();
}

class _MentalHealthDashboardState extends State<MentalHealthDashboard> {
  double _moodValue = 3.0; // Default neutral mood
  List<String> moodIcons = ['😢', '😠', '😐', '😊', '😴'];
  String selectedMood = '😐';
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

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = _getBackgroundColor(_moodValue);

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor.withOpacity(0.8),
              backgroundColor.withOpacity(0.4),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                'Your Mental Wellness',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(height: 8),
              Text(
                quoteOfTheDay,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 30),

              // Mood Slider
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'How are you feeling today?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20),
                      Slider(
                        value: _moodValue,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: moodIcons[_moodValue.round() - 1],
                        onChanged: (value) {
                          setState(() {
                            _moodValue = value;
                            selectedMood = moodIcons[_moodValue.round() - 1];
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: moodIcons.map((icon) {
                          return Text(
                            icon,
                            style: TextStyle(fontSize: 24),
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
                            ),
                          ),
                          progressColor: _getWellnessColor(wellnessScore),
                          backgroundColor: const Color.fromARGB(255, 94, 92, 5),
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          _getWellnessMessage(wellnessScore),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
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
                                belowBarData: BarAreaData(
                                  show: true,
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
                        children: [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun'
                        ].map((day) => Text(day)).toList(),
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
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildFeatureCard(
                    icon: Icons.video_call,
                    title: 'Therapist Connect',
                    color: Colors.blue,
                    onTap: () {
                      // Navigate to therapist connect
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.chat,
                    title: 'Suusri Chat AI',
                    color: Colors.green,
                    onTap: () {
                      // Navigate to chat
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.self_improvement,
                    title: 'Meditation Room',
                    color: Colors.orange,
                    onTap: () {
                      // Navigate to meditation
                    },
                  ),
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

              // Weekly Suggestions
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
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
      title: Text(text),
      minLeadingWidth: 0,
    );
  }

  Color _getBackgroundColor(double moodValue) {
    if (moodValue < 2) return Colors.blue; // Sad
    if (moodValue < 3) return Colors.red; // Angry
    if (moodValue < 4) return const Color.fromARGB(255, 20, 118, 7); // Neutral
    if (moodValue < 5) return Colors.green; // Happy
    return Colors.indigo; // Sleepy
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

class HealthMonitorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Monitor'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '😊 Emotion Detected: Neutral',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '📱 Screen Time: 4hr 35min',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '📊 Top Apps: YouTube, Instagram, WhatsApp',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '🌈 Suggestion: Try going offline for 1 hour with meditation or outdoor walk',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Weekly Trends',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emotion Trends',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [
                              BarChartRodData(toY: 3, color: Colors.blue)
                            ]),
                            BarChartGroupData(x: 1, barRods: [
                              BarChartRodData(toY: 5, color: Colors.green)
                            ]),
                            BarChartGroupData(x: 2, barRods: [
                              BarChartRodData(toY: 2, color: Colors.red)
                            ]),
                            BarChartGroupData(x: 3, barRods: [
                              BarChartRodData(toY: 4, color: Colors.green)
                            ]),
                            BarChartGroupData(x: 4, barRods: [
                              BarChartRodData(toY: 3, color: Colors.blue)
                            ]),
                            BarChartGroupData(x: 5, barRods: [
                              BarChartRodData(toY: 6, color: Colors.green)
                            ]),
                            BarChartGroupData(x: 6, barRods: [
                              BarChartRodData(toY: 5, color: Colors.green)
                            ]),
                          ],
                        ),
                      ),
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
}

class SuusriChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suusri Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildChatBubble(
                  'Hi there! How are you feeling today?',
                  false,
                ),
                _buildChatBubble(
                  'I\'m feeling a bit overwhelmed',
                  true,
                ),
                _buildChatBubble(
                  'I understand. Would you like to talk about it or try a relaxing activity?',
                  false,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMe ? 12 : 0),
            topRight: Radius.circular(isMe ? 0 : 12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}

class MusicPlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Music'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Recommended Based On Your Mood',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildMusicTile('Calm Piano', 'Relaxing instrumental piano'),
                _buildMusicTile('Nature Sounds', 'Rain and thunderstorm'),
                _buildMusicTile('Binaural Beats', 'Focus and concentration'),
                _buildMusicTile('Lofi Vibes', 'Chill study beats'),
                _buildMusicTile('Deep Sleep', 'Guided sleep meditation'),
              ],
            ),
          ),
          Container(
            height: 80,
            color: Colors.grey[200],
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () {},
                  iconSize: 36,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: () {},
                ),
                Expanded(
                  child: Slider(
                    value: 0.3,
                    onChanged: (value) {},
                  ),
                ),
                Text('1:45 / 4:30'),
                SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicTile(String title, String subtitle) {
    return ListTile(
      leading: Icon(Icons.music_note),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: Icon(Icons.favorite_border),
        onPressed: () {},
      ),
    );
  }
}
