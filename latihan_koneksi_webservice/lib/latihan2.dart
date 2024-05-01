import 'package:flutter/material.dart'; // Mengimport library Flutter untuk membuat UI
import 'package:http/http.dart'
    as http; // Mengimport library http untuk melakukan HTTP requests
import 'dart:convert'; // Mengimport library untuk JSON encoding/decoding

void main() {
  runApp(const MyApp()); // Memulai aplikasi Flutter dengan menjalankan MyApp
}

// Class untuk merepresentasikan aktivitas yang diambil dari API
class Activity {
  String aktivitas;
  String jenis;

  // Constructor dengan parameter yang diperlukan untuk inisialisasi objek Activity
  Activity({required this.aktivitas, required this.jenis});

  // Factory method untuk mengkonversi JSON menjadi objek Activity
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas:
          json['activity'], // Mengambil nilai 'activity' dari JSON response
      jenis: json['type'], // Mengambil nilai 'type' dari JSON response
    );
  }
}

// Kelas MyApp merupakan stateful widget yang akan digunakan untuk membuat aplikasi Flutter.
// StatefulWidget digunakan karena aplikasi ini memiliki state yang berubah (futureActivity).
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Mengembalikan instance dari MyAppState sebagai state untuk MyApp
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity>
      futureActivity; // Future untuk menampung hasil pemanggilan API
  String url =
      "https://www.boredapi.com/api/activity"; // URL API untuk mendapatkan aktivitas

  // Method untuk menginisialisasi futureActivity dengan objek Activity kosong
  Future<Activity> init() async {
    return Activity(
        aktivitas: "", jenis: ""); // Mengembalikan objek Activity kosong
  }

  // Method untuk melakukan HTTP GET request ke API
  Future<Activity> fetchData() async {
    final response =
        await http.get(Uri.parse(url)); // Mengirim request HTTP GET ke URL
    if (response.statusCode == 200) {
      // Jika response dari server adalah 200 OK (berhasil),
      // parse response body JSON ke objek Activity
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika response tidak berhasil (bukan 200 OK),
      // lempar exception dengan pesan 'Gagal load'
      throw Exception('Gagal load');
    }
  }

  // Method initState() dipanggil saat widget pertama kali dibuat (inisialisasi).
  @override
  void initState() {
    super.initState();
    futureActivity =
        init(); // Set futureActivity dengan objek Activity kosong pada awal initState
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // untuk mengatur semua child widget yang ada di dalam Column ditempatkan di tengah-tengah layar secara vertikal
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: 20), // Memberi padding 20 di bagian bawah tombol
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      futureActivity =
                          fetchData(); // Memanggil fetchData() saat tombol ditekan
                    });
                  },
                  child: Text("Saya bosan ..."),
                ),
              ),
              // Widget FutureBuilder untuk menampilkan data dari futureActivity
              FutureBuilder<Activity>(
                future: futureActivity,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Jika snapshot memiliki data (API berhasil diambil),
                    // tampilkan aktivitas dan jenisnya
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(snapshot
                              .data!.aktivitas), // Menampilkan aktivitas
                          Text(
                              "Jenis: ${snapshot.data!.jenis}") // Menampilkan jenis aktivitas
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // Jika terjadi error saat fetching data dari API,
                    // tampilkan pesan error
                    return Text('${snapshot.error}');
                  }
                  // Default: tampilkan loading indicator
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
