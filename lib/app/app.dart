import 'package:flutter/material.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import 'routes.dart';
import '../screens/splash_screen.dart';
import '../screens/home_shell.dart';
import '../screens/detail_screen.dart';
import '../screens/settings_screen.dart';

// This is the main widget of the application.
// It receives the global AppState and passes it down using AppScope.
class MiniKatalogApp extends StatelessWidget {
  final AppState state;

  const MiniKatalogApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // AppScope is used to share the app state across the whole application.
    return AppScope(
      notifier: state,
      child: Builder(
        builder: (context) {
          // Here I access the current state (for example dark mode).
          final s = AppScope.of(context);

          return MaterialApp(
            // This removes the debug banner from the top right corner.
            debugShowCheckedModeBanner: false,

            // Application title
            title: 'Mini Katalog',

            // Theme configuration of the app
            theme: ThemeData(
              useMaterial3: true,

              // I generate the color scheme from a seed color.
              // Dark mode depends on the state value.
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF4F46E5),
                brightness: s.darkMode ? Brightness.dark : Brightness.light,
              ),

              // Custom background color when light mode is active.
              scaffoldBackgroundColor: s.darkMode
                  ? null
                  : const Color(0xFFF6F7FB),

              // Text styles used in different parts of the app.
              textTheme: const TextTheme(
                headlineSmall: TextStyle(fontWeight: FontWeight.w700),
                titleLarge: TextStyle(fontWeight: FontWeight.w700),
                titleMedium: TextStyle(fontWeight: FontWeight.w600),
                bodyMedium: TextStyle(height: 1.3),
              ),

              // AppBar style settings.
              appBarTheme: const AppBarTheme(
                centerTitle: false,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // Card design settings used in product cards.
              cardTheme: CardThemeData(
                elevation: 1.5,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),

              // Input field styling.
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            // First screen when the app starts.
            initialRoute: Routes.splash,

            // Here I define all app routes manually.
            onGenerateRoute: (settings) {
              switch (settings.name) {
                // Splash screen route
                case Routes.splash:
                  return MaterialPageRoute(
                    builder: (_) => const SplashScreen(),
                  );

                // Home screen route
                case Routes.home:
                  return MaterialPageRoute(builder: (_) => const HomeShell());

                // Detail screen route
                // I pass the selected product as an argument.
                case Routes.detail:
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (_) => DetailScreen(product: args['product']),
                  );

                // Settings screen route
                case Routes.settings:
                  return MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  );

                // If route is not found, this screen will be shown.
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
