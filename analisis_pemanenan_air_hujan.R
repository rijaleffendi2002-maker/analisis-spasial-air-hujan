# =============================================================================
# analisis_pemanenan_air_hujan.R
# -----------------------------------------------------------------------------
# Analisis Spasial Potensi Pemanenan Air Hujan (Rainwater Harvesting)
# Mata Kuliah: Metodologi Penelitian Ilmiah
# Topik     : Reproducible Research (Tugas Mandiri)
# Library   : tmap (>= 4.2), sf, dplyr, cols4all
#
# Tujuan:
#   Menghitung dan memetakan potensi volume air hujan yang dapat dipanen 
#   di wilayah Asia Tenggara berdasarkan luas area, estimasi curah hujan, 
#   dan koefisien limpasan (runoff coefficient).
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Setup Lingkungan & Paket
# -----------------------------------------------------------------------------
paket_dibutuhkan <- c("tmap", "sf", "dplyr", "cols4all")

for (p in paket_dibutuhkan) {
  if (!requireNamespace(p, quietly = TRUE)) {
    install.packages(p, repos = "https://cloud.r-project.org")
  }
}

library(tmap)
library(sf)
library(dplyr)

# Set seed untuk reproducibility (pasti deterministik)
set.seed(2026)

# Buat folder output jika belum ada
dir_output <- "output"
if (!dir.exists(dir_output)) {
  dir.create(dir_output)
}

# -----------------------------------------------------------------------------
# 2. Memuat Data Spasial & Analisis Hidrologi
# -----------------------------------------------------------------------------
# Memanggil data bawaan World yang stabil di tmap
data("World", package = "tmap")

# Filter khusus untuk negara-negara di Asia Tenggara
asean_countries <- c("Indonesia", "Malaysia", "Philippines", "Thailand", 
                     "Vietnam", "Cambodia", "Laos", "Myanmar", "Brunei", "Timor-Leste")

wilayah_analisis <- World |> 
  filter(name %in% asean_countries) |>
  mutate(
    Negara = name,
    Luas_km2 = as.numeric(st_area(geometry)) / 1e6,
    Koef_Runoff = 0.75, # Asumsi rata-rata wilayah urban/tangkapan
    # Estimasi curah hujan tahunan rata-rata (dalam meter) per negara
    Curah_Hujan_m = c(2.7, 2.0, 2.8, 1.6, 1.8, 1.4, 1.7, 2.1, 2.5, 1.3), 
    # Rumus: V = C * A * CH (m3/tahun)
    Potensi_Panen_m3 = Koef_Runoff * (Luas_km2 * 1e6) * Curah_Hujan_m
  )

# Tampilkan tabel hasil kalkulasi di console R
cat("\n=== HASIL ANALISIS POTENSI AIR HUJAN TAHUNAN ===\n")
print(wilayah_analisis |> 
        st_drop_geometry() |> 
        select(Negara, Luas_km2, Curah_Hujan_m, Potensi_Panen_m3) |>
        arrange(desc(Potensi_Panen_m3)))

# -----------------------------------------------------------------------------
# 3. Visualisasi Spasial Menggunakan Sintaks tmap v4
# -----------------------------------------------------------------------------
peta_potensi <- tm_shape(wilayah_analisis) +
  tm_polygons(
    fill       = "Potensi_Panen_m3",
    fill.scale = tm_scale_intervals(
      style  = "jenks",
      n      = 4,
      values = "brewer.blues"
    ),
    fill.legend = tm_legend(
      title       = "Potensi Air Terpanen (m3/tahun)",
      orientation = "portrait"
    ),
    col      = "grey20",
    lwd      = 0.5
  ) +
  tm_text("Negara", size = 0.6, col = "black") +
  tm_title("Potensi Pemanenan Air Hujan (Rainwater Harvesting) di Asia Tenggara",
           position = tm_pos_in("left", "top")) +
  tm_compass(position = c("right", "top"), size = 1.5) +
  tm_scalebar(position = c("left", "bottom"), text.size = 0.5) +
  tm_credits("Analisis Hidrologi Spasial Mandiri | 2026", position = c("right", "bottom"), size = 0.5) +
  tm_layout(frame = TRUE, bg.color = "#f4f7f6")

# Simpan Peta ke format PNG
tmap_save(
  tm       = peta_potensi,
  filename = file.path(dir_output, "peta_potensi_air_hujan.png"),
  width    = 9, height = 6, dpi = 200
)

# -----------------------------------------------------------------------------
# 4. Rekam Lingkungan Komputasi (Session Info)
# -----------------------------------------------------------------------------
sink(file.path(dir_output, "sessionInfo.txt"))
cat("=== sessionInfo() Tugas Mandiri (Manajemen Air) ===\n")
cat("Tanggal eksekusi:", format(Sys.time()), "\n\n")
print(sessionInfo())
sink()

cat("\n[SUKSES] Peta baru dan sessionInfo.txt telah disimpan di folder 'output/'\n")
# =============================================================================