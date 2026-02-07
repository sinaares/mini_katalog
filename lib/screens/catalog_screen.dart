import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../state/app_scope.dart';
import '../app/routes.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_chips.dart';
import '../widgets/product_card.dart';

enum SortMode { none, priceAsc, priceDesc, ratingDesc }

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final repo = ProductRepository();
  late Future<List<Product>> future;

  String query = '';
  String selectedCategory = 'Hepsi';
  SortMode sortMode = SortMode.none;

  @override
  void initState() {
    super.initState();
    future = repo.fetchAll();
  }

  List<Product> _apply(List<Product> all) {
    var list = all;

    // categories
    if (selectedCategory != 'Hepsi') {
      list = list.where((p) => p.category == selectedCategory).toList();
    }

    // search
    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where(
            (p) =>
                p.title.toLowerCase().contains(q) ||
                p.description.toLowerCase().contains(q),
          )
          .toList();
    }

    // sort
    final sorted = [...list];
    switch (sortMode) {
      case SortMode.none:
        break;
      case SortMode.priceAsc:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortMode.priceDesc:
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortMode.ratingDesc:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog'),
        actions: [
          PopupMenuButton<SortMode>(
            icon: const Icon(Icons.sort),
            onSelected: (v) => setState(() => sortMode = v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: SortMode.none, child: Text('Sıralama: Yok')),
              PopupMenuItem(
                value: SortMode.priceAsc,
                child: Text('Fiyat: Artan'),
              ),
              PopupMenuItem(
                value: SortMode.priceDesc,
                child: Text('Fiyat: Azalan'),
              ),
              PopupMenuItem(
                value: SortMode.ratingDesc,
                child: Text('Puan: Yüksekten'),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Hata: ${snap.error}'));
          }

          final all = snap.data ?? [];
          final categories = <String>{
            'Hepsi',
            ...all.map((e) => e.category),
          }.toList();

          final shown = _apply(all);

          return RefreshIndicator(
            onRefresh: () async {
              setState(() => future = repo.fetchAll());
              await future;
            },
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                SearchBarBox(
                  value: query,
                  onChanged: (v) => setState(() => query = v),
                ),
                const SizedBox(height: 10),
                CategoryChips(
                  categories: categories,
                  selected: selectedCategory,
                  onSelected: (c) => setState(() => selectedCategory = c),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: shown.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, i) {
                    final p = shown[i];
                    final isFav = state.isFavorite(p.id);

                    return ProductCard(
                      product: p,
                      isFavorite: isFav,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.detail,
                          arguments: {'product': p},
                        );
                      },
                      onFavTap: () => state.toggleFavorite(p.id),
                      onAddToCart: () {
                        state.addToCart(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${p.title} sepete eklendi')),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
