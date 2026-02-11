import 'package:flutter/material.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import 'routes.dart';
import '../screens/splash_screen.dart';
import '../screens/home_shell.dart';
import '../screens/detail_screen.dart';
import '../screens/settings_screen.dart';

class MiniKatalogApp extends StatelessWidget {
  final AppState state;
  const MiniKatalogApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: state,
      child: Builder(
        builder: (context) {
          final s = AppScope.of(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mini Katalog',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF4F46E5), // indigo-ish professional
                brightness: s.darkMode ? Brightness.dark : Brightness.light,
              ),
              scaffoldBackgroundColor: s.darkMode
                  ? null
                  : const Color(0xFFF6F7FB),
              textTheme: const TextTheme(
                headlineSmall: TextStyle(fontWeight: FontWeight.w700),
                titleLarge: TextStyle(fontWeight: FontWeight.w700),
                titleMedium: TextStyle(fontWeight: FontWeight.w600),
                bodyMedium: TextStyle(height: 1.3),
              ),
              appBarTheme: const AppBarTheme(
                centerTitle: false,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              cardTheme: CardThemeData(
                elevation: 1.5,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),

              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            initialRoute: Routes.splash,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case Routes.splash:
                  return MaterialPageRoute(
                    builder: (_) => const SplashScreen(),
                  );
                case Routes.home:
                  return MaterialPageRoute(builder: (_) => const HomeShell());
                case Routes.detail:
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (_) => DetailScreen(product: args['product']),
                  );
                case Routes.settings:
                  return MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  );
                default:
                  return MaterialPageRoute(
                    builder: (_) => const Scaffold(
                      body: Center(child: Text('Sayfa bulunamadı')),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
