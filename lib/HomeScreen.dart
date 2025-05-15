import 'package:flutter/material.dart';
import 'package:kulkas_apps/componen/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  // Mengambil data dari Firestore secara real-time
  Stream<QuerySnapshot> getFoods() {
    return FirebaseFirestore.instance.collection('makanan').snapshots();
  }

  // Fungsi untuk menghapus makanan dari Firestore
  void _removeFood(String docId) async {
    await FirebaseFirestore.instance.collection('makanan').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tampilan Header
            Container(
              height: 220,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, // Start from the top
                  end: Alignment.bottomCenter, // End at the bottom
                  colors: [
                    Color(0xFFA2BC99), // Warna hijau cerah terang
                    Color.fromARGB(255, 96, 152, 72), // Warna hijau lebih gelap
                  ],
                  stops: [0.0, 1.0], // 0% at the top, 100% at the bottom
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(26.0, 60.0, 26.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Datang!!",
                      style: GoogleFonts.montserrat(
                        fontSize: 20.0,
                        color: Color(0xFF335E21),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "Ayok lihat apa saja makanan yang ada di kulkasmu",
                      style: GoogleFonts.montserrat(
                        fontSize: 13.0,
                        // color: Color(0xFF335E21),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (query) {
                          setState(() {
                            searchQuery = query.toLowerCase();
                          });
                        },
                        autocorrect: false,
                        showCursor: true,
                        cursorColor: Color(0xFF000957),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: InkWell(
                            child: const Icon(Icons.search, size: 18),
                          ),
                          hintText: 'Search',
                          hintStyle: GoogleFonts.montserrat(fontSize: 13.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            // Tampilan kategori
            Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 45.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCategory("Buah"),
                    buildCategory("Sayur"),
                    buildCategory("Daging"),
                    buildCategory("Minuman"),
                    buildCategory("Makanan Siap Saji"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun tampilan kategori
  Padding buildCategory(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: GoogleFonts.montserrat(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5.0),
          StreamBuilder<QuerySnapshot>(
            stream: getFoods(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
              return Container(
                child: Column(
                  children:
                      docs
                          .where((doc) {
                            var data = doc.data() as Map<String, dynamic>;
                            // Filter berdasarkan kategori dan pencarian
                            return data['kategori'] == category &&
                                (data['nama_makanan'].toLowerCase().contains(
                                  searchQuery,
                                ));
                          })
                          .map((doc) {
                            var data = doc.data() as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Data(
                                gambar:
                                    'assets/img/${data['nama_makanan'].replaceAll(" ", "_").toLowerCase()}.jpg',
                                judul: data['nama_makanan'],
                                tgl: data['tanggal_masuk'],
                                tgl2: data['estimasi_simpan'],
                                onChecked: () {
                                  // Menghapus item dari Firebase ketika checkbox diklik
                                  _removeFood(doc.id); // Menggunakan doc.id
                                },
                              ),
                            );
                          })
                          .toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
