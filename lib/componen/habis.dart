import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Habis extends StatelessWidget {
  const Habis({
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
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromARGB(
            255,
            96,
            152,
            72,
          ), // Warna border (garis pinggir)
          width: 2.0, // Ketebalan border
        ),
        borderRadius: const BorderRadius.all(Radius.circular(13)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 2.0),
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
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    judul ?? 'Nama Makanan Tidak Tersedia',
                    style: GoogleFonts.montserrat(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Akan rusak hari ini, olah segera!",
                        style: TextStyle(fontSize: 11.0, color: Colors.black),
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
                  color: Color.fromARGB(
                    255,
                    79,
                    113,
                    64,
                  ), // Sesuaikan warna ikon
                ),

                // child: Image.asset(
                //   "assets/img/check.png",
                //   height: 35.0,
                //   fit: BoxFit.fill,
                // ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
