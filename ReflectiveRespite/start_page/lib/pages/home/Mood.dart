import 'package:flutter/material.dart';

class Feel extends StatefulWidget {
  final Function(String) onEmojiSelected;

  Feel({required this.onEmojiSelected});
  @override
  _FeelState createState() => _FeelState();
}

class _FeelState extends State<Feel> {
  int _selectedMood = 0;
  // Default mood (neutral)
  bool _showReasons = false;
  List<String> todayGoals = []; // List to store today's goals
  List<String> selectedGoals = []; // List to store selected goals

  // Method to add a goal to today's goals
  void _addGoal(String goal) {
    setState(() {
      todayGoals.add(goal);
    });
  }

  // Method to remove a goal from today's goals
  void _removeGoal(String goal) {
    setState(() {
      todayGoals.remove(goal);
    });
  }

  // Method to mark a goal as completed
  void _toggleGoalCompletion(String goal) {
    setState(() {
      if (selectedGoals.contains(goal)) {
        selectedGoals.remove(goal);
        todayGoals.remove(goal); // Remove the goal from today's goals list
      } else {
        selectedGoals.add(goal);
      }
    });
  }

  String _getEmojiForMood(int mood) {
    // logic to determine emoji for each mood
    switch (mood) {
      case 1:
        return '😠';
      case 2:
        return '😞';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        buildTodayGoals(),
        const SizedBox(height: 30),
        SizedBox(
          height: 150,
          child: Card(
            color: const Color.fromRGBO(254, 236, 250, 1),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'How was your day?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMoodButton(1, '😠'),
                      _buildMoodButton(2, '😞'),
                      _buildMoodButton(3, '😐'),
                      _buildMoodButton(4, '😊'),
                      _buildMoodButton(5, '😄'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_showReasons) ...[
          // Display Mood Goals upon selecting a mood
          const SizedBox(height: 30),
          const Text(
            'Mood Goals:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          _buildReasonBox(),
        ],
      ],
    );
  }

  Widget _buildMoodButton(int mood, String emoji) {
    return GestureDetector(
      onTap: () => _selectMood(mood),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _selectedMood == mood
              ? const Color.fromRGBO(250, 248, 250, 1)
              : Colors.transparent,
        ),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildReasonBox() {
    // Define a list of colors for each reason
    List<Color> colors = [
      const Color.fromRGBO(240, 220, 255, 1),
      const Color.fromRGBO(199, 236, 239, 1),
      const Color.fromRGBO(254, 222, 205, 1),
      const Color.fromRGBO(136, 226, 254, 1)
    ];
    List<String> reasons = [];

    // Customize reasons based on the selected mood
    switch (_selectedMood) {
      case 1:
        reasons = [
          "Practice deep breathing or relaxation techniques to manage anger.",
          "Identify triggers and develop coping strategies to address them.",
          "Communicate assertively rather than reactively when feeling angry.",
          "Seek professional help or support if anger becomes overwhelming."
        ];
        break;
      case 2:
        reasons = [
          "Engage in self-care activities such as exercise, meditation, or spending time in nature.",
          "Reach out to friends or loved ones for support and connection.",
          "Express emotions through creative outlets such as art, writing, or music.",
          "Seek therapy or counseling to explore underlying causes of sadness and develop coping strategies."
        ];
        break;
      case 3:
        reasons = [
          "Practice mindfulness and staying present in the moment.",
          "Engage in activities that bring a sense of balance and calm, such as yoga or tai chi.",
          "Explore hobbies or interests that promote relaxation and enjoyment.",
          "Focus on gratitude and appreciation for the small joys in life."
        ];
        break;
      case 4:
        reasons = [
          "Cultivate gratitude by keeping a gratitude journal or practicing daily affirmations.",
          "Nurture relationships with positive and supportive individuals.",
          "Engage in activities that bring joy and fulfillment",
          "Prioritize self-care and make time for activities that promote mental and emotional well-being."
        ];
        break;
      case 5:
        reasons = [
          "Celebrate accomplishments and successes, no matter how small.",
          "Spread joy and positivity to others through acts of kindness and generosity.",
          "Foster a sense of humor and find reasons to laugh every day.",
          "Stay connected with loved ones and cherish moments of shared happiness and laughter."
        ];
        break;
      default:
        reasons = [
          'Achieve a state of calmness and relaxation to reduce stress and promote emotional balance.',
          "Cultivate a positive outlook and optimistic mindset to enhance resilience and cope with life's challenges.",
          'Increase energy levels and vitality to feel more motivated, productive, and engaged in daily activities.',
          ' Enhance mental clarity to improve concentration, decision-making, and problem-solving abilities.'
        ];
    }

    // Split the reasons list into two separate rows
    List<String> reasonsRow1 = reasons.sublist(0, 2);
    List<String> reasonsRow2 = reasons.sublist(2, 4);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: reasonsRow1
              .asMap()
              .map((index, reason) =>
                  MapEntry(index, _buildReasonItem(reason, colors[index])))
              .values
              .toList(),
        ),
        const SizedBox(height: 10), // Add vertical spacing between rows
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: reasonsRow2
              .asMap()
              .map((index, reason) =>
                  MapEntry(index, _buildReasonItem(reason, colors[index + 2])))
              .values
              .toList(),
        ),
      ],
    );
  }

  Widget _buildReasonItem(String reason, Color color) {
    return Container(
      height: 200,
      width: 150,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                reason,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                // Add the goal to today's goals
                _addGoal(reason);
              },
              child: const Text('Set Goal'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTodayGoals() {
    return Column(
      children: [
        const Text(
          'Today Goals',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...todayGoals.map((goal) => _buildGoalItem(goal)).toList(),
      ],
    );
  }

  Widget _buildGoalItem(String goal) {
    return ListTile(
      title: Text(goal),
      trailing: Checkbox(
        value: selectedGoals.contains(goal),
        onChanged: (bool? value) {
          // Remove the goal upon double-clicking on the check box
          _toggleGoalCompletion(goal);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _showReasons = false;
  }

  void _selectMood(int mood) {
    setState(() {
      _selectedMood = mood;
      _showReasons = true; // Show reasons when mood is selected
    });
  }
}
