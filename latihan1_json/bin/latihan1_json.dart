import 'dart:convert'; // Import library untuk JSON encoding/decoding

void main() {
  // Deklarasi dan inisialisasi Map transkripMahasiswa
  Map<String, dynamic> transkripMahasiswa = {
    "npm": "22082010074",
    "nama": "MUHAMMAD ARIZALDI EKA PRASETYA",
    "mata_kuliah": [
      // List mata kuliah beserta detail
      {
        "no": 1,
        "nama": "Pancasila",
        "sks": 2,
        "nilai": "A",
        "semester": "01",
        "kredit": 4,
        "nxk": 8
      },
      {
        "no": 2,
        "nama": "PENGANTAR SISTEM INFORMASI",
        "sks": 3,
        "nilai": "A",
        "semester": "01",
        "kredit": 4,
        "nxk": 12
      },
      {
        "no": 3,
        "nama": "LOGIKA DAN ALGORITMA",
        "sks": 3,
        "nilai": "B",
        "semester": "01",
        "kredit": 3,
        "nxk": 6
      },
      {
        "no": 4,
        "nama": "Matematika Komputasi",
        "sks": 3,
        "nilai": "B",
        "semester": "01",
        "kredit": 3,
        "nxk": 6
      },
      {
        "no": 5,
        "nama": "BASIS DATA",
        "sks": 3,
        "nilai": "A",
        "semester": "02",
        "kredit": 4,
        "nxk": 12
      },
      {
        "no": 6,
        "nama": "Kewarganegaraan",
        "sks": 2,
        "nilai": "A",
        "semester": "02",
        "kredit": 4,
        "nxk": 8
      },
      {
        "no": 7,
        "nama": "Analisis Proses Bisnis",
        "sks": 3,
        "nilai": "A",
        "semester": "02",
        "kredit": 4,
        "nxk": 12
      },
    ]
  };

  // Hitung IPK
  num totalNxk = 0; // Inisialisasi totalNxk untuk menghitung jumlah nxk
  num totalSks = 0; // Inisialisasi totalSks untuk menghitung total sks

  // Loop melalui setiap mata kuliah
  for (var matkul in transkripMahasiswa['mata_kuliah']) {
    totalNxk += matkul['nxk']; // Tambahkan nilai nxk ke totalNxk
    totalSks += matkul['sks']; // Tambahkan sks ke totalSks
  }

  double ipk =
      totalNxk / totalSks; // Hitung IPK dengan rata-rata nilai nxk per sks

  String jsonTranskrip = jsonEncode(
      transkripMahasiswa); // Konversi transkripMahasiswa menjadi JSON string

  // Print data transkrip mahasiswa dan IPK
  print("Transkrip Mahasiswa UPN Veteran Jawa Timur"); // Cetak judul transkrip
  print("------------------------------------------"); // Cetak pemisah
  print("NPM: ${transkripMahasiswa['npm']}"); // Cetak NPM mahasiswa
  print("Nama: ${transkripMahasiswa['nama']}"); // Cetak nama mahasiswa
  print("IPK: ${ipk.toStringAsFixed(3)}"); // Cetak IPK dengan 3 angka desimal
}
