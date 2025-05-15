import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:kulkas_apps/componen/habis.dart';

class Kalender extends StatefulWidget {
  const Kalender({Key? key}) : super(key: key);

  @override
  State<Kalender> createState() => _KalenderState();
}

class _KalenderState extends State<Kalender> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  DateTime selectedDate = DateTime.now(); // Menyimpan tanggal yang dipilih

  // Fungsi untuk mendapatkan data dari Firestore berdasarkan tanggal
  Stream<QuerySnapshot> getFoods(DateTime selectedDate) {
    String formattedDate =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    return FirebaseFirestore.instance
        .collection('makanan')
        .where('estimasi_simpan', isEqualTo: formattedDate)
        .snapshots();
  }

  // Fungsi untuk menghapus makanan dari Firestore
  void _removeFood(String docId) async {
    await FirebaseFirestore.instance.collection('makanan').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar menjadi terang
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reminder",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF335E21),
          ),
        ),
        actions: const [],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // const Divider(
            //   color: Color.fromARGB(255, 104, 104, 104), // Warna garis
            //   thickness: 2, // Ketebalan garis
            //   indent: 1, // Margin kiri
            //   endIndent: 1, // Margin kanan
            // ),
            Padding(
              padding: EdgeInsets.only(left: 1.0, right: 20),
              child: CalendarTimeline(
                showYears: false,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date!; // Update selected date
                  });
                },
                leftMargin: 12,
                monthColor: const Color.fromARGB(179, 0, 0, 0),
                dayColor: Color.fromARGB(255, 96, 152, 72),
                dayNameColor: const Color.fromARGB(255, 255, 255, 255),
                activeDayColor: Colors.white,
                activeBackgroundDayColor: Color.fromARGB(255, 96, 152, 72),
                dotColor: Colors.white,
                selectableDayPredicate: (date) => date.day != 23,
                eventDates: [
                  // Menambahkan beberapa tanggal dengan warna berbeda
                  DateTime.now().add(const Duration(days: 2)),
                  DateTime.now().add(const Duration(days: 3)),
                  DateTime.now().add(const Duration(days: 4)),
                  DateTime.now().subtract(const Duration(days: 4)),
                ],
                locale: 'en',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                top: 10,
                right: 20,
                bottom: 10,
              ), // Menambahkan padding di sekitar teks
              child: Text(
                "Masa simpan makanan berikut akan habis hari ini, segera olah!!",
                style: GoogleFonts.montserrat(
                  fontSize: 15.0, // Ukuran font
                  fontWeight: FontWeight.bold, // Ketebalan font
                  color: Colors.black, // Warna teks
                ),
              ),
            ),
            // Tampilan daftar makanan
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: StreamBuilder<QuerySnapshot>(
                stream: getFoods(
                  selectedDate,
                ), // Ambil data berdasarkan tanggal yang dipilih
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return Center(
                      child: Text('Tidak ada makanan basi pada tanggal ini.'),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var data = docs[index].data() as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Habis(
                          gambar:
                              'assets/img/${data['nama_makanan'].replaceAll(" ", "_").toLowerCase()}.jpg',
                          judul: data['nama_makanan'],
                          onChecked: () {
                            // Menghapus item dari Firebase ketika ikon hapus diklik
                            _removeFood(docs[index].id); // Menggunakan doc.id
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
