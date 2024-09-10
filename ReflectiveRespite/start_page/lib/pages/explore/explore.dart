import 'package:flutter/material.dart';
import 'package:start_page/pages/explore/affirmations.dart';
import 'package:start_page/pages/explore/music.dart';
import 'package:start_page/pages/explore/meditation.dart';
import 'package:start_page/pages/explore/emotions.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Balsamiq Sans"),
      debugShowCheckedModeBanner: false,
      title: 'Explore',
      home: const MyExplore(),
    );
  }
}

class MyExplore extends StatelessWidget {
  const MyExplore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(150), 
          child: AppBar(
            scrolledUnderElevation: 0,
            flexibleSpace: Stack(
              children: <Widget>[
                const Positioned(
                  top: 30,
                  left: 80,
                  child: Image(
                    image: AssetImage("assets/Ellipse 17.png"),
                    height: 160,
                    width: 152,
                  ),
                ),
                Positioned(
                  top: -5,
                  left: 280,
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
                  top: 80,
                  left: 200,
                  child: Text(
                    "Explore",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 44),
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
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Daily Affirmations',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: const AffirmationsList(),
              ),
               const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Music',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: const MusicCard(),
              ),
               const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Meditation',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: const VideoCard(),
              ),
               const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Know your emotions',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Emotion(),
              ),
              const SizedBox(height:20),
            ],
          ),
        ));
  }
}
