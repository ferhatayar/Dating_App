# SinFlix - Flutter Film Keşif Uygulaması

Clean Architecture ve gelişmiş state management ile geliştirilmiş modern Flutter film keşif ve yönetim uygulaması.

## 📱 Özellikler

### Ana Ekranlar
- **Giriş Sayfası** - E-posta/şifre ile kullanıcı kimlik doğrulaması
- **Kayıt Sayfası** - Doğrulama ile yeni kullanıcı kaydı
- **Ana Sayfa (Keşfet)** - Sonsuz kaydırma ile film keşfi
- **Profil Sayfası** - Kullanıcı profil yönetimi ve favori filmler
- **Sınırlı Teklif Bottom Sheet** - Premium abonelik teklifleri

### Kimlik Doğrulama Sistemi
- ✅ Kullanıcı girişi ve kayıt işlevselliği
- ✅ Flutter Secure Storage ile güvenli token saklama
- ✅ Başarılı girişte otomatik ana sayfa yönlendirmesi
- ✅ Oturum yönetimi ve otomatik çıkış

### Ana Sayfa Özellikleri
- ✅ Sonsuz kaydırma implementasyonu
- ✅ Her sayfada 5 film yükleme
- ✅ Otomatik yükleme göstergeleri
- ✅ Aşağı çekme ile yenileme özelliği
- ✅ Favori filmler için gerçek zamanlı UI güncellemeleri
- ✅ Akıcı film kartı animasyonları

### Profil Yönetimi
- ✅ Kullanıcı bilgilerinin görüntülenmesi
- ✅ Grid layout ile favori filmler listesi
- ✅ Profil fotoğrafı yükleme özelliği
- ✅ Çıkış yapma işlevselliği

### Navigasyon
- ✅ Sorunsuz sayfa geçişleri için Bottom Navigation Bar
- ✅ Ana sayfa state yönetimi ve korunması
- ✅ Declarative navigasyon için GoRouter

## 🏗️ Mimari

### Clean Architecture
```
lib/
├── core/                 # Temel işlevsellik
│   ├── constants/        # Uygulama sabitleri
│   ├── di/              # Dependency injection
│   ├── navigation/      # Navigasyon kurulumu
│   ├── network/         # Network katmanı
│   └── theme/           # Uygulama teması
├── features/            # Özellik modülleri
│   ├── auth/           # Kimlik doğrulama özelliği
│   │   ├── data/       # Data katmanı
│   │   ├── domain/     # Domain katmanı
│   │   └── presentation/ # Presentation katmanı
│   └── movies/         # Filmler özelliği
│       ├── data/       # Data katmanı
│       ├── domain/     # Domain katmanı
│       └── presentation/ # Presentation katmanı
└── shared/             # Paylaşılan bileşenler
    ├── services/       # Paylaşılan servisler
    └── widgets/        # Yeniden kullanılabilir widget'lar
```

### MVVM Deseni
- **Model**: Veri modelleri ve iş mantığı
- **View**: UI bileşenleri ve ekranlar
- **ViewModel**: BLoC state yönetimi

### State Yönetimi
- **BLoC Pattern** öngörülebilir state yönetimi için
- **Equatable** verimli state karşılaştırmaları için
- **Event-driven architecture** temiz ayrım için

## 🎨 UI/UX Tasarım

### Özel Tema
- Film gezintisi için optimize edilmiş koyu tema
- Netflix'ten ilham alan renk şeması
- Tutarlı tipografi ve boşluklar
- Material Design 3 bileşenleri

### Responsive Tasarım
- Farklı ekran boyutları için uyarlanabilir layout'lar
- iOS ve Android için optimize edilmiş
- Akıcı animasyonlar ve geçişler

## 🌐 Uluslararasılaştırma

### Çoklu Dil Desteği
- **Türkçe (TR)** - Birincil dil
- **İngilizce (EN)** - İkincil dil
- Sistem seviyesi çeviriler için Flutter Localizations

## 🔧 Teknik Implementasyon

### Network Katmanı
- HTTP istekleri için **Dio**
- Type-safe API çağrıları için **Retrofit**
- Kod üretimi ile **JSON Serialization**
- Hata yönetimi ve yeniden deneme mekanizmaları

