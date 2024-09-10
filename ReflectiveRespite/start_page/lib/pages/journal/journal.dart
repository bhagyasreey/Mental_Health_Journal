import 'package:flutter/material.dart';
import 'package:start_page/pages/journal/show.dart';

class Journal extends StatelessWidget {
  const Journal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Balsamiq Sans'),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(140), 
          child: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Center(
                child: Text(
                  'My Journal',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
            flexibleSpace: const Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -10,
                  child: Image(
                    image: AssetImage("assets/Ellipse 18.png"),
                    height: 132,
                    width: 136,
                  ),
                ),
                Positioned(
                  top: -28,
                  left: -21,
                  child: Image(
                    image: AssetImage("assets/Ellipse 15.png"),
                    height: 132,
                    width: 136,
                  ),
                ),
                Positioned(
                  top: -39,
                  left: -53,
                  child: Image(
                    image: AssetImage("assets/Logo.png"),
                    height: 200,
                    width: 200,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: const Showdata(),
      ),
    );
  }
}
