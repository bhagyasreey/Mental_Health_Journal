
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:dart_sentiment/dart_sentiment.dart';  

Future<double> analyzeSentiment(String text) async {
  var sentiment = Sentiment();
  var result = await sentiment.analysis(text);
  return result['comparative'];
}

class Getdata extends StatefulWidget {
  Getdata({
    Key? key,
    this.title,
    this.message,
    this.time,
    required this.upd,
    this.docId,
    this.initialTitle,
  });

  final String? title;
  final String? message;
  final String? time;
  final bool upd;
  final String? docId;
  final String? initialTitle;

  @override
  _GetdataState createState() => _GetdataState();
}

class _GetdataState extends State<Getdata> {
  final _firestore = FirebaseFirestore.instance;
  late final titlecontroller = TextEditingController();
  final messagecontroller = TextEditingController();
  String? date;

  String randomColorGenerate() {
    final random = Random();
    final red = 150 + random.nextInt(106);
    final green = 150 + random.nextInt(106);
    final blue = 150 + random.nextInt(106);
    return '#${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
  }

  void updatedata() async {
    try {
      await _firestore.collection('message').doc(widget.docId).update({
        'title': titlecontroller.text,
        'time': date,
        'message': messagecontroller.text
      }).whenComplete(() {
        Navigator.pop(context);
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while updating data. Please try again.'),
        ),
      );
    }
  }

  Future<void> savedata() async {
    CollectionReference users = _firestore.collection('message');
    
    
    // Perform sentiment analysis
    double sentimentScore = await analyzeSentiment(messagecontroller.text);

    try {
      await users.add({
        'title': titlecontroller.text,
        'message': messagecontroller.text,
        'time': date!,
        'color': randomColorGenerate(),
        'sentiment_score': sentimentScore // Store sentiment score in the database
      }).whenComplete(() {
        Navigator.pop(context);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while updating data. Please try again.'),
        ),
      );
    }
  }

  void currentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM,yyyy HH:mm:ss').format(now);
    date = formattedDate;
  }

  @override
  void initState() {
    super.initState();
    currentDate();

    if (widget.upd) {
      titlecontroller.text = widget.title ?? '';
      messagecontroller.text = widget.message ?? '';
      date = widget.time ?? date;
    } else {
      titlecontroller.text = widget.initialTitle ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Thoughts',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (widget.upd == false) {
                savedata();
              } else {
                updatedata();
              }
            },
            child: Text(widget.upd ? 'Update data' : 'Save data'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 254, 254),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: TextField(
                        controller: titlecontroller,
                        decoration: const InputDecoration(
                          hintText: "Enter title...",
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  date!,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(0, 136, 218, 205),
                ),
                child: TextField(
                  controller: messagecontroller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    hintText: "Enter message...",
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
