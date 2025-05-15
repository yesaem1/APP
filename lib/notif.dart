import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ExpirationNotificationPage extends StatefulWidget {
  @override
  _ExpirationNotificationPageState createState() =>
      _ExpirationNotificationPageState();
}

class _ExpirationNotificationPageState
    extends State<ExpirationNotificationPage> {
  // Fungsi untuk menghitung selisih hari antara tanggal kedaluwarsa dan tanggal saat ini
  int getDaysDifference(DateTime expirationDate) {
    DateTime today = DateTime.now();
    return expirationDate.difference(today).inDays;
  }

  // Fungsi untuk mendapatkan data dari Firestore
  Stream<QuerySnapshot> getFoodNotifications() {
    return FirebaseFirestore.instance.collection('makanan').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi Makanan Basi'),
        backgroundColor: Color(0xFF000957),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getFoodNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

          // Filter makanan yang hampir basi (H-3, H-1, HariH)
          List<Widget> notificationList = [];

          for (var doc in docs) {
            var data = doc.data() as Map<String, dynamic>;

            // Ambil data tanggal notifikasi
            DateTime notifikasiH3 = DateTime.parse(data['notifikasi_h3']);
            DateTime notifikasiH1 = DateTime.parse(data['notifikasi_h1']);
            DateTime notifikasiHariH = DateTime.parse(
              data['notifikasi_hari_h'],
            );

            int daysDifferenceH3 = getDaysDifference(notifikasiH3);
            int daysDifferenceH1 = getDaysDifference(notifikasiH1);
            int daysDifferenceHariH = getDaysDifference(notifikasiHariH);

            // Menambahkan notifikasi berdasarkan kondisi H-3, H-1, HariH
            if (daysDifferenceH3 == 0) {
              notificationList.add(
                createNotificationTile(
                  data['nama_makanan'],
                  'H-3: Makanan ini akan basi dalam 3 hari!',
                  Colors.orange,
                ),
              );
            } else if (daysDifferenceH1 == 0) {
              notificationList.add(
                createNotificationTile(
                  data['nama_makanan'],
                  'H-1: Makanan ini akan basi dalam 1 hari!',
                  Colors.red,
                ),
              );
            } else if (daysDifferenceHariH == 0) {
              notificationList.add(
                createNotificationTile(
                  data['nama_makanan'],
                  'Hari H: Makanan ini sudah basi!',
                  Colors.red,
                ),
              );
            }
          }

          // Menampilkan notifikasi yang sudah difilter
          return ListView(
            children:
                notificationList.isNotEmpty
                    ? notificationList
                    : [
                      Center(
                        child: Text('Tidak ada makanan yang hampir basi.'),
                      ),
                    ],
          );
        },
      ),
    );
  }

  // Widget untuk membuat tampilan notifikasi makanan
  Widget createNotificationTile(String foodName, String message, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.all(16.0),
      tileColor: color.withOpacity(0.1),
      title: Text(
        foodName,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(message),
      trailing: Icon(Icons.notifications, color: color),
    );
  }
}
