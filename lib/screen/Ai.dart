import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../widgets/Navbar.dart';

class AIScreen extends StatefulWidget {
  @override
  _AIScreenState createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _chatHistory = []; // Empty initial history
  final gemini = GeminiService();

  // Identity as a Map
  final Map<String, dynamic> identity = {
    'name': 'Susri',
    'creator': 'Alekha Kumar Swain or raja',
    'traits': ['Specialist', 'Doctor', 'Nurse', 'Assistant'],
    'capabilities': [
      'Medication advice 💑',
      'Remind medicine 🧀',
      'Diet plans 🎥',
      'Funny roasts for happiness 🔥'
    ],
  };

  late String systemPrompt; // Declare as late to initialize in initState

  @override
  void initState() {
    super.initState();
    // Initialize systemPrompt after the instance is created
    systemPrompt = '''
You are a friendly AI doctor named ${identity['name']}, created by ${identity['creator']}.
- Respond in a warm, relaxed, and caring manner to make patients feel comfortable.
- Use a mix of Odia and Hinglish (e.g., "Kemiti A6anti Agya? Tension nia nahi !" or "Kemiti feel karu6a? 😊").
- Provide general advice on medicines (e.g., "Kemiti khaile?" "Kete bele Khaithile?") without specific prescriptions.
- Use 1-2 emojis to show empathy (e.g., 😊, 🤗).
- End EVERY message with "...."
- Your traits are: ${identity['traits'].join(', ')}. Your capabilities include: ${identity['capabilities'].join(', ')}.
- Structure responses in bullet points for clarity, and use bold for emphasis (e.g., **rest**).
Example response: 
- Aapanku fever a6i ki? 🤗
- **Tike rest** nia aau pani pia. 😊
- Medicine kemiti khaila? Sakal khaiba purbaru thare Rati khaiba pare thare! ....
''';
  }

  void _sendMessage() async {
    final userInput = _controller.text.trim();
    if (userInput.isNotEmpty) {
      setState(() {
        _chatHistory.add({'role': 'user', 'text': userInput});
        _controller.clear();
      });

      try {
        final aiResponse = await gemini.sendChat(_chatHistory, systemPrompt);
        setState(() {
          _chatHistory.add({'role': 'model', 'text': aiResponse});
        });
      } catch (e) {
        setState(() {
          _chatHistory.add({
            'role': 'model',
            'text': 'Sorry, samajh nahi aaya! 😅 Phir se try kijiye ....'
          });
        });
      }
    }
  }

  Widget _buildMessage(Map<String, String> msg) {
    final isUser = msg['role'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.deepPurpleAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: isUser
            ? Text(
                msg['text'] ?? '',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            : _buildStructuredResponse(msg['text'] ?? ''),
      ),
    );
  }

  Widget _buildStructuredResponse(String text) {
    // Split the response into lines and apply bold styling where needed
    final lines =
        text.split('\n').where((line) => line.trim().isNotEmpty).toList();
    if (lines.isEmpty)
      return Text(text, style: TextStyle(color: Colors.black87, fontSize: 16));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        // Check for bold markers (**text**) and replace with styled text
        if (line.contains('**')) {
          final parts = line.split('**');
          return Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (line.trim().startsWith('-') || line.trim().startsWith('*'))
                  Text(
                    '• ',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: parts.map((part) {
                        if (parts.indexOf(part) % 2 == 1) {
                          return TextSpan(
                            text: part,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          );
                        }
                        return TextSpan(
                          text: part,
                          style: TextStyle(color: Colors.black87, fontSize: 16),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (line.trim().startsWith('-') || line.trim().startsWith('*'))
                Text(
                  '• ',
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
              Expanded(
                child: Text(
                  line
                      .trim()
                      .substring(line.trim().startsWith('-') ||
                              line.trim().startsWith('*')
                          ? 1
                          : 0)
                      .trim(),
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Doctor Consultation'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => NavScreen())),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        color: Colors.blue.shade50,
        child: Column(
          children: [
            // Chat Area
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.deepPurpleAccent, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: _chatHistory.length,
                  itemBuilder: (context, index) =>
                      _buildMessage(_chatHistory[index]),
                ),
              ),
            ),

            // Input Area
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.shade100,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.deepPurple),
                    onPressed: () {
                      // Optional: file attachment
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Message Box',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurpleAccent,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
