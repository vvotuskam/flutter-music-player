import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class Song {
  final String name;
  final String albumName;
  final String artistName;
  final String imageName;
  final String trackName;

  Song(this.name, this.albumName, this.artistName, this.imageName, this.trackName);

  @override
  String toString() {
    return name;
  }
}

class SongWidget extends StatelessWidget {
  // const SongWidget({Key? key}) : super(key: key);

  const SongWidget({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Image(image: AssetImage(song.imageName), width: 75, height: 75,),
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                Text(song.name)
              ],
            ),
            Row(
              children: [
                Text(song.artistName)
              ],
            ),
          ],
        )
      ],
    );
  }
}

class AudioService {
  AudioService();

  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = -1;


  List<Song> songs = [
    Song("Song name 1", "Album name 1", "artistName 1", "assets/cover1.jpg", "song1.mp3"),
    Song("Song name 2", "Album name 2", "artistName 2", "assets/cover2.jpg", "song2.mp3"),
    Song("Song name 3", "Album name 3", "artistName 3", "assets/cover3.jpg", "song3.mp3"),
  ];

  void playSong(int index) async {
    final player = AudioCache(prefix: "assets/");
    final url = await player.load(songs[index].trackName);
    _audioPlayer.setUrl(url.path, isLocal: true);
    _audioPlayer.resume();

    _currentIndex = index;
  }
  void resume() {
    _audioPlayer.resume();
  }
  void stop() {
    _audioPlayer.stop();
  }
  void pause() {
    _audioPlayer.pause();
  }

  int get currentIndex => _currentIndex;

  AudioPlayer get audioPlayer => _audioPlayer;
}
