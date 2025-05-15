import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Data extends StatelessWidget {
  const Data({
    super.key,
    this.gambar,
    this.judul,
    this.tgl,
    this.tgl2,
    this.onChecked,
  });

  final String? gambar;
  final String? judul;
  final String? tgl;
  final String? tgl2;
  final Function? onChecked;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80,
      // width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      //   color: const Color.fromARGB(
      //     240,
      //     187,
      //     232,
      //     170,
      //   ), // #CAFFB6 (background color)
      //   borderRadius: const BorderRadius.all(Radius.circular(20)),
      // ),
      child: Row(
        children: [
          const SizedBox(width: 0.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child:
                gambar != null
                    ? Image.asset(
                      gambar!,
                      width: 72.0,
                      height: 72.0,
                      fit: BoxFit.fill,
                    )
                    : Container(width: 72.0, height: 72.0, color: Colors.grey),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 8.0, right: 0.0),
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  163,
                  122,
                  199,
                  90,
                ), // #CAFFB6 (background color)
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          judul ?? 'Nama Makanan Tidak Tersedia',
                          style: GoogleFonts.montserrat(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF335E21),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Tanggal Masuk: ",
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF335E21),
                              ),
                            ),
                            Text(
                              tgl ?? 'Tanggal Tidak Tersedia',
                              style: GoogleFonts.montserrat(
                                fontSize: 11.5,
                                color: Color(0xFF335E21),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            Image.asset(
                              "assets/img/schedule.png",
                              width: 12.5,
                              height: 12.5,
                              fit: BoxFit.fill,
                              color: Color(0xFF335E21),
                            ),
                            const SizedBox(width: 5.0),
                            Row(
                              children: [
                                Text(
                                  "Tanggal Basi: ",
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    color: const Color.fromARGB(
                                      255,
                                      226,
                                      23,
                                      8,
                                    ),
                                  ),
                                ),
                                Text(
                                  tgl2 ?? 'Tanggal Tidak Tersedia',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                      255,
                                      220,
                                      15,
                                      0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 30.0),
                    GestureDetector(
                      onTap: () {
                        onChecked?.call();
                      },
                      child: Icon(
                        Icons.delete, // Ikon tong sampah
                        size: 35.0, // Sesuaikan ukuran ikon
                        color: Colors.white, // Sesuaikan warna ikon
                      ),

                      // child: Image.asset(
                      //   "assets/img/check.png",
                      //   height: 35.0,
                      //   fit: BoxFit.fill,
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // const SizedBox(width: 10.0),
        ],
      ),
    );
  }
}
