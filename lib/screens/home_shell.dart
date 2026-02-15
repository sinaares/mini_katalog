import 'package:flutter/material.dart';
import '../state/app_scope.dart';
import 'catalog_screen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';

// This widget works as the main container of the app.
// It holds the bottom navigation and switches between main pages.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  // This variable keeps track of the selected tab index.
  int index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Here I check if any argument is passed when navigating to this screen.
    // For example, another screen can open this page with a specific tab.
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map && args['tab'] is int) {
      index = args['tab'] as int;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Accessing global app state (not directly used here but available)
    final state = AppScope.of(context);

    // List of main pages used in bottom navigation
    final pages = const [CatalogScreen(), FavoritesScreen(), CartScreen()];

    return Scaffold(
      // The body changes depending on selected tab
      body: pages[index],

      // Bottom navigation bar
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          // Styling for bottom navigation labels
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        child: NavigationBar(
          // Currently selected tab
          selectedIndex: index,

          // Update index when user selects a different tab
          onDestinationSelected: (i) => setState(() => index = i),

          destinations: const [
            // Catalog tab
            NavigationDestination(
              icon: Icon(Icons.grid_view),
              label: 'Katalog',
            ),

            // Favorites tab
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: 'Favoriler',
            ),

            // Cart tab
            NavigationDestination(
              icon: Icon(Icons.shopping_cart),
              label: 'Sepet',
            ),
          ],
        ),
      ),
    );
  }
}
