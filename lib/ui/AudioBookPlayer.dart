import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioBookPlayer extends StatefulWidget {
  final AudioPlayer? audioBookPlayer;
  final audioUrls;
  final audioUrlIndex;
  const AudioBookPlayer({this.audioBookPlayer, this.audioUrls, this.audioUrlIndex});
  _AudioBookPlayerState createState() => _AudioBookPlayerState();
}

class _AudioBookPlayerState extends State<AudioBookPlayer> {
  Duration _duration = Duration();
  Duration _position = Duration();
  bool isPlaying = false;
  bool isPaused = false;
  bool isRepeating = false;
  bool isLooping = false;
  int playNext = 1;
  int initIndex = 0;
  bool? playAction;

  List<IconData> _icon = <IconData>[
    Icons.play_circle_fill,
    Icons.pause_circle_filled,
  ];
  String url = "https://www.morexlusive.com/wp-content/uploads/2021/09/Tion_Wayne_ft_Davido_Jae5_-_Who_s_True.mp3";
  String url1 = "https://madnaija.xyz/Hit/datas//NSG%20%E2%80%93%20Petite.mp3";

  @override
  void initState() {
    super.initState();
    playAction = (this.widget.audioUrls.length >= this.widget.audioUrlIndex) && (this.widget.audioUrlIndex <= this.widget.audioUrls.length);
    this.widget.audioBookPlayer!.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    this.widget.audioBookPlayer!.onAudioPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    this.widget.audioBookPlayer!.onPlayerCompletion.listen((e) {
      _position = Duration(seconds: 0);
      setState(() {
        if (isRepeating == true) {
          isPlaying = true;
        } else {
          isPlaying = false;
          isRepeating = false;
        }
      });
    });

    this.widget.audioUrls.forEach((url) {
      this.widget.audioBookPlayer!.setUrl(url);
    });

    if (mounted) {
      if (this.widget.audioUrls.length >= 0) {
        this.widget.audioBookPlayer!.play(this.widget.audioUrls.elementAt(initIndex)).then((cur) => print("playing from url"));
        setState(() {
          this.widget.audioUrlIndex != null ? initIndex = this.widget.audioUrlIndex : initIndex;
        });
      }
    }
  }

  Widget playButton() {
    return IconButton(
      padding: const EdgeInsets.only(bottom: 15),
      icon: isPlaying == false
          ? Icon(
              _icon[0],
              size: 50,
              color: Colors.blue,
            )
          : Icon(
              _icon[1],
              size: 50,
              color: Colors.blue,
            ),
      onPressed: () {
        if (isPlaying == false) {
          this.widget.audioBookPlayer!.play(this.widget.audioUrls[this.widget.audioUrlIndex]);
          setState(() {
            isPlaying = true;
          });
          print("playing...");
        } else if (isPlaying == true) {
          this.widget.audioBookPlayer!.pause();
          setState(() {
            isPlaying = false;
          });
          print("paused...");
        }
      },
    );
  }

  Widget repeatButton() {
    return IconButton(
      icon: isRepeating == false
          ? ImageIcon(
              AssetImage("img/repeat.png"),
              size: 15,
              color: Colors.black,
            )
          : ImageIcon(
              AssetImage("img/repeat.png"),
              size: 15,
              color: Colors.blue,
            ),
      onPressed: () {
        if (isRepeating == false) {
          this.widget.audioBookPlayer!.setReleaseMode(ReleaseMode.LOOP);
          setState(() {
            isRepeating = true;
          });
          print("Repeating...");
        } else if (isRepeating == true) {
          this.widget.audioBookPlayer!.setReleaseMode(ReleaseMode.RELEASE);
          setState(() {
            isRepeating = false;
          });
          print(" NOT Repeating...");
        }
      },
    );
  }

  Widget audioSlider() {
    return Slider(
      activeColor: Colors.red,
      inactiveColor: Colors.grey[300],
      value: _position.inSeconds.toDouble(),
      min: 0.0,
      max: _duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          changeToSeconds(value.toInt());
          value = value;
        });
      },
    );
  }

  void changeToSeconds(int seconds) {
    Duration newDuration = Duration(seconds: seconds);
    this.widget.audioBookPlayer!.seek(newDuration);
  }

  void actionPopUpItemSelected(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    String message;
    if (value == 'Normal') {
      message = 'Playback is changed to Normal';
      this.widget.audioBookPlayer!.setPlaybackRate(1.0);
    } else if (value == 'FAST') {
      this.widget.audioBookPlayer!.setPlaybackRate(1.5);
      message = 'Playback is changed to 1.5 faster';
    } else if (value == 'SLOW') {
      this.widget.audioBookPlayer!.setPlaybackRate(0.5);
      message = 'Playback is changed to 0.5 slower';
    } else {
      message = 'Playback not changed';
    }
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget loopButton() {
    return Row(
      children: <Widget>[
        ImageIcon(
          AssetImage("img/loop.png"),
          size: 15,
          color: isLooping == true ? Colors.blue : Colors.black,
        ),
        SizedBox(width: 20),
        Text("Loop"),
      ],
    );
  }

  void loopAudio() {
    setState(() {
      if (isLooping = false) {
        isLooping = true;
      } else {
        isLooping = false;
      }
    });
  }

  Widget loadAsset() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          repeatButton(),
          IconButton(
              icon: ImageIcon(AssetImage("img/backword.png"), size: 15, color: Colors.black),
              onPressed: () {
                setState(() async {
                  // url = "https://www.morexlusive.com/wp-content/uploads/2021/09/Tion_Wayne_ft_Davido_Jae5_-_Who_s_True.mp3";
                  await this.widget.audioBookPlayer!.stop();
                  await this.widget.audioBookPlayer!.play(this.widget.audioUrls.elementAt(playAction == true && this.widget.audioUrlIndex - playNext));
                  isPlaying = true;
                });
              }),
          playButton(),
          IconButton(
              icon: ImageIcon(AssetImage("img/forward.png"), size: 15, color: Colors.black),
              onPressed: () {
                setState(() async {
                  url = url1;
                  await this.widget.audioBookPlayer!.stop();
                  await this.widget.audioBookPlayer!.play(this.widget.audioUrls.elementAt(playAction == true && this.widget.audioUrlIndex + playNext));
                  isPlaying = true;
                });
              }),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "LOOP",
                  child: loopButton(),
                ),
                PopupMenuItem(
                  value: "PLAYBAACK_SPEED",
                  child: PopupMenuButton(
                    child: Text("Playback Speed"),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'FAST',
                          child: Text('1.5'),
                        ),
                        PopupMenuItem(
                          value: 'Normal',
                          child: Text('Normal'),
                        ),
                        PopupMenuItem(
                          value: 'SLOW',
                          child: Text('0.5'),
                        )
                      ];
                    },
                    onSelected: (String value) {
                      print('You Click on pop up menu item');
                      actionPopUpItemSelected(value);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ];
            },
            onSelected: (String value) {
              if (value == "PLAYBACK_SPEED") {
              } else if (value == "LOOP") {
                loopAudio();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(_position.toString().split(".")[0], style: TextStyle(fontSize: 16)),
                Text(_duration.toString().split(".")[0], style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          audioSlider(),
          loadAsset(),
        ],
      ),
    );
  }
}
