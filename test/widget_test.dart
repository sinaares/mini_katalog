import 'package:flutter_test/flutter_test.dart';

// Proje adın mini_katalog_pro değilse aşağıdaki importlarda sadece
// "mini_katalog_pro" kısmını kendi proje adınla değiştir.
import 'package:mini_katalog/app/app.dart';
import 'package:mini_katalog/state/app_state.dart';

void main() {
  testWidgets('Uygulama açılıyor mu', (WidgetTester tester) async {
    // Uygulamayı başlat
    await tester.pumpWidget(MiniKatalogApp(state: AppState()));

    // Splash ekranındaki yazıyı bekliyoruz
    expect(find.text('Mini Katalog Pro'), findsOneWidget);

    // Splash 2 saniye sonra Home'a geçiyordu; süreyi ileri sar
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Home açıldığında en az bir bottom nav etiketi görünür olmalı
    // (HomeShell'de Katalog / Favoriler / Sepet vardı)
    expect(find.text('Katalog'), findsOneWidget);
  });
}
