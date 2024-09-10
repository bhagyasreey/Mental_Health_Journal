import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StoryPage extends StatefulWidget {
  final int circleIndex;

  const StoryPage({super.key, required this.circleIndex});

  @override
  // ignore: library_private_types_in_public_api
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  int currentStoryIndex = 0;
  late List<Widget> myStories;
  late List<double> percentWatched;

  @override
  void initState() {
    super.initState();

    // Initialize stories and watched percentages based on the circle index
    switch (widget.circleIndex) {
      case 0:
        myStories = [const MyStory1()];
        break;
      case 1:
        myStories = [const MyStory2()];
        break;
      case 2:
        myStories = [const MyStory3()];
        break;
      case 3:
        myStories = [const MyStory4()];
        break;
      default:
        myStories = [];
    }

    percentWatched = List.generate(myStories.length, (index) => 0);

    _startWatching();
  }

  void _startWatching() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (percentWatched[currentStoryIndex] + 0.01 < 1) {
          percentWatched[currentStoryIndex] += 0.01;
        } else {
          percentWatched[currentStoryIndex] = 1;
          timer.cancel();

          if (currentStoryIndex < myStories.length - 1) {
            currentStoryIndex++;
            _startWatching();
          } else {
            Navigator.pop(context);
          }
        }
      });
    });
  }
// Closing the story upon tapping on the story
  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 2) {
      setState(() {
        if (currentStoryIndex > 0) {
          percentWatched[currentStoryIndex - 1] = 0;
          percentWatched[currentStoryIndex] = 0;
          currentStoryIndex--;
        }
      });
    } else {
      setState(() {
        if (currentStoryIndex < myStories.length - 1) {
          percentWatched[currentStoryIndex] = 1;
          currentStoryIndex++;
        } else {
          percentWatched[currentStoryIndex] = 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _onTapDown(details),
      child: Scaffold(
        body: Stack(
          children: [
            myStories[currentStoryIndex],
            // Percent of story watched
            MyStoryBars(percentWatched: percentWatched),
          ],
        ),
      ),
    );
  }
}

class MyProgressBar extends StatelessWidget {
  final double percentWatched;

  const MyProgressBar({super.key, required this.percentWatched});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      lineHeight: 8, // Decrease the height of the progress bar line
      percent: percentWatched,
      progressColor: const Color.fromARGB(255, 253, 252, 252),
      backgroundColor: Colors.grey[600],
    );
  }
}

class MyStoryBars extends StatelessWidget {
  final List<double> percentWatched;

  const MyStoryBars({super.key, required this.percentWatched});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 4, horizontal: 8), 
      child: Row(
        children: List.generate(
          percentWatched.length,
          (index) => Expanded(
            child: MyProgressBar(percentWatched: percentWatched[index]),
          ),
        ),
      ),
    );
  }
}

// Set the contents for each story

class MyStory1 extends StatelessWidget {
  const MyStory1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/story.jpeg'), 
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class MyStory2 extends StatelessWidget {
  const MyStory2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/gotit.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class MyStory3 extends StatelessWidget {
  const MyStory3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/Daily Affirmation.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class MyStory4 extends StatelessWidget {
  const MyStory4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/calm.jpeg'), 
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
