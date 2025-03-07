import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:start_page/pages/journal/get.dart';

class Showdata extends StatefulWidget {
  const Showdata({Key? key});

  @override
  State<Showdata> createState() => _ShowdataState();
}

class _ShowdataState extends State<Showdata> {
  final _firestore = FirebaseFirestore.instance;
  bool upd = false;

  void confirmdelete(id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Entry'),
          content: const Text('Do you wish to delete this entry?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  CollectionReference collection = _firestore.collection('message');
                  DocumentReference docref = collection.doc(id);
                  await docref.delete();
                } catch (e) {
                  
                    print("Error deleting document: $e");
                  
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('message').orderBy('time').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final messages = snapshot.data?.docs.reversed;
            List<Widget> messagetextwidget = [];

            for (var message in messages!) {
              final titletext = message.data()['title'] ?? "";
              final timetext = message.data()['time'] ?? "";
              final messagetext = message.data()['message'] ?? "";
              final color = message.data()['color'] ?? "";
              final docId = message.id;

              final messagewidget = MessageNote(
                title: titletext,
                time: timetext,
                message: messagetext,
                id: docId,
                deletedata: (String? id) => confirmdelete(id),
                color: color,
              );
              messagetextwidget.add(messagewidget);
            }
            return ListView(
              reverse: false,
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              children: messagetextwidget,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Getdata(
                upd: false,
              ),
            ),
          );
        },
        backgroundColor: const Color.fromRGBO(214, 169, 249, 1),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class MessageNote extends StatelessWidget {
  MessageNote({
    required this.title,
    required this.time,
    required this.message,
    this.id,
    this.deletedata,
    this.color,
  });

  final String title;
  final String time;
  final String message;
  final String? id;
  final Function(String?)? deletedata;
  final String? color;

  Color randomColorGenerate() {
    List<Color> colorList = [
      const Color(0xD6F5E6),
      const Color(0xFEDECD),
      const Color(0xE2B1B1),
      const Color(0xB1E2B9),
      const Color(0xFEECFA),
      const Color(0xD5F8FB),
      const Color(0xC7ECEF),
      const Color(0xF0DCFF),
      const Color.fromARGB(0, 246, 218, 202),
      const Color.fromARGB(0, 207, 238, 241),
      const Color.fromARGB(0, 173, 236, 241),
      const Color(0xE2F5F2),
      const Color(0xFFd8b0d2),
      const Color(0xFFaaa8bf),
      const Color(0xFFd9f5cd),
    ];
    Random random = Random();
    int index = random.nextInt(colorList.length);
    return colorList[index];
  }

  Color hexToColor(String hexCode) {
    final buffer = StringBuffer();
    if (hexCode.length == 6 || hexCode.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexCode.replaceFirst('#', ''));
    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      // Return default color if parsing fails
      return randomColorGenerate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = color != null ? hexToColor(color!) : randomColorGenerate();

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Getdata(
                upd: true,
                title: title,
                message: message,
                time: time,
                docId: id,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: bgColor,
          ),
          padding: const EdgeInsets.all(19),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 240),
                    child: Text(
                      title == "" ? "Undefined" : title,
                      style: const TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 240),
                    child: Text(
                      message == "" ? "Undefined" : message,
                      softWrap: true,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    time,
                    style:  TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                ],
              ),
              Center(
                child: IconButton(
                  onPressed: () {
                    deletedata!(id);
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 25,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
