import 'package:flutter/material.dart';
import 'package:start_page/pages/explore/explore.dart';

// Emotion Cards

class Emotion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CardItem(
            imagePath: "assets/sleep.png",
            text: 'Sleepy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmotionPage(sleepyContent),
                ),
              );
            },
          ),
          CardItem(
            imagePath: "assets/tired.png",
            text: 'Tired',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmotionPage(tiredContent),
                ),
              );
            },
          ),
          CardItem(
            imagePath: "assets/irritated.png",
            text: 'Irritated',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmotionPage(irritatedContent),
                ),
              );
            },
          ),
          CardItem(
            imagePath: "assets/confused.png",
            text: 'Confused',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmotionPage(confusedContent),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Upon tapping open the remedies for the ceratin emotions

class CardItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  final String imagePath;

  CardItem({
    required this.text,
    required this.onTap,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmotionPage extends StatelessWidget {
  final EmotionContent content;

  EmotionPage(this.content);

  @override
  Widget build(BuildContext context) {
    List<String> lines = content.description.split('\n');

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(content.emotionName),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Explore(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Feeling ${content.emotionName} ?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            for (var line in lines)
              Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    line,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class EmotionContent {
  final String emotionName;
  final String description;

  EmotionContent(this.emotionName, this.description);
}

final sleepyContent = EmotionContent(
  'Sleepy',
  "Establish a consistent sleep schedule, going to bed and waking up at the same time every day, even on weekends.\nAvoid consuming caffeine or heavy meals close to bedtime.\nCreate a relaxing bedtime routine to signal to your body that it's time to wind down.\nEnsure your sleep environment is conducive to rest, with minimal noise, comfortable bedding, and optimal room temperature.\nIf possible, take short power naps (around 20-30 minutes) during the day to combat sleepiness.",
);

final tiredContent = EmotionContent(
  'Tired',
  "Prioritize activities that boost your energy levels, such as engaging in physical exercise or spending time outdoors in natural light.\nBreak tasks into smaller, manageable chunks to prevent feeling overwhelmed.\nPractice good posture and take regular breaks if you're sitting for extended periods.\nStay hydrated by drinking plenty of water throughout the day.\nConsider incorporating energizing foods into your diet, such as complex carbohydrates, lean proteins, and foods rich in vitamins and minerals.",
);

final irritatedContent = EmotionContent(
  'Irritated',
  "Practice relaxation techniques like deep breathing exercises, progressive muscle relaxation, or meditation to calm your mind and body.\nIdentify triggers that contribute to your irritability and develop coping strategies to manage them effectively.\nEngage in activities that bring you joy or provide a sense of accomplishment, such as hobbies or creative pursuits.\nCommunicate your feelings assertively but calmly with others, expressing your needs and boundaries clearly.\nTake time for self-care activities that promote relaxation and emotional well-being, such as taking a bath, listening to music, or spending time in nature.",
);

final confusedContent = EmotionContent(
  'Confused',
  "Slow down and take a moment to gather your thoughts before attempting to tackle complex tasks or make decisions.\nBreak down information into smaller, more manageable chunks to aid comprehension.\nAsk for clarification or seek assistance from others if you're feeling uncertain or overwhelmed.\nPractice mindfulness techniques to increase awareness and focus, helping to reduce mental clutter and confusion.\nKeep a journal or planner to track important tasks, appointments, and deadlines, helping to maintain clarity and organization in your daily life.",
);
