import 'dart:convert'; // Mengimpor library dart:convert untuk melakukan encoding dan decoding JSON
import 'package:http/http.dart'
    as http; // Mengimpor library http untuk melakukan request HTTP

// Mendefinisikan kelas CuacaData untuk mengelola pengambilan data cuaca
class CuacaData {
  // untuk mengambil data dari API secara asynchronous
  static Future<Map<String, dynamic>> getData() async {
    // Mendeklarasikan URL API yang akan diambil datanya
    final url = Uri.parse(
        'http://localhost/backendkika/data.php'); // URL backend API dari db

    // Melakukan request GET ke URL tersebut menggunakan metode http.get
    final response = await http.get(url);

    // Mengecek apakah response status code adalah 200 (OK), yang berarti data berhasil diterima
    if (response.statusCode == 200) {
      // Jika status code 200, decode response body yang berupa JSON dan kembalikan dalam bentuk Map
      return json.decode(response.body);
    } else {
      // Jika status code bukan 200, throw exception dengan pesan 'Failed to load data'
      throw Exception('Failed to load data');
    }
  }
}
