import 'package:flutter/material.dart';
import 'package:music_player_midterm/songs_list.dart';
import 'package:music_player_midterm/util/song.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'OpenSans',
      ),
      home: SongsPage(service: AudioService(),),
    );
  }
}


