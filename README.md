# Laundry App

Aplikasi Laundry berbasis mobile yang dikembangkan menggunakan **Flutter** untuk frontend dan **Express.js** untuk backend, dengan **MySQL** sebagai database.

## 🚀 Fitur Utama

* Autentikasi pengguna menggunakan **JWT (JSON Web Token)**
* Manajemen data pelanggan
* Manajemen order laundry
* CRUD layanan laundry
* Integrasi API antara Flutter dan backend Express.js

## 🛠️ Teknologi yang Digunakan

* **Frontend:** Flutter
* **Backend:** Express.js (Node.js)
* **Database:** MySQL
* **Authentication:** JWT (JSON Web Token)

## 📂 Struktur Project

* `frontend/` → Aplikasi Flutter
* `backend/` → REST API Express.js

## 🔐 Authentication

Sistem menggunakan **JWT** untuk:

* Login & Register
* Proteksi endpoint API
* Manajemen sesi pengguna secara aman

## ⚙️ Instalasi & Menjalankan Project

### 1. Clone Repository

```bash
git clone https://github.com/anggaprsada/laundry.git
cd laundry
```

### 2. Setup Backend

```bash
cd backend
npm install
npm start
```

### 3. Setup Frontend

```bash
cd frontend
flutter pub get
flutter run
```

## 📌 Catatan

Pastikan:

* MySQL sudah berjalan
* Konfigurasi database sudah sesuai di backend
* Port backend sesuai dengan konfigurasi di Flutter

## 👨‍💻 Developer

Dikembangkan oleh Angga Persada
