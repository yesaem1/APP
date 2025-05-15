import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kulkas_apps/kalender.dart';
import 'package:kulkas_apps/componen/data.dart'; // Impor kalender.dart untuk navigasi

class NotificationService {
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _player = AudioPlayer();

  bool _isAlarmPlaying = false;
  bool _isAlertActive = false;

  // Define a navigator key to handle navigation
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NotificationService._internal();

  void initialize() {
    _initializeNotifications();
    _listenToFirestore();
  }

  void _initializeNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle when the user clicks on the notification
        if (response.payload != null) {
          print("Notification payload: ${response.payload}");
          _navigateToCalendar();
        }
      },
      onDidReceiveBackgroundNotificationResponse:
          NotificationService.onBackgroundNotificationResponse,
    );

    // Android 13+ permission
    if (Platform.isAndroid) {
      final androidImplementation =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  Future<void> _showNotification(
    String title,
    String message, {
    int id = 0,
  }) async {
    print("Notifikasi muncul: $title - $message"); // Menambahkan log
    const androidDetails = AndroidNotificationDetails(
      'kulkas_notification_channel',
      'Kulkas Notifikasi',
      importance: Importance.max,
      priority: Priority.high,
      autoCancel: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      message,
      platformDetails,
      payload: 'calendar', // We use a payload to indicate navigation action
    );
  }

  void _navigateToCalendar() {
    // Navigate to the Calendar page when notification is clicked
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => Kalender()),
    );
  }

  // Fungsi untuk mendengarkan data dari Firestore
  void _listenToFirestore() {
    FirebaseFirestore.instance
        .collection('makanan')
        .snapshots()
        .listen(
          (snapshot) {
            for (var doc in snapshot.docs) {
              var data = doc.data() as Map<String, dynamic>;

              // Mengambil data tanggal notifikasi
              DateTime notifikasiH3 = DateTime.parse(data['notifikasi_h3']);
              DateTime notifikasiH1 = DateTime.parse(data['notifikasi_h1']);
              DateTime notifikasiHariH = DateTime.parse(
                data['notifikasi_hari_h'],
              );
              DateTime today = DateTime.now();

              // Cek apakah hari ini adalah H-3, H-1, atau hari H dan kirimkan notifikasi
              if (notifikasiH3.isAtSameMomentAs(today)) {
                _showNotification(
                  "${data['nama_makanan']} anda akan basi dalam 3 hari!",
                  "Segera eksekusi",
                );
              } else if (notifikasiH1.isAtSameMomentAs(today)) {
                _showNotification(
                  "Wah, sepertinya ${data['nama_makanan']} akan basi besok",
                  "Ayok makan sebelum basi",
                );
              } else if (notifikasiHariH.isAtSameMomentAs(today)) {
                _showNotification(
                  "Masa simpan ${data['nama_makanan']} habis!",
                  "Cek dan keluarkan dari kulkas sekarang!",
                );
              }
            }
          },
          onError: (error) {
            print("❌ ERROR Firestore: $error");
          },
        );
  }

  static void onBackgroundNotificationResponse(NotificationResponse response) {
    // Handle response from background notifications
    if (response.payload != null) {
      print("Background notification clicked: ${response.payload}");
      instance._navigateToCalendar();
    }
  }
}
