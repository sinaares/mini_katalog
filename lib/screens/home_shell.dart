import 'package:flutter/material.dart';
import '../state/app_scope.dart';
import 'catalog_screen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['tab'] is int) {
      index = args['tab'] as int;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    final pages = const [CatalogScreen(), FavoritesScreen(), CartScreen()];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.grid_view),
              label: 'Katalog',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: 'Favoriler',
            ),
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
