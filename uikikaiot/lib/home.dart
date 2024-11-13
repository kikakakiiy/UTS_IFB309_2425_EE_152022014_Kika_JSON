import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dbcuaca.dart'; // Mengimpor file untuk mengambil data cuaca

class CuacaHomePage extends StatefulWidget {
  @override
  _CuacaHomePageState createState() => _CuacaHomePageState();
}

class _CuacaHomePageState extends State<CuacaHomePage> {
  Map<String, dynamic>? jsonData; // Menyimpan data JSON yang diterima dari API
  bool isLoading =
      true; // Menandakan apakah data sedang diambil (untuk loading state)

  @override
  void initState() {
    super.initState();
    fetchData(); // Memanggil fungsi untuk mengambil data ketika halaman pertama kali dibuat
  }

  // Fungsi untuk mengambil data dari API
  Future<void> fetchData() async {
    try {
      final data = await CuacaData
          .getData(); // Mengambil data dari API melalui CuacaData
      setState(() {
        jsonData =
            data; // Menyimpan data yang diterima dari API ke dalam jsonData
        isLoading =
            false; // Mengubah status isLoading menjadi false setelah data berhasil diambil
      });
    } catch (e) {
      // Jika terjadi error saat mengambil data
      setState(() {
        isLoading =
            false; // Mengubah status isLoading menjadi false meskipun terjadi error
      });
      print("Error fetching data: $e"); // Menampilkan pesan error di console
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 54, 24, 65), // Warna latar belakang
      appBar: AppBar(
        title: Text("Data Cuaca Kika"), // Judul pada AppBar
        backgroundColor:
            const Color.fromARGB(255, 248, 248, 248), // Warna AppBar
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Menampilkan indikator loading jika data sedang diambil
          : jsonData == null
              ? Center(
                  child: Text("Failed to load data",
                      style: TextStyle(
                          color: Colors
                              .white))) // Menampilkan pesan jika data gagal diambil
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      _buildStatisticCards(), // Menampilkan kartu statistik cuaca
                      SizedBox(height: 20),
                      _buildMaxHumidityRecords(), // Menampilkan data kelembaban maksimum
                      SizedBox(height: 20),
                      _buildMonthYearSection(), // Menampilkan data bulanan maksimum
                    ],
                  ),
                ),
    );
  }

  // Fungsi untuk membangun tampilan kartu statistik cuaca
  Widget _buildStatisticCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard(
            "Max Suhu",
            jsonData?['suhumax'], // Mengambil nilai suhu maksimum dari JSON
            Color.fromARGB(255, 248, 222, 222),
            FontAwesomeIcons.thermometerFull),
        _buildStatCard(
            "Min Suhu",
            jsonData?['suhumin'], // Mengambil nilai suhu minimum dari JSON
            const Color.fromARGB(255, 216, 231, 255),
            FontAwesomeIcons.thermometerEmpty),
        _buildStatCard(
            "Rata-Rata Suhu",
            jsonData?['suhurata'], // Mengambil nilai rata-rata suhu dari JSON
            Color.fromARGB(255, 250, 255, 235),
            FontAwesomeIcons.chartLine),
      ],
    );
  }

  // Fungsi untuk membangun tampilan kartu statistik dengan parameter dinamis
  Widget _buildStatCard(
      String title, dynamic value, Color color, IconData icon) {
    bool isBlackText = title == "Min Suhu" ||
        title ==
            "Rata-Rata Suhu"; // Mengatur warna teks sesuai dengan judul kartu

    return Expanded(
      child: Card(
        color: color, // Mengatur warna background kartu
        shape: CircleBorder(), // Bentuk kartu menjadi bulat
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                color: isBlackText
                    ? Colors.black
                    : const Color.fromARGB(255, 52, 47, 47),
                size: 30,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: isBlackText
                      ? Colors.black
                      : const Color.fromARGB(
                          255, 13, 13, 13), // Mengatur warna teks
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value.toString(), // Menampilkan nilai dari data JSON
                style: TextStyle(
                  color: isBlackText
                      ? Colors.black
                      : const Color.fromARGB(255, 38, 36, 36),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan daftar kelembaban maksimum dan suhu maksimum
  Widget _buildMaxHumidityRecords() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Max Temperature & Humidity",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: jsonData?['nilai_suhu_max_humid_max']?.length ??
              0, // Mengambil jumlah data suhu dan kelembaban dari JSON
          itemBuilder: (context, index) {
            var data = jsonData?['nilai_suhu_max_humid_max']
                [index]; // Mengambil data per item
            return Card(
              color: const Color.fromARGB(255, 238, 232, 232),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.temperatureHigh,
                  color: Colors.redAccent, // Ikon suhu
                ),
                title: Text(
                  "ID: ${data['idx']}\nTemp: ${data['suhu']}°C, Humid: ${data['humid']}%", // Menampilkan suhu dan kelembaban dari JSON
                  style: TextStyle(
                    color: const Color.fromARGB(255, 24, 24, 24),
                  ),
                ),
                subtitle: Text(
                  "Kecerahan: ${data['kecerahan']} lx\nTimestamp: ${data['timestamp']}", // Menampilkan kecerahan dan timestamp
                  style: TextStyle(color: const Color.fromARGB(255, 4, 4, 4)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Fungsi untuk menampilkan data bulanan maksimal
  Widget _buildMonthYearSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Month-Year Max",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        Card(
          color: Color.fromARGB(255, 226, 211, 255), // Warna kartu khusus
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              headingRowHeight: 40,
              dataRowHeight: 40,
              headingRowColor:
                  MaterialStateProperty.all(Color.fromARGB(255, 49, 31, 57)),
              border: TableBorder.all(
                  color: Color.fromARGB(255, 8, 9, 9), width: 1.5),
              columns: [
                DataColumn(
                  label: Center(
                    child: Text(
                      "Month-Year Max", // Judul kolom tabel
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
              rows: jsonData?['month_year_max']?.take(2).map<DataRow>((data) {
                    // Mengambil maksimal dua data bulanan dari JSON
                    return DataRow(
                      cells: [
                        DataCell(
                          Center(
                            child: Text(
                              data[
                                  'month_year'], // Menampilkan data bulan-tahun
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList() ??
                  [],
            ),
          ),
        ),
      ],
    );
  }
}
