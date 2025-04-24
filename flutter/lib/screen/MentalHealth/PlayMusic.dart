import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    'खुशी': 'happy hindi songs',
    'उदासी': 'sad hindi songs',
    'प्यार': 'romantic hindi songs',
    'क्रोध': 'angry hindi songs',
    'शांति': 'peaceful hindi songs',
    'ऊर्जा': 'energetic hindi songs',
  };

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _audioPlayer.playerStateStream.listen((state) {
      print(
          'Player state: ${state.playing}, Processing: ${state.processingState}');
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    }, onError: (e) {
      print('Player error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Audio player error: $e')),
      );
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _saveFavorite(String trackTitle) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favorites.contains(trackTitle)) {
      _favorites.remove(trackTitle);
    } else {
      _favorites.add(trackTitle);
    }
    await prefs.setStringList('favorites', _favorites);
    setState(() {});
  }

  Future<void> _searchSongs(String emotion) async {
    setState(() {
      _isLoading = true;
      _selectedMood = emotion;
    });

    try {
      final query = _hindiEmotions[emotion] ?? 'hindi songs';
      print('Searching for: $query'); // Debug log
      final response = await http
          .get(Uri.parse('https://api.lyrics.ovh/suggest/$query'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        print('API Response: $data'); // Debug log
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
          print('First track preview URL: ${_searchResults[0]['preview']}');
          await _playTrack(
              _searchResults[0]['preview'], _searchResults[0]['title']);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No songs found for this mood')),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load songs: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Search error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _playTrack(String url, String title) async {
    try {
      print('Attempting to play: $url'); // Debug log
      await _audioPlayer.stop(); // Stop any current playback
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
      print('Playback started for: $title');
      setState(() {
        _isPlaying = true;
        _currentTrack = title;
      });
    } catch (e) {
      print('Playback error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing track: $e')),
      );
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
      print('Paused playback');
    } else {
      _audioPlayer.play();
      print('Resumed playback');
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'खुशी':
        return Colors.orange;
      case 'उदासी':
        return Colors.blue;
      case 'प्यार':
        return Colors.pink;
      case 'क्रोध':
        return Colors.red;
      case 'शांति':
        return Colors.green;
      case 'ऊर्जा':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
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

            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a song or artist...',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _searchSongs(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
