import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  late TimeOfDay reminderTime; // The selected reminder time
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin; // Plugin for local notifications

  @override
  void initState() {
    super.initState();
    // Set default reminder time to 8:00 PM
    reminderTime = const TimeOfDay(hour: 20, minute: 0);
    initializeFlutterLocalNotificationsPlugin(); // Initialize local notifications plugin
  }

  Future<void> initializeFlutterLocalNotificationsPlugin() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // Set Android initialization settings for notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Function to choose reminder time
  Future<void> chooseReminderTime(BuildContext context, String locale) async {
    final TimeOfDay? value = await showTimePicker(
      context: context,
      initialTime: reminderTime,
      builder: (BuildContext context, Widget? child) {
        return _buildThemeReminderTime(child!); // Apply custom theme to time picker
      },
    );

    if (value != null) {
      setState(() {
        reminderTime = value; // Update selected reminder time
      });
      await scheduleDailyNotification(); // Schedule daily notification with the new time
    }
  }

  // Function to schedule daily notification
  Future<void> scheduleDailyNotification() async {
    final TimeOfDay now = TimeOfDay.now();
    final DateTime currentTime =
        DateTime.now().subtract(Duration(hours: now.hour, minutes: now.minute));
    final DateTime selectedTime = currentTime.add(
      Duration(hours: reminderTime.hour, minutes: reminderTime.minute),
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'daily_notification', // id
      'Daily Notification', // title
      importance: Importance.max,
      priority: Priority.high,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // id
      'Daily Reminder', // title
      'It\'s time for your daily reminder!', // body
      _nextInstanceOfSelectedTime(selectedTime), // Schedule notification
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Calculate the next instance of selected time for notification
  tz.TZDateTime _nextInstanceOfSelectedTime(DateTime selectedTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, selectedTime.hour, selectedTime.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  // Build custom theme for time picker
  Theme _buildThemeReminderTime(Widget child) {
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          surface: Colors.white, 
          primary: Color.fromRGBO(240, 220, 255, 0.54), 
          // change the text color
          onSurface: Colors.black,
        ),
      
        buttonTheme: const ButtonThemeData(
          colorScheme: ColorScheme.light(
            primary: Color.fromRGBO(199, 236, 239, 1),
          ),
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Daily Reminder Time: ${reminderTime.hour}:${reminderTime.minute}',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => chooseReminderTime(
                  context, 'en_US'), // Button to choose reminder time
              child: const Text('Choose Reminder Time'),
            ),
          ],
        ),
      ),
    );
  }
}
