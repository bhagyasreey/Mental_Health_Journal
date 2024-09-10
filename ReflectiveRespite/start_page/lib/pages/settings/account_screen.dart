import 'package:flutter/material.dart';
import 'package:start_page/pages/settings/edit_screen.dart';
import 'package:start_page/pages/settings/setting_item.dart';
import 'package:ionicons/ionicons.dart';
import 'package:start_page/pages/settings/remainder.dart';
import 'package:start_page/pages/settings/fetch_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:start_page/main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Fetching name and email from the firebase

class FetchedNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserData.fetchUserData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            String? name = UserData.name;
            if (name != null) {
              return Text('$name');
            } else {
              return const Text('Reflective Respite');
            }
          }
        }
      },
    );
  }
}

class FetchedEmailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserData.fetchUserData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Access email directly from UserData class
            String? email = UserData.email;

            if (email != null) {
              return Text('$email');
            } else {
              return const Text('Email not available');
            }
          }
        }
      },
    );
  }
}

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isDarkMode = false;
  bool receiveNotifications = false;
  late String name;
  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                " ",
                style: TextStyle(
                  fontSize: 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: const Color.fromRGBO(214, 245, 230, 1),
                elevation: 4,
                margin: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          const Icon(Icons.account_circle,
                              size: 50, color: Colors.grey),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FetchedNameWidget(),
                              const SizedBox(height: 10),
                              FetchedEmailWidget(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                color: const Color.fromRGBO(254, 236, 250, 1),
                elevation: 4,
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SettingItem(
                        title: "Edit Profile",
                        icon: Icons.edit,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditAccountScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      SettingItem(
                        title: "Remainder",
                        icon: Icons.calendar_month_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReminderScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      SettingItem(
                        title: "Delete Account",
                        icon: Icons.delete_outline,
                        onTap: () {
                          _deleteAccount(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: const Color.fromRGBO(220, 214, 255, 1),
                elevation: 4,
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SettingItem(
                        title: "Privacy Policy",
                        icon: Ionicons.newspaper_outline,
                        onTap: () {},
                      ),
                      const SizedBox(height: 20),
                      SettingItem(
                        title: "Contact US",
                        icon: Ionicons.mail_open_outline,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContactUsPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      SettingItem(
                        title: "Rate Us",
                        icon: Icons.thumb_up_alt_outlined,
                        onTap: () {
                          _showRatingDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _deleteAccount(BuildContext context) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference docData =
        FirebaseFirestore.instance.collection('users').doc(uid);
    await docData.delete();
    // Delete the user account using Firebase Auth
    await FirebaseAuth.instance.currentUser?.delete();
    // After deleting the account and document, navigate back to the login page
    Navigator.pop(context);
  } catch (e) {
    // Handle errors, such as re-authentication requirements
    print('Error deleting account: $e');
    // Display an error message or handle the error as needed
  }
}

// Rating dialogue

void _showRatingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return RatingDialog(
        initialRating: 5.0,
        submitButtonText: "Submit",
        title: const Text('Rate Us'),
        commentHint: 'Feedback',
        onSubmitted: (response) {
          // Store the rating in Firebase
          _firestore.collection('ratings').add({'rating': response.rating});
          _firestore.collection('ratings').add({'feedback': response.comment});
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountScreen(),
            ),
          );
        },
      );
    },
  );
}

class ContactUsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Us',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ContactUsPage(),
    );
  }
}

// Contact Us page

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.email,
              size: 100,
              color: Color.fromRGBO(213, 248, 251, 1),
            ),
            const SizedBox(height: 10),
            Text(
              'developmhj@gmail.com',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Or give us a call at:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '+1 (123) 456-7890',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Meet the team:',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildTeamMember(
              name: 'Nikitha Peethala',
              email: 'niki@gmail.com',
            ),
            _buildTeamMember(
              name: 'Yashaswini Rao',
              email: 'yashu@gmail.com',
            ),
            _buildTeamMember(
              name: 'Dheeraj',
              email: 'dheeraj@gmail.com',
            ),
            _buildTeamMember(
              name: 'Bhagyasree',
              email: 'bhagya@gmail.com',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember({required String name, required String email}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
