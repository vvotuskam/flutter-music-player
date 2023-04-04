import 'package:flutter/material.dart';
import 'package:music_player_midterm/util/song.dart';
import 'package:audioplayers/audioplayers.dart';

import 'music_player.dart';

class SongsPage extends StatefulWidget {
  // SongsPage({super.key, required this.index, required this.duration, required this.position, required this.audioPlayer});

  // int index;
  // Duration duration;
  // Duration position;
  // AudioPlayer audioPlayer;

  SongsPage({super.key, required this.service});
  final AudioService service;


  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  List<Song> songs = [
    Song("Song name 1", "Album name 1", "artistName 1", "assets/cover1.jpg", "song1.mp3"),
    Song("Song name 2", "Album name 2", "artistName 2", "assets/cover2.jpg", "song2.mp3"),
    Song("Song name 3", "Album name 3", "artistName 3", "assets/cover3.jpg", "song3.mp3"),
  ];

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Music list",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Music List"),
          automaticallyImplyLeading: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: SongWidget(song: songs[index],),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SongPlayer(songs: songs, index: index, service: widget.service,)
                          )
                      );
                    },
                  );
                },
              ),
            ),
            Visibility(
              visible: widget.service.currentIndex != -1,
              child: Text(songs[widget.service.currentIndex != -1 ? widget.service.currentIndex : 0].name),
            )
          ],
        )

      ),
    );
  }
}
