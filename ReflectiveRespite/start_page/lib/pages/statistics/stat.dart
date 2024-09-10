import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:start_page/pages/statistics/bar_graph.dart';

class Stat extends StatefulWidget {
  const Stat({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SentimentLineChartState createState() => _SentimentLineChartState();
}

// Displaying a line chart based on the sentiment analysis scores
class _SentimentLineChartState extends State<Stat> {
  List<double> sentimentScores = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
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
                top: 80,
                left: 180,
                child: Text(
                  "Statistics",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      fontFamily: "Balsamiq Sans"),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // Getting the sentiment scores from the firebase
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('message').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                sentimentScores.clear(); // Clear existing data before updating
                final docs = snapshot.data!.docs;
                for (var doc in docs) {
                  sentimentScores.add(doc['sentiment_score'].toDouble());
                }
                // ignore: sized_box_for_whitespace
                return Container(
                  height: 600,
                  child: Column(
                    children: [
                      const SizedBox(
                        child: Text("Sentiment Analysis",
                            style: TextStyle(
                                fontSize: 20, fontFamily: "Balsamiq Sans")),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        // The Line Chart
                        child: LineChart(
                          LineChartData(
                            minX: 0,
                            maxX: sentimentScores.length.toDouble() - 1,
                            minY: -1,
                            maxY: 1,
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  sentimentScores.length,
                                  (index) => FlSpot(
                                      index.toDouble(), sentimentScores[index]),
                                ),
                                isCurved: true,
                                color: Colors.blue,
                                belowBarData: BarAreaData(show: false),
                                dotData: const FlDotData(show: true),
                                isStrokeCapRound: true,
                                barWidth: 3,
                                isStrokeJoinRound: true,
                              ),
                            ],
                            borderData: FlBorderData(show: true),
                            gridData: const FlGridData(show: false),
                          ),
                        ),
                      ),

                      // Bar Graph for mood analysis
                      const SizedBox(height: 20),
                      SizedBox(child: Bar())
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
