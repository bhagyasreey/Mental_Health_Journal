import 'package:flutter/material.dart';
import 'package:start_page/pages/settings/account_screen.dart';
import 'package:start_page/pages/explore/explore.dart';
import 'package:start_page/pages/journal/journal.dart';
import 'package:start_page/pages/home/home.dart';
import 'package:start_page/pages/statistics/stat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:start_page/pages/home/onboarding_screen.dart';

// The program starts from here
void main() {
  initializeFirebase();
  runApp(const MyApp());
}

// Initialising firebase
void initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Balsamiq Sans"),
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    Home(),
    Explore(),
    Journal(),
    Stat(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bottom Navigation Bar
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor:
            Color.fromARGB(255, 150, 219, 225), 
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
