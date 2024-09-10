import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

// A scrolling list of affirmation cards

class AffirmationsList extends StatelessWidget {
  const AffirmationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Balsamiq Sans"),
      debugShowCheckedModeBanner: false,
      home: const SafeArea(child: SnappingList()),
    );
  }
}

class Product {
  final String imagePath;
  final String title;
  Product(this.imagePath, this.title);
}

class SnappingList extends StatefulWidget {
  const SnappingList({Key? key}) : super(key: key);

  @override
  _SnappingListState createState() => _SnappingListState();
}

// List of affirmations

class _SnappingListState extends State<SnappingList> {
  List<Product> productList = [
    Product('assets/hand_sun.png',
        'I am worthy of love and care, including my own self-care practices.'),
    Product('assets/12.png',
        'I deserve to prioritize my mental health and well-being every day..'),
    Product('assets/13.png',
        'I am resilient, capable of overcoming any challenges that come my way.'),
    Product('assets/14.png',
        'I am allowed to set boundaries that protect my mental and emotional health.'),
    Product('assets/15.png',
        'I trust myself to navigate difficult emotions and seek support when needed.'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ScrollSnapList(
        itemBuilder: _buildListItem,
        itemCount: productList.length,
        itemSize: 250,
        onItemFocus: (index) {},
        dynamicItemSize: true,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    Product product = productList[index];
    return SizedBox(
      width: 250,
      height: 300,
      child: Card(
        // elevation: 12,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Column(
            children: [
              Image.asset(
                product.imagePath,
                fit: BoxFit.cover,
                width: 200,
                height: 130,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  product.title,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
