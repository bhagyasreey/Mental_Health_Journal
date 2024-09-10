import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bar extends StatefulWidget {
  const Bar({super.key});

  @override
  BarChartWidgetState createState() => BarChartWidgetState();
}
// Declaring moods for finding frequency of moods

class BarChartWidgetState extends State<Bar> {
  Map<String, double> moodFrequencies = {
    'angry': 0,
    'sad': 0,
    'neutral': 0,
    'happy': 0,
    'very happy': 0,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Fetching the mood scores from firebase
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('moods').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            moodFrequencies = {
              'angry': 0,
              'sad': 0,
              'neutral': 0,
              'happy': 0,
              'very happy': 0,
            };

            // Calculating the mood frequencies
            snapshot.data!.docs.forEach((doc) {
              double mood = doc['mood'].toDouble();
              if (mood == 1) {
                moodFrequencies['angry'] = (moodFrequencies['angry']! + 1);
              } else if (mood == 2) {
                moodFrequencies['sad'] = moodFrequencies['sad']! + 1;
              } else if (mood == 3) {
                moodFrequencies['neutral'] = moodFrequencies['neutral']! + 1;
              } else if (mood == 4) {
                moodFrequencies['happy'] = moodFrequencies['happy']! + 1;
              } else if (mood == 5) {
                moodFrequencies['very happy'] =
                    moodFrequencies['very happy']! + 1;
              }
            });

            return SizedBox(
              height: 300,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                    child: Text(
                      "Mood Analysis",
                      style:
                          TextStyle(fontSize: 20, fontFamily: "Balsamiq Sans"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    // Displaying the bar graph of mood frequencies
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        barGroups: [
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: moodFrequencies['angry']!.toDouble(),
                                color: const Color.fromRGBO(245, 214, 214, 1),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: moodFrequencies['sad']!.toDouble(),
                                color: const Color.fromRGBO(254, 222, 205, 1),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 3,
                            barRods: [
                              BarChartRodData(
                                toY: moodFrequencies['neutral']!.toDouble(),
                                color: const Color.fromRGBO(136, 226, 254, 0.4),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 4,
                            barRods: [
                              BarChartRodData(
                                toY: moodFrequencies['happy']!.toDouble(),
                                color: const Color.fromRGBO(254, 236, 250, 1),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 5,
                            barRods: [
                              BarChartRodData(
                                toY: moodFrequencies['very happy']!.toDouble(),
                                color: const Color.fromRGBO(96, 212, 163, 0.58),
                              ),
                            ],
                          ),
                        ],
                        gridData: const FlGridData(show: false),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
