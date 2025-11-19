# SPA Admin - Management System

Aplikasi admin untuk mengelola spa dengan fitur lengkap yang dibuat menggunakan Flutter dan Go Router.

## 🚀 Fitur Utama

### Authentication

- **Splash Screen** - Tampilan pembuka aplikasi
- **Login** - Masuk menggunakan email dan password
- **Register** - Daftar akun admin baru

### Dashboard & Management

- **Home Dashboard** - Overview statistik spa (total user, pesanan harian, pending, completed, revenue)
- **Profile** - Informasi profil admin dan statistik personal
- **Order Management** - Kelola semua pesanan dengan filter status
- **User Management** - Kelola pengguna terdaftar dengan fitur pencarian dan sorting
- **Reward Management** - Kelola sistem poin reward
- **User Ranking** - Peringkat pengguna berdasarkan poin reward

### Detail Screens

- **Order Detail** - Detail pesanan lengkap dengan kemampuan mengubah status (pending → booked → in progress → completed)
- **User Detail** - Detail pengguna dengan riwayat pesanan dan poin reward
- **Account Settings** - Pengaturan akun admin

## 📱 Screenshots

### Authentication Flow

- Splash Screen dengan animasi loading
- Login form dengan validasi
- Register form untuk admin baru

### Dashboard

- Statistics cards (Total Users, Daily Orders, Pending Orders, Completed Orders)
- Revenue tracking (Today & Total Revenue)
- Quick access ke pending orders

### Management Features

- Order management dengan tab filtering (All, Pending, Booked, In Progress, Completed)
- User management dengan pencarian dan sorting
- Reward point management dengan history
- User ranking system

## 🛠️ Teknologi

- **Flutter** - Framework utama
- **Go Router** - Navigation dan routing
- **Material Design 3** - UI/UX Design
- **Mock Data** - Data statis untuk demo

## 📁 Struktur Project

```
lib/
├── main.dart                    # Entry point aplikasi
├── models/                      # Data models
│   ├── user.dart
│   ├── order.dart
│   ├── reward_point.dart
│   └── dashboard_stats.dart
├── screens/                     # UI Screens
│   ├── auth/                   # Authentication screens
│   ├── home/                   # Dashboard & profile screens
│   ├── management/             # Management screens
│   └── details/                # Detail screens
├── widgets/                     # Reusable widgets
│   └── common_widgets.dart
└── utils/                       # Utilities
    ├── routes.dart             # Go Router configuration
    └── constants.dart          # App constants & strings
```

## 🎯 Fitur Detail

### Status Management

- **Pending** → **Booked** → **In Progress** → **Completed**
- **Cancel** option tersedia di setiap status (kecuali completed)

### User Management

- Filter berdasarkan status (Active/Inactive)
- Sorting berdasarkan nama, tanggal join, atau poin reward
- Pencarian berdasarkan nama, email, atau nomor telepon

### Reward System

- Track poin yang diperoleh (earned) dan ditukarkan (redeemed)
- History lengkap transaksi poin
- Manual point addition untuk admin

### Dashboard Analytics

- Real-time statistics
- Revenue tracking
- User growth metrics
- Order completion rates

## ⚙️ Setup & Installation

### Prerequisites

- Flutter SDK (3.9.2 atau lebih tinggi)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation Steps

1. **Clone repository**

   ```bash
   git clone <repository-url>
   cd spa_admin
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run aplikasi**
   ```bash
   flutter run
   ```

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.6.0
  go_router: ^17.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## 🎨 Design System

### Color Palette

- **Primary**: Blue 900 (#0D47A1)
- **Secondary**: Orange, Green, Purple untuk status
- **Background**: Grey 50 (#FAFAFA)

### Typography

- **Headers**: Bold, 18-24px
- **Body**: Regular, 14-16px
- **Captions**: Light, 12px

### UI Components

- **Cards**: Elevation 4, Border radius 12px
- **Buttons**: Border radius 12px, consistent padding
- **Status Chips**: Rounded, color-coded
- **Search Bars**: Filled background, rounded borders

## 📊 Data Models

### User Model

- ID, name, email, phone
- Created date, reward points
- Active status, profile image

### Order Model

- ID, user info, service details
- Booking date, created date
- Status enum, total amount
- Notes, service list

### Reward Point Model

- ID, user info, points
- Reason, created date
- Type (earned/redeemed)

## 🚦 Status Flow

```
Pending → Booked → In Progress → Completed
   ↓         ↓         ↓
Cancelled  Cancelled  Cancelled
```

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🤝 Contributing

1. Fork project ini
2. Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 📞 Contact

- **Developer**: Your Name
- **Email**: your.email@example.com
- **Project**: [https://github.com/yourusername/spa_admin](https://github.com/yourusername/spa_admin)

---

**Note**: Aplikasi ini menggunakan mock data untuk demo. Untuk implementasi production, integrate dengan real API backend.
