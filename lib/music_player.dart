import 'package:flutter/material.dart';
import 'package:music_player_midterm/songs_list.dart';
import 'package:music_player_midterm/util/song.dart';
import 'package:audioplayers/audioplayers.dart';

class SongPlayer extends StatefulWidget {
  SongPlayer({super.key, required this.songs, required this.index, required this.service, required this.notifyParent});
  final List<Song> songs;
  int index;
  final AudioService service;
  final Function() notifyParent;


  @override
  State<SongPlayer> createState() => _SongPlayerState();
}

class _SongPlayerState extends State<SongPlayer> {

  bool isPlaying = false;
  //final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final mins = twoDigits(duration.inMinutes.remainder(60));
    final secs = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      mins,
      secs
    ].join(':');
  }

  Future setAudio() async {
    // final player = AudioCache(prefix: "assets/");
    // final url = await player.load(widget.songs[widget.index].trackName);
    // audioPlayer.setUrl(url.path, isLocal: true);
    // audioPlayer.resume();
    widget.service.playSong(widget.index);
  }

  @override
  void initState() {
    super.initState();

    setAudio();

    if (!mounted) {
      return;
    }
    widget.service.audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.PLAYING;
      });
    });

    widget.service.audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    widget.service.audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });

    widget.service.audioPlayer.onPlayerCompletion.listen((event) {
      if (widget.index == widget.songs.length - 1) {
        setState(() {
          widget.index = 0;
        });
      } else {
        setState(() {
          widget.index += 1;
        });
      }
      setAudio();
    });
  }

  @override
  Widget build(BuildContext context) {

    Song song = widget.songs[widget.index];

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(song.name),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    widget.notifyParent();
                    Navigator.pop(context, true);
                  },
                  child: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      weight: 50.0,


                  ),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(image: AssetImage(song.imageName),
              width: 350, height: 350, fit: BoxFit.cover,)
            ),
            const SizedBox(height: 32,),
            Text(
              "${song.artistName} - ${song.name}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4,),
            Text(
              song.albumName,
              style: const TextStyle(fontSize: 20),
            ),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                widget.service.audioPlayer.seek(position);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration)),
                ],
              )
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(
                      Icons.keyboard_double_arrow_left_outlined,
                    ),
                    iconSize: 50,
                    onPressed: () async {
                      if (widget.index == 0) {
                        setState(() {
                          widget.index = widget.songs.length - 1;
                        });
                      } else {
                        setState(() {
                          widget.index -= 1;
                        });
                      }
                      await setAudio();
                    },
                  ),
                ),
                CircleAvatar(
                  radius: 35,
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    iconSize: 50,
                    onPressed: () async {
                      if (isPlaying) {
                        await widget.service.audioPlayer.pause();
                      } else {
                        await widget.service.audioPlayer.resume();
                      }
                    },
                  ),
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(
                        Icons.keyboard_double_arrow_right_outlined
                    ),
                    iconSize: 50,
                    onPressed: () async {
                      if (widget.index == widget.songs.length - 1) {
                        setState(() {
                          widget.index = 0;
                        });
                      } else {
                        setState(() {
                          widget.index += 1;
                        });
                      }
                      await setAudio();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    //widget.notifyParent();
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => SongsPage(service: widget.service,)
    //     )
    // );
  }
}
