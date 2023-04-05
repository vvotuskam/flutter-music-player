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

// class So1ngWidget extends StatelessWidget {
//   // const SongWidget({Key? key}) : super(key: key);
//
//   const SongWidget({
//     super.key,
//     required this.song,
//     required this.isPlaying,
//     required this.isCurrentSong,
//   });
//
//   final Song song;
//   final bool isCurrentSong;
//   final bool isPlaying;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Column(
//           children: [
//             Image(
//               image: AssetImage(song.imageName),
//               width: 75,
//               height: 75,
//             ),
//           ],
//         ),
//         Column(
//           children: [
//             Row(
//               children: [
//                 Text(song.name)
//               ],
//             ),
//             Row(
//               children: [
//                 Text(song.artistName)
//               ],
//             ),
//           ],
//         )
//       ],
//     );
//   }
//}
class SongWidget extends StatefulWidget {
  const SongWidget({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.isCurrentSong,
    required this.service,
    required this.notifyParent,
  });

  final Song song;
  final bool isCurrentSong;
  final bool isPlaying;
  final AudioService service;
  final Function() notifyParent;

  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {

  void refresh() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            widget.isCurrentSong ?
                CircleAvatar(
                  radius: 38,
                  child: IconButton(
                    icon: widget.isPlaying ?
                    const Icon(Icons.pause, color: Colors.white,) :
                    const Icon(Icons.play_arrow, color: Colors.white),
                    onPressed: () {
                      if (widget.isPlaying) {
                        widget.service.pause();
                      } else {
                        widget.service.resume();
                      }
                      widget.notifyParent();
                      refresh();
                    },
                    iconSize: 50,
                  ),
                ) :
                Image(
                  image: AssetImage(widget.song.imageName),
                  width: 75,
                  height: 75,
                ),
          ],
        ),
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,                      crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(widget.song.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                )

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.song.artistName,
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                )
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
  bool _isPlaying = false;


  List<Song> songs = [
    Song("Той жыры", "Дос Мукасан", "Дос Мукасан", "assets/cover1.jpg", "song1.mp3"),
    Song("Without me", "Theatre", "Eminem", "assets/cover2.jpg", "song2.mp3"),
    Song("My Universe", "Universe", "Kairat Nurtas", "assets/cover3.jpg", "song3.mp3"),
  ];

  void playSong(int index) async {
    _currentIndex = index;
    
    final player = AudioCache(prefix: "assets/");
    final url = await player.load(songs[index].trackName);
    _audioPlayer.setUrl(url.path, isLocal: true);
    _audioPlayer.resume();
  }



  void resume() {
    _audioPlayer.resume();
    _isPlaying = true;
  }
  void stop() {
    _audioPlayer.stop();
  }
  void pause() {
    _audioPlayer.pause();
    _isPlaying = false;
  }

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
  }

  bool isPlaying() {
    _audioPlayer.onPlayerStateChanged.listen((event) {
      _isPlaying = event == PlayerState.PLAYING;
    });
    return _isPlaying;
  }

  AudioPlayer get audioPlayer => _audioPlayer;
}