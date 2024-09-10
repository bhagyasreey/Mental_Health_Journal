import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DayStreakCounter extends StatefulWidget {
  @override
  DayStreakCounterState createState() => DayStreakCounterState();
}

class DayStreakCounterState extends State<DayStreakCounter> {
  int counterOfConsecutiveDays = 1;
  @override
  void initState() {
    super.initState();
    _updateCounter(); // Update the counter when the widget initializes
  }

  Future<void> _updateCounter() async {
    // Get current date
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('message')
        .where('time',
            isGreaterThanOrEqualTo:
                today) // Check for messages with a timestamp greater than or equal to today
        .where('time',
            isLessThan: today +
                'T23:59:59') // Check for messages with a timestamp less than the end of today
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Message exists for today, update streak
      final int streakCounter = counterOfConsecutiveDays;
      final int newStreakCounter = streakCounter + 1;

      // Update streak counter
      setState(() {
        counterOfConsecutiveDays = newStreakCounter;
      });
    } else {
      // No message for today, reset streak
      setState(() {
        counterOfConsecutiveDays = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$counterOfConsecutiveDays',
      style: TextStyle(fontSize: 14),
    );
  }
}
