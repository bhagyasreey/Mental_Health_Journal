import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'package:start_page/pages/home/storypage.dart';
import 'package:start_page/pages/journal/get.dart';
import 'package:start_page/pages/home/test.dart';
import 'package:start_page/pages/settings/fetch_data.dart';
import 'package:start_page/pages/home/Mood.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? selectedEmoji;
  late AudioPlayer audioPlayer;
  // Images for daily affirmations
  final List<String> circleImagePaths = [
    'assets/2.png',
    'assets/4.png',
    'assets/7.png',
    'assets/9.png',
  ];

  void _openStory(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryPage(circleIndex: index),
        // Navigate to the story upon clicking on the story
      ),
    );
  }

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    playBackgroundMusic();
  }

  Future<void> playBackgroundMusic() async {
    try {
      // Play the background music upon starting on the home page
      await audioPlayer.play(AssetSource("background_music.mp3"));
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      print("Error playing background music: $e");
    }
  }

  Future<void> stopBackgroundMusic() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Balsamiq Sans"),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(180), 
          child: AppBar(
            scrolledUnderElevation: 0,
            flexibleSpace: Stack(
              children: <Widget>[
                const Positioned(
                  top: 30,
                  left: -1,
                  child: Image(
                    image: AssetImage("assets/Ellipse 6.png"),
                    height: 160,
                    width: 152,
                  ),
                ),
                Positioned(
                  top: -5,
                  left: 80,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.75),
                      BlendMode.dstIn,
                    ),
                    child: const Image(
                      image: AssetImage("assets/Ellipse 5.png"),
                      height: 93,
                      width: 93,
                    ),
                  ),
                ),
                const Positioned(
                  top: -20,
                  left: -20,
                  child: Image(
                    image: AssetImage("assets/Ellipse 4.png"),
                    height: 169,
                    width: 158,
                  ),
                ),
                const Positioned(
                  top: -47,
                  left: -50,
                  child: Image(
                    image: AssetImage("assets/Logo.png"),
                    height: 200,
                    width: 200,
                  ),
                ),
                const Positioned(
                  top: 70,
                  left: 220,
                  child: Icon(
                    // For streaks
                    Icons.local_fire_department,
                    size: 30,
                  ),
                ),
                Positioned(top: 75, left: 260, child: DayStreakCounter()),
                Positioned(
                  top: 70,
                  left: 300,
                  child: GestureDetector(
                    onTap: () {
                      // On and off the music as you tap on the icon
                      if (isPlaying) {
                        stopBackgroundMusic();
                      } else {
                        playBackgroundMusic();
                      }
                    },
                    child: Icon(
                      isPlaying ? Icons.music_note : Icons.music_off,
                      size: 30,
                      // Change the icon to music_off upon offing the music
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetingWidget(),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: FetchedNameWidget(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Row(
                  // Stories with Daily Quotation, Morning, Afternoon, Evening Affirmations
                  children: List.generate(
                    4,
                    (index) => StoryCircle(
                      function: () {
                        _openStory(context, index);
                      },
                      imagePath: circleImagePaths[index],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 4, right: 4),
                // Select your daily mood
                child: Feel(
                  onEmojiSelected: (emoji) {
                    setState(() {
                      selectedEmoji = emoji;
                    
                    });
                  },
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                // Get a daily prompt
                child: Prompt(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Generate a random question

class Prompt extends StatelessWidget {
  const Prompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RandomQuestionPage();
  }
}

class RandomQuestionPage extends StatefulWidget {
  const RandomQuestionPage({Key? key}) : super(key: key);

  @override
  _RandomQuestionPageState createState() => _RandomQuestionPageState();
}

class _RandomQuestionPageState extends State<RandomQuestionPage> {
  List<String> questions = [
    "What is your favorite color?",
    "What is your favorite food?",
    "What is your favorite movie?",
    "What is your favorite hobby?",
    "What is your dream travel destination?",
    // Some prompts
  ];

  String currentQuestion = "";

  @override
  void initState() {
    super.initState();
    // Set an initial random question when the widget initializes
    getRandomQuestion();
  }

  void getRandomQuestion() {
    final random = Random();
    final index = random.nextInt(questions.length);
    setState(() {
      currentQuestion = questions[index];
    });
  }

  void shuffleQuestions() {
    setState(() {
      questions.shuffle();
      // After shuffling, update the current question to the first one in the list
      currentQuestion = questions.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 150,
        width: 380,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: const Color.fromRGBO(239, 253, 255, 1),
          child: Stack(
            children: [
              Positioned(
                left: 20,
                top: 20,
                right: 20,
                child: Text(
                  currentQuestion.isNotEmpty
                      ? currentQuestion
                      : "Press button to get a question",
                  style: const TextStyle(fontSize: 20.0, color: Colors.black),
                  softWrap: true,
                ),
              ),
              Positioned(
                left: 20,
                bottom: 20,
                child: GestureDetector(
                  onTap: shuffleQuestions,
                  child: const Icon(Icons.shuffle),
                ),
              ),
              Positioned(
                right: 30,
                bottom: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Getdata(
                          upd: false,
                          initialTitle: currentQuestion,
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.edit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Code for circles

class StoryCircle extends StatelessWidget {
  final VoidCallback function;
  final String imagePath; 

  StoryCircle({required this.function, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

// Code for fetching name from the firebase

class FetchedNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserData.fetchUserData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            String? name = UserData.name;

            if (name != null) {
              return Text(
                '$name',
                style: TextStyle(
                  fontSize: 36,
                  color: Color.fromRGBO(49, 145, 100, 1),
                ),
              );
            } else {
              return Text('Reflective Respite');
            }
          }
        }
      },
    );
  }
}

//Code for customisation of greetings

class GreetingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat.H();
    int hour = int.parse(dateFormat.format(now));
    String greeting;
    if (hour >= 6 && hour < 12) {
      greeting = 'Good morning,';
    } else if (hour >= 12 && hour < 18) {
      greeting = 'Good afternoon,';
    } else if (hour >= 18 && hour < 22) {
      greeting = 'Good evening,';
    } else {
      greeting = 'Good night,';
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        greeting,
        style: TextStyle(
          fontSize: 50,
        ),
      ),
    );
  }
}
