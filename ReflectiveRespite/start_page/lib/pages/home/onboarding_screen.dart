import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:start_page/pages/home/onboarding_page.dart';
import 'package:start_page/pages/home/login.dart'; 

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<Widget> _pages = [
    //Onboarding Pages
    OnboardingPage(
      imagePath: 'assets/bg.jpeg',
    ),
    OnboardingPage(
      imagePath: 'assets/bg1.jpeg',
    ),
    OnboardingPage(
      imagePath: 'assets/bg2.jpeg',
    ),
  ];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      // Navigating to login page when the last screen is reached
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyLogin()),
      );
    }
  }

// Navigate to the previous onboarding page
  void previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _pages[index];
            },
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => buildDot(index: index),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous and Next Page button controls
          Padding(
            padding: const EdgeInsets.only(right:0),
            child: FloatingActionButton(
              onPressed: previousPage,
              backgroundColor: Color.fromARGB(0, 166, 225, 246),
              child: const Icon(Icons.arrow_back),
            ),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(left:100),
            child: FloatingActionButton(
              onPressed: nextPage,
              backgroundColor: Color.fromARGB(0, 166, 225, 246),
              child: const Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }

// Page indicators
  Widget buildDot({required int index}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? const Color.fromARGB(255, 6, 10, 13) : Colors.grey,
      ),
    );
  }
}
