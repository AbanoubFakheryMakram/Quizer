import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Quizer app',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: ThemeData(brightness: Brightness.dark),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, bool>> quizes = [
    {
      ' A man from the USA consumed his 26,000th Big Mac on 11th October 2012, after eating at least one a day for forty years.':
          true
    },
    {'The longest distance swam underwater in one breath is 200metres.': true},
    {
      'The fastest time to eat 15 Ferrero Rocher is 1 minute 10 seconds.': false
    },
    {'The record for most needles inserted into the head is 15,000.': false},
    {
      'The world’s longest legs belong to a Russian lady and measure 132cm (51.9 inches)':
          true
    },
    {
      ' The heaviest aircraft pulled by a single man weighed 188.83 tonnes and was pulled 8.8 metres.':
          true
    },
    {
      'The record for the fastest time to solve a Rubik’s Cube one-handed is 37 seconds.':
          false
    },
    {'The world’s tallest living man is 251cm / 8 ft 3 in.': true},
    {
      'The most expensive car number plate, showing only the number ‘1’, was bought in the United Arab Emirates for 52.2 million dirham, the approximate equivalent of £7.2 million.':
          true
    },
    {
      'The record for the longest rail tunnel is held by the Channel Tunnel between Britain and France.':
          false
    },
    {'Sir Paul McCartney’s middle name is James': false},
    {'Jupiter is the fifth planet from the sun.': true},
    {'Gillian Anderson was born in Chicago, Illinois.': true},
    {'Lithium has the atomic number 17.': false},
    {
      'The Guinness World Record for most fingers and toes at birth is held by an Indian man born with 14 fingers and 20 toes in total':
          true
    },
    {
      'The oldest building in the world is the Pyramid of Djoser in Egypt.':
          false
    },
    {'Engelbert Humperdinck was born in 1928.': false},
    {
      'Sir Steve Redgrave is the only rower to have received the award of BBC Sports Personality of the Year.':
          true
    },
    {'Hotmail was launched in 1996.': true},
    {
      'From the ground to the torch, the Statue of Liberty is 93 metres high.':
          true
    },
  ];

  // Audio player
  AudioPlayer player;

  // for change question number
  int counter = 0;

  // true or false icon
  List<Widget> scoreKeeper = [];

  // question body
  String text;

  // questions is finished ?
  bool isFinished = false;

  int score = 0;

  @override
  void initState() {
    super.initState();

    // set to the first question
    text = quizes[counter].keys.toString();

    // change indices randomly
    quizes.shuffle();

    player = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'score: $score',
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$text',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                          isFinished
                              ? IconButton(
                                  icon: Icon(
                                    Icons.threesixty,
                                    size: 33,
                                  ),
                                  onPressed: () {
                                    // reset data
                                    resetData();
                                  })
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 130,
                      color: Colors.green,
                      child: FlatButton(
                        onPressed: isFinished
                            ? null
                            : () {
                                changeQuestion(
                                    quizes[counter].values.first, true);
                              },
                        child: Text('TRUE'),
                      ),
                    ),
                    Container(
                      height: 80,
                      color: Colors.red,
                      child: FlatButton(
                        onPressed: isFinished
                            ? null
                            : () {
                                changeQuestion(
                                    quizes[counter].values.first, false);
                              },
                        child: Text('FALSE'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: scoreKeeper,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetData() {
    score = 0;
    isFinished = false;
    counter = 0;
    scoreKeeper = [];
    quizes.shuffle();
    text = quizes[counter].keys.toString();
    setState(() {});
  }

  changeQuestion(answer, userAnswer) {
    if (userAnswer.toString() == answer.toString()) {
      scoreKeeper.add(
        Icon(
          Icons.check,
          color: Colors.green,
        ),
      );
      ++score;
      playSound('true.mp3');
    } else {
      scoreKeeper.add(
        Icon(
          Icons.close,
          color: Colors.red,
        ),
      );
      playSound('false.mp3');
    }

    counter++;
    if (counter >= quizes.length) {
      counter = 0;
      text = 'FINISHED';
      isFinished = true;
      showFinishedDialog();
    } else {
      text = quizes[counter].keys.first.toString();
    }

    setState(() {});
  }

  void showFinishedDialog() {
    showAnimatedDialog(
      context: context,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      animationType: DialogTransitionType.size,
      builder: (context) {
        return ClassicGeneralDialogWidget(
          contentText: 'Finished',
          positiveText: 'Play Again',
          onNegativeClick: () {
            Navigator.of(context).pop();
            exit(0);
          },
          positiveTextStyle: TextStyle(color: Colors.white),
          onPositiveClick: () {
            resetData();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future playSound(String soundName) async {
    await player.pause();
    await player.stop();
    final file = File('${(await getTemporaryDirectory()).path}/$soundName');
    await file.writeAsBytes((await loadAsset(soundName)).buffer.asUint8List());
    await player.play(file.path, isLocal: true);
  }

  Future loadAsset(String soundName) async {
    return await rootBundle.load('assets/$soundName');
  }

  Future stopSound() async {
    await player.stop();
  }

  Future pauseSound() async {
    await player.pause();
  }

  @override
  void dispose() {
    super.dispose();
    stopSound();
  }
}
