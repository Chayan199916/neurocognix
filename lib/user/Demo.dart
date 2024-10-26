import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> with TickerProviderStateMixin {
  List<String> words = ["Flutter", "Dart", "Widgets", "Design", "Creative"];
  List<String> rememberedWords = [];
  int currentIndex = 0;
  int currentStoryIndex = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  late AnimationController typingController;
  String displayedText = "";
  Timer? storyTimer;

  @override
  void initState() {
    super.initState();
    typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // Typing speed
    )..addListener(() {
        setState(() {
          displayedText = _buildTypingText(currentStoryIndex);
        });
      });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    typingController.dispose();
    storyTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Word Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  'Remember the words:',
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: ListView.builder(
                itemCount: currentIndex + 1,
                itemBuilder: (context, index) {
                  return Text(
                    words[index],
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: rememberedWords.contains(words[index])
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: rememberedWords.contains(words[index])
                          ? Colors.blue
                          : Colors.black,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  'Current Word: ${words[currentIndex]}',
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (currentIndex < words.length - 1) {
                      rememberedWords.add(words[currentIndex]);
                      currentIndex++;
                    } else {
                      rememberedWords.add(words[currentIndex]);
                      _showStoryDialog();
                    }
                  });
                },
                child: currentIndex < words.length - 1
                    ? const Text('Next Word')
                    : const Text('Show Story'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Story with Remembered Words"),
          content: SingleChildScrollView(
            child: AnimatedBuilder(
              animation: typingController,
              builder: (context, child) {
                return Text(displayedText,
                    style: const TextStyle(fontSize: 15.0));
              },
            ),
          ),
        );
      },
    );
    _playBackgroundNarration();
    _startStoryTimer();
  }

  void _startStoryTimer() {
    storyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentStoryIndex < words.length - 1) {
        setState(() {
          currentStoryIndex++;
        });
        typingController.reset();
        typingController.forward();
      } else {
        timer.cancel();
      }
    });
  }

  void _playBackgroundNarration() {
    // Play the audio file for background narration
    audioPlayer.play(AssetSource('story-narration.mp3'));
  }

  String _buildTypingText(int currentWordIndex) {
    String storyText = "";

    for (int i = 0; i <= currentWordIndex; i++) {
      switch (i) {
        case 0:
          storyText += "Once upon a time in the world of ${words[i]}, ";
          break;
        case 1:
          storyText +=
              "developers were using ${words[i]} to create amazing Flutter apps. ";
          break;
        case 2:
          storyText +=
              "The journey continued with the help of ${words[i]} to craft ";
          break;
        case 3:
          storyText += "${words[i]} user interfaces. ";
          break;
        case 4:
          storyText +=
              "This process involved ${words[i]} thinking and problem-solving skills.";
          break;
      }
    }

    return storyText;
  }
}

void main() {
  runApp(const MaterialApp(
    home: Demo(),
  ));
}
