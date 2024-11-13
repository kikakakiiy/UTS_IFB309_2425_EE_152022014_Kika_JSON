<?php
// Mendefinisikan nama pengguna (user) untuk mengakses database
$user = "root";

// Mendefinisikan kata sandi (password) untuk mengakses database (kosong untuk localhost)
$pass = "";

// Mendefinisikan nama database yang akan dihubungkan
$db = "tb_cuaca";

// Mendefinisikan host server database
$host = "localhost";

// Membuat koneksi ke database menggunakan informasi yang telah didefinisikan
$koneksi = mysqli_connect($host, $user, $pass, $db);

// Mengecek apakah koneksi berhasil dibuat
if (!$koneksi) {
    // Jika koneksi gagal, tampilkan pesan error dan hentikan proses
    die("Database connection failed: " . mysqli_connect_error());
}
?>
