import 'package:flutter/material.dart';
import 'package:music_player_midterm/util/song.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';


import 'music_player.dart';

class SongsPage extends StatefulWidget {
  // SongsPage({super.key, required this.index, required this.duration, required this.position, required this.audioPlayer});

  // int index;
  // Duration duration;
  // Duration position;
  // AudioPlayer audioPlayer;

  SongsPage({super.key, required this.service});
  AudioService service;


  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  List<Song> songs = [
    Song("Той жыры", "Дос Мукасан", "Дос Мукасан", "assets/cover1.jpg", "song1.mp3"),
    Song("Without me", "Theatre", "Eminem", "assets/cover2.jpg", "song2.mp3"),
    Song("My Universe", "Universe", "Kairat Nurtas", "assets/cover3.jpg", "song3.mp3"),
  ];

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Music list",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Music List"),
        ),
        body: Column(
          children: [
            const SizedBox(height: 15,),
            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: SongWidget(
                      song: songs[index],
                      isPlaying: widget.service.isPlaying(),
                      isCurrentSong: index == widget.service.currentIndex,
                      service: widget.service,
                      notifyParent: refresh,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SongPlayer(
                                songs: songs,
                                index: index,
                                service: widget.service,
                                notifyParent: refresh,
                              )
                          )
                      );
                    },
                  );
                },
              ),
            ),
          ],
        )

      ),
    );
  }
  refresh() {
    setState(() {
      print('----------------------------------------------------------------------------------------------------------');
      print(widget.service.isPlaying());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