### Veri Kalıcılığı
- Hassas veriler (token'lar) için **Flutter Secure Storage**
- Kullanıcı tercihleri için **SharedPreferences**
- Gelişmiş performans için **Caching**

### Kod Kalitesi
- **Clean Code** prensipleri
- **SOLID** tasarım desenleri
- Test edilebilirlik için **Dependency Injection**
- Uygulama genelinde **Hata Yönetimi**

## 🚀 Bonus Özellikler

### Firebase Entegrasyonu
- **Firebase Core** başlatma
- Çökme raporları için **Firebase Crashlytics**
- Kullanıcı davranışı takibi için **Firebase Analytics**

### Gelişmiş Özellikler
- Debug ve izleme için **Logger Service**
- GoRouter ile **Özel Navigasyon Servisi**
- Gelişmiş kullanıcı deneyimi için **Lottie Animasyonları**
- Animasyonlu logo ile **Splash Screen**
- iOS ve Android için **Özel Uygulama İkonları**

### Performans Optimizasyonları
- Daha hızlı yükleme için **Cached Network Images**
- Film listeleri için **Lazy loading**
- Navigasyon sırasında **State preservation**
- Büyük veri setleri için **Memory management**

## 📦 Temel Bağımlılıklar

```yaml
# State Yönetimi
flutter_bloc: ^8.1.3
equatable: ^2.0.5

# Network
dio: ^5.3.2
retrofit: ^4.0.3
json_annotation: ^4.9.0

# Navigasyon
go_router: ^12.1.1

# UI
cached_network_image: ^3.3.0
image_picker: ^1.0.4
lottie: ^2.7.0

# Depolama
shared_preferences: ^2.2.2
flutter_secure_storage: ^9.0.0

# Firebase
firebase_core: ^2.24.2
firebase_crashlytics: ^3.4.8
firebase_analytics: ^10.7.4

# Localization
flutter_localizations: sdk
intl: ^0.19.0

# Utils
logger: ^2.0.2
```

## 🛠️ Geliştirme Kurulumu

### Ön Koşullar
- Flutter SDK (3.7.2+)
- Dart SDK (3.0.0+)
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Kurulum
1. Repository'yi klonlayın
```bash
git clone <repository-url>
cd dating_project
```

2. Bağımlılıkları yükleyin
```bash
flutter pub get
```

3. Kod üretimi yapın
```bash
flutter packages pub run build_runner build
```

4. Uygulamayı çalıştırın
```bash
flutter run
```

## 🧪 Test

Uygulama kapsamlı test kurulumu içerir:
- İş mantığı için unit testler
- UI bileşenleri için widget testleri
- Kullanıcı akışları için entegrasyon testleri

## 📊 Değerlendirme Kriterleri

### ✅ Tamamlanan Özellikler
- **Kod kalitesi ve organizasyon** - Clean Architecture, SOLID prensipleri
- **UI/UX tasarımına uygunluk** - Modern, responsive tasarım
- **Performans optimizasyonu** - Lazy loading, caching, memory management
- **Best practice kullanımı** - BLoC pattern, dependency injection
- **Bonus özelliklerin implementasyonu** - Firebase, Lottie, Localization

### 🎯 Teknik Başarılar
- Clean Architecture ile modüler yapı
- MVVM pattern ile temiz kod organizasyonu
- BLoC ile öngörülebilir state yönetimi
- Güvenli token yönetimi
- Çoklu dil desteği
- Firebase entegrasyonu
- Lottie animasyonları

## 📄 Lisans

Bu proje yalnızca değerlendirme amaçları için oluşturulmuştur ve ticari kullanım için tasarlanmamıştır.

## 👨‍💻 Geliştirici

Flutter ve modern geliştirme pratikleri kullanılarak ❤️ ile geliştirilmiştir.

---

**Not**: Bu, Flutter geliştirme becerilerini, Clean Architecture implementasyonunu ve modern mobil uygulama geliştirme pratiklerini gösteren teknik bir değerlendirme projesidir.