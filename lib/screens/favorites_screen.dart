import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../state/app_scope.dart';
import '../app/routes.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final repo = ProductRepository();
  late Future<List<Product>> future;

  @override
  void initState() {
    super.initState();
    future = repo.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoriler')),
      body: FutureBuilder<List<Product>>(
        future: future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text('Hata: ${snap.error}'));

          final all = snap.data ?? [];
          final favs = all.where((p) => state.isFavorite(p.id)).toList();

          if (favs.isEmpty) {
            return const EmptyState(
              title: 'Favori yok',
              subtitle:
                  'Kalp ikonuna basarak ürünleri favorilere ekleyebilirsin.',
              icon: Icons.favorite_border,
            );
          }

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
                  isFavorite: true,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.detail,
                      arguments: {'product': p},
                    );
                  },
                  onFavTap: () => state.toggleFavorite(p.id),
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
