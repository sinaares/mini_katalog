import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../state/app_scope.dart';
import '../app/routes.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';

// This screen shows the products that the user marked as favorite.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Repository to load products from JSON
  final repo = ProductRepository();

  // Future list that holds all products
  late Future<List<Product>> future;

  @override
  void initState() {
    super.initState();

    // Load products when screen opens
    future = repo.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    // Access global state (favorites and cart)
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoriler')),

      body: FutureBuilder<List<Product>>(
        future: future,
        builder: (context, snap) {
          // Show loading while fetching products
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error if something goes wrong
          if (snap.hasError) {
            return Center(child: Text('Hata: ${snap.error}'));
          }

          final all = snap.data ?? [];

          // Filter products that are marked as favorite
          final favs = all.where((p) => state.isFavorite(p.id)).toList();

          // If there are no favorite products
          if (favs.isEmpty) {
            return const EmptyState(
              title: 'Favori yok',
              subtitle:
                  'Kalp ikonuna basarak ürünleri favorilere ekleyebilirsin.',
              icon: Icons.favorite_border,
            );
          }

          // Show favorite products in a grid
          return Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              itemCount: favs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, i) {
                final p = favs[i];

                return ProductCard(
                  product: p,

                  // Since this screen only shows favorites,
                  // isFavorite is always true
                  isFavorite: true,

                  // Navigate to detail screen
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.detail,
                      arguments: {'product': p},
                    );
                  },

                  // Remove or toggle favorite
                  onFavTap: () => state.toggleFavorite(p.id),

                  // Add product to cart
                  onAddToCart: () => state.addToCart(p),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
