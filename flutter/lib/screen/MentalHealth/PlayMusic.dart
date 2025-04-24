import 'dart:convert';
import 'dart:math'; // Added for Random
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MoodSuggestion {
  final String mood;
  final String songType;
  final String purpose;
  final String emoji;

  MoodSuggestion({
    required this.mood,
    required this.songType,
    required this.purpose,
    required this.emoji,
  });
}

MoodSuggestion getMoodBasedSuggestion(String mood) {
  final Map<String, MoodSuggestion> suggestions = {
    'Angry': MoodSuggestion(
      mood: 'Angry',
      songType: 'Shiv Tandav, Hanuman Chalisa, and other devotional chants',
      purpose: 'To calm and spiritually uplift',
      emoji: '🙏',
    ),
    'Sad': MoodSuggestion(
      mood: 'Sad',
      songType: 'Shiv Tandav, Hanuman Chalisa, and other devotional chants',
      purpose: 'To calm and spiritually uplift',
      emoji: '🙏',
    ),
    'Romantic': MoodSuggestion(
      mood: 'Romantic',
      songType: 'Soft Romantic Hindi LoFi',
      purpose: 'To feel loved and relaxed',
      emoji: '💞',
    ),
    'Peaceful': MoodSuggestion(
      mood: 'Peaceful',
      songType: 'Flute + OM Chant Meditation',
      purpose: 'To meditate and calm the mind',
      emoji: '🧘',
    ),
    'Energetic': MoodSuggestion(
      mood: 'Energetic',
      songType: 'Motivational Hindi Beats',
      purpose: 'To boost energy and motivation',
      emoji: '⚡',
    ),
    'Happy': MoodSuggestion(
      mood: 'Happy',
      songType: 'Lofi Hindi Friendship Vibes',
      purpose: 'To enjoy and maintain mood',
      emoji: '😊',
    ),
  };

  return suggestions[mood] ??
      MoodSuggestion(
        mood: 'Neutral',
        songType: 'Balanced Hindi Instrumentals',
        purpose: 'To stay emotionally centered',
        emoji: '😐',
      );
}

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _favorites = [];
  bool _isPlaying = false;
  String _currentTrack = '';
  String _selectedMood = '';
  bool _isLoading = false;

  // Hindi emotions with emojis and corresponding search terms
  final Map<String, String> _hindiEmotions = {
    'Happy': 'happy hindi songs',
    'Sad': ' devotional hindi songs',
    'Romantic': 'romantic hindi songs',
    'Anger': ' devotional hindi songs',
    'Peace': 'peaceful hindi songs',
    'Energetic': 'energetic hindi songs',
  };

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _audioPlayer.playerStateStream.listen((state) {
      print(
          'Player state: ${state.playing}, Processing: ${state.processingState}');
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      }
    }, onError: (e) {
      print('Player error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Audio player error: $e')),
        );
      }
    });
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _favorites = prefs.getStringList('favorites') ?? [];
      });
    }
  }

  Future<void> _saveFavorite(String trackTitle) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favorites.contains(trackTitle)) {
      _favorites.remove(trackTitle);
    } else {
      _favorites.add(trackTitle);
    }
    await prefs.setStringList('favorites', _favorites);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _searchSongs(String emotion) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _selectedMood = emotion;
    });

    try {
      final query = _hindiEmotions[emotion] ?? 'hindi songs';
      print('Searching for: $query');
      final response = await http
          .get(Uri.parse('https://api.lyrics.ovh/suggest/$query'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        print('API Response: $data');
        if (!mounted) return;
        setState(() {
          _searchResults = data
              .map((song) {
                return {
                  'title': song['title'],
                  'artist': song['artist']['name'],
                  'preview': song['preview'],
                  'album': song['album']['cover_medium'],
                };
              })
              .where((song) =>
                  song['preview'] != null && song['preview'].isNotEmpty)
              .toList();
          _isLoading = false;
        });

        if (_searchResults.isNotEmpty) {
          final random = Random();
          final randomIndex = random.nextInt(_searchResults.length);
          print(
              'Random track preview URL: ${_searchResults[randomIndex]['preview']}');
          await _playTrack(_searchResults[randomIndex]['preview'],
              _searchResults[randomIndex]['title']);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No songs found for this mood')),
            );
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to load songs: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print('Search error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _playTrack(String url, String title) async {
    try {
      print('Attempting to play: $url');
      await _audioPlayer.stop();
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
      print('Playback started for: $title');
      if (mounted) {
        setState(() {
          _isPlaying = true;
          _currentTrack = title;
        });
      }
    } catch (e) {
      print('Playback error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing track: $e')),
        );
      }
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
      print('Paused playback');
      setState(() {
        _isPlaying = false;
      });
    } else {
      _audioPlayer.play();
      print('Resumed playback');
      setState(() {
        _isPlaying = true;
      });
    }
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Happy':
        return Colors.orange;
      case 'Sad':
        return Colors.blue;
      case 'Romantic':
        return Colors.pink;
      case 'Anger':
        return Colors.red;
      case 'Peace':
        return Colors.green;
      case 'Energetic':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MoodSuggestion suggestion = getMoodBasedSuggestion(_selectedMood);

    return Scaffold(
      appBar: AppBar(
        title: Text('Emotion-Based Hindi Music'),
        backgroundColor: _selectedMood.isNotEmpty
            ? _getMoodColor(_selectedMood)
            : Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _selectedMood.isNotEmpty
                  ? _getMoodColor(_selectedMood).withOpacity(0.7)
                  : Colors.deepPurple.withOpacity(0.7),
              Colors.black.withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          children: [
            // Mood selection buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _hindiEmotions.keys.map((mood) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getMoodColor(mood),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => _searchSongs(mood),
                        child:
                            Text(mood, style: TextStyle(color: Colors.white)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Mood suggestion display
            if (_selectedMood.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '🎵 Song Category: ${suggestion.songType}',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '🧠 Purpose: ${suggestion.purpose}',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Emoji: ${suggestion.emoji}',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),

            // Now playing section
            if (_currentTrack.isNotEmpty)
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      'Now Playing:',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _currentTrack,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 36,
                          ),
                          onPressed: _togglePlayPause,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Search results
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.white))
                  : _searchResults.isEmpty
                      ? Center(
                          child: Text(
                            'Select a mood or search',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final song = _searchResults[index];
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    song['album'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                            Icons.music_note,
                                            color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  song['title'],
                                  style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  song['artist'],
                                  style: TextStyle(color: Colors.white70),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        _favorites.contains(song['title'])
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            _favorites.contains(song['title'])
                                                ? Colors.red
                                                : Colors.white,
                                      ),
                                      onPressed: () =>
                                          _saveFavorite(song['title']),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.play_arrow,
                                          color: Colors.white),
                                      onPressed: () => _playTrack(
                                          song['preview'], song['title']),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
