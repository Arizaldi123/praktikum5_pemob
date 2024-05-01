import 'package:flutter/material.dart'; // Mengimport library Flutter untuk membuat UI
import 'package:http/http.dart'
    as http; // Mengimport library http untuk melakukan HTTP requests
import 'dart:convert'; // Mengimport library untuk JSON encoding/decoding
import 'package:url_launcher/url_launcher.dart'; // Mengimport library untuk membuka URL eksternal

void main() {
  runApp(MyApp()); // Memulai aplikasi Flutter dengan widget MyApp
}

// Class untuk merepresentasikan informasi universitas
class University {
  final String name;
  final List<String> webPages;

  University(
      {required this.name,
      required this.webPages}); // Constructor untuk inisialisasi objek University

  // Factory method untuk mengonversi data JSON menjadi objek University
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'], // Mengambil nilai 'name' dari JSON response
      webPages: List<String>.from(
          json['web_pages']), // Mengambil nilai 'web_pages' dari JSON response
    );
  }
}

// Stateful widget untuk menampilkan daftar universitas
class UniversityList extends StatefulWidget {
  @override
  _UniversityListState createState() => _UniversityListState();
}

class _UniversityListState extends State<UniversityList> {
  late Future<List<University>>
      futureUniversities; // Future untuk menampung daftar universitas

  String apiUrl =
      "http://universities.hipolabs.com/search?country=Indonesia"; // URL API untuk mendapatkan daftar universitas Indonesia

  // Method untuk mengambil daftar universitas dari API
  Future<List<University>> fetchUniversities() async {
    final response = await http
        .get(Uri.parse(apiUrl)); // Mengirim HTTP GET request ke URL API

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(
          response.body); // Decode JSON response menjadi List<dynamic>
      List<University> universities = data
          .map((universityJson) => University.fromJson(
              universityJson)) // Mapping data JSON ke objek University
          .toList();

      return universities; // Mengembalikan daftar universitas
    } else {
      throw Exception(
          'Failed to load universities'); // Jika gagal, lempar Exception
    }
  }

  // Method initState() dipanggil saat widget pertama kali dibuat (inisialisasi).
  @override
  void initState() {
    super.initState();
    futureUniversities =
        fetchUniversities(); // Memanggil fetchUniversities() saat initState dipanggil
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University List', // Judul aplikasi
      theme: ThemeData(
        primarySwatch: Colors.blue, // Theme warna utama aplikasi
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('List Universitas',
              style: TextStyle(color: Colors.white)), // Judul AppBar
          backgroundColor: Colors.blue, // Warna latar belakang AppBar
        ),
        body: Center(
          child: FutureBuilder<List<University>>(
            future:
                futureUniversities, // Menggunakan futureUniversities sebagai sumber data
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika snapshot memiliki data (data universitas tersedia),
                return ListView.builder(
                  itemCount: snapshot.data!
                      .length, // Menentukan jumlah item dalam ListView berdasarkan panjang data
                  itemBuilder: (context, index) {
                    University university = snapshot.data![
                        index]; // Memperoleh objek University dari data pada indeks tertentu
                    return Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(), // Menambahkan border pada container
                        color: Colors
                            .white, // Warna latar belakang di dalam border
                      ),
                      padding: EdgeInsets.all(
                          8), // Memberikan padding pada container
                      child: ListTile(
                        title: Text(
                            university.name), // Menampilkan nama universitas
                        subtitle: Text(
                          university.webPages
                              .first, // Menampilkan URL halaman web universitas
                          style: TextStyle(
                              color: Colors.blue), // Mengatur warna teks URL
                        ),
                        onTap: () {
                          launch(university
                              .webPages.first); // Membuka URL saat item di-tap
                        },
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text(
                    '${snapshot.error}'); // Jika terjadi error, tampilkan pesan error
              }
              // Default: tampilkan indikator loading
              return CircularProgressIndicator(); // Tampilkan indikator loading saat menunggu data
            },
          ),
        ),
      ),
    );
  }
}

// StatelessWidget yang merupakan entry point utama aplikasi
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University App', // Judul aplikasi
      theme: ThemeData(
        primarySwatch: Colors.blue, // Theme warna utama aplikasi
      ),
      home:
          UniversityList(), // Menggunakan UniversityList sebagai halaman utama (home)
    );
  }
}
