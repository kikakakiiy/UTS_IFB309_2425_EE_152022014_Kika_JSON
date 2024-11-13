<?php

// Menambahkan header untuk mengizinkan permintaan dari semua origin (untuk akses CORS)
header("Access-Control-Allow-Origin: *");

// Menambahkan header untuk mengizinkan metode GET, POST, dan OPTIONS dalam permintaan HTTP
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

// Menambahkan header untuk mengizinkan pengaturan header Content-Type dalam permintaan HTTP
header("Access-Control-Allow-Headers: Content-Type");

// Menetapkan jenis konten yang akan dikirimkan sebagai response yaitu format JSON
header('Content-Type: application/json');

// Menyertakan file koneksi ke database
include 'koneksi.php';

try {
    // Melakukan query untuk mendapatkan suhu maksimum, minimum, dan rata-rata dari tabel tb_cuaca
    $result = mysqli_query($koneksi, "SELECT MAX(suhu) as suhumax, MIN(suhu) as suhumin, AVG(suhu) as suhurata FROM tb_cuaca");
    $suhuStats = mysqli_fetch_assoc($result);

    // Query untuk mengambil data dengan suhu maksimum dan kelembaban maksimum
    $nilaiMaxQuery = "SELECT id as idx, suhu, humid, lux as kecerahan, ts as timestamp 
                      FROM tb_cuaca 
                      WHERE suhu = {$suhuStats['suhumax']} 
                        AND humid = (SELECT MAX(humid) FROM tb_cuaca)";
    $nilaiMaxResult = mysqli_query($koneksi, $nilaiMaxQuery);
    $nilaiMax = mysqli_fetch_all($nilaiMaxResult, MYSQLI_ASSOC);

    // Query untuk mengambil data bulan-tahun unik yang memiliki catatan suhu maksimum
    // Query untuk mengambil data bulan-tahun unik yang memiliki catatan suhu maksimum
    $monthYearMaxQuery = "SELECT DISTINCT DATE_FORMAT(ts, '%c-%Y') as month_year 
    FROM tb_cuaca 
    WHERE suhu = {$suhuStats['suhumax']} 
    LIMIT 2"; // Menambahkan LIMIT 2 untuk hanya mengambil 2 data
    $monthYearMaxResult = mysqli_query($koneksi, $monthYearMaxQuery);
    $monthYearMax = mysqli_fetch_all($monthYearMaxResult, MYSQLI_ASSOC);


    // Menyiapkan data output akhir yang akan dikirimkan dalam format JSON
    $output = [
        "suhumax" => (int)$suhuStats['suhumax'], // Konversi suhu max menjadi integer
        "suhumin" => (int)$suhuStats['suhumin'], // Konversi suhu min menjadi integer
        "suhurata" => round((float)$suhuStats['suhurata'], 2), // Rata-rata suhu dibulatkan ke 2 desimal
        "nilai_suhu_max_humid_max" => $nilaiMax, // Data suhu max dengan humid max
        "month_year_max" => $monthYearMax // Bulan-tahun unik dengan suhu maksimum
    ];

    // Mengirimkan output dalam format JSON dengan indentasi
    header('Content-Type: application/json');
    echo json_encode($output, JSON_PRETTY_PRINT);

} catch (Exception $e) {
    // Jika terjadi kesalahan, kirim pesan error dalam format JSON
    echo json_encode(["error" => "Query failed: " . $e->getMessage()]);
}

// Menutup koneksi ke database
mysqli_close($koneksi);
?>
