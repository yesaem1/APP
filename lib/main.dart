import 'package:kulkas_apps/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kulkas_apps/navbar.dart';
import 'package:kulkas_apps/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService.instance.initialize(); // Inisialisasi layanan notifikasi
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey:
          NotificationService.navigatorKey, // Menambahkan navigatorKey
      debugShowCheckedModeBanner: false,

      home: navbar(), // Panggil navbar, bukan HomeScreen
    );
  }
}
