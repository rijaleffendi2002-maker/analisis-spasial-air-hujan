# Analisis Spasial Potensi Pemanenan Air Hujan (Rainwater Harvesting) di Asia Tenggara

Proyek ini disusun untuk memenuhi tugas mandiri mata kuliah **Metodologi Penelitian Ilmiah** pada topik *Reproducible Research*. Analisis ini berfokus pada perhitungan potensi volume air hujan makro yang dapat dipanen di kawasan Asia Tenggara menggunakan integrasi data spasial di R.

## 1. Tujuan Analisis
* Menghitung potensi volume pemanenan air hujan tahunan menggunakan parameter luas wilayah negara, estimasi variasi curah hujan tropis, dan koefisien limpasan kawasan (*runoff coefficient* $\approx 0.75$).
* Menyajikan visualisasi peta wilayah (*Choropleth map*) menggunakan paket `tmap` versi 4 terbaru.
* Menjamin sifat keterulangan (*reproducibility*) riset dengan menggunakan dataset yang terintegrasi dan mencatat dokumen *environment* secara otomatis.

## 2. Struktur Folder Proyek
```text
├── analisis_pemanenan_air_hujan.R  # Skrip pemrograman utama (R)
├── README.md                       # Dokumentasi penjelasan proyek
└── output/                         # Folder luaran analisis (otomatis terbuat)
    ├── peta_potensi_air_hujan.png  # Visualisasi gambar peta hasil analisis
    └── sessionInfo.txt             # Spesifikasi teknis versi paket R yang digunakan
