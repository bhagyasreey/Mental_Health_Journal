import 'package:flutter/material.dart';

// Each onboarding page

class OnboardingPage extends StatelessWidget {
  final String? title;
  final String? description;
  final String imagePath;

  const OnboardingPage({
    super.key,
    this.title,
    this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit
                    .cover, // Set the background image to cover the entire screen
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 250),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (title != null && description != null)
                    Text(
                      title!,
                      style: const TextStyle(
                          fontFamily: 'BalsamiqSans',
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 77, 23, 4)),
                    ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 50),
                  if (description != null)
                    Text(
                      description!,
                      style: const TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 6, 10, 16)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
