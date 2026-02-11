import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../state/app_scope.dart';
import '../app/routes.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_chips.dart';
import '../widgets/product_card.dart';

enum SortMode { none, priceAsc, priceDesc, ratingDesc }

const String kAllCategory = 'All';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final repo = ProductRepository();
  late Future<List<Product>> future;

  // ✅ key must be inside the State (not global)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String query = '';
  String selectedCategory = kAllCategory;
  SortMode sortMode = SortMode.none;

  @override
  void initState() {
    super.initState();
    future = repo.fetchAll();
  }

  List<Product> _apply(List<Product> all) {
    var list = all;

    // categories
    if (selectedCategory != kAllCategory) {
      list = list.where((p) => p.category.trim() == selectedCategory).toList();
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
      key: _scaffoldKey,

      // ✅ Sidebar (Drawer)
      drawer: Drawer(
        child: SafeArea(
          child: FutureBuilder<List<Product>>(
            future: future,
            builder: (context, snap) {
              final all = snap.data ?? [];
              final unique = all.map((e) => e.category.trim()).toSet().toList()
                ..sort();
              final cats = [kAllCategory, ...unique];

              return ListView(
                children: [
                  const SizedBox(height: 8),
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 44,
                        width: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: const Text(
                      'Mini Katalog',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: const Text('Categories'),
                  ),
                  const Divider(),

                  for (final c in cats)
                    ListTile(
                      leading: Icon(
                        c == kAllCategory
                            ? Icons.grid_view
                            : Icons.label_outline,
                      ),
                      title: Text(c),
                      selected: selectedCategory == c,
                      onTap: () {
                        Navigator.pop(context); // close drawer
                        setState(() {
                          selectedCategory = c;
                          if (c == kAllCategory) query = '';
                        });
                      },
                    ),

                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.settings);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,

        // ✅ menu button opens drawer
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          tooltip: 'Catalog',
        ),

        title: const Text('Catalog'),

        actions: [
          PopupMenuButton<SortMode>(
            icon: const Icon(Icons.sort),
            onSelected: (v) => setState(() => sortMode = v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: SortMode.none, child: Text('Sort: None')),
              PopupMenuItem(
                value: SortMode.priceAsc,
                child: Text('Price: Low → High'),
              ),
              PopupMenuItem(
                value: SortMode.priceDesc,
                child: Text('Price: High → Low'),
              ),
              PopupMenuItem(
                value: SortMode.ratingDesc,
                child: Text('Rating: High → Low'),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
            icon: const Icon(Icons.settings),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: FutureBuilder<List<Product>>(
        future: future,
        builder: (context, snap) {
          // ✅ loading
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          // ✅ error
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          final all = snap.data ?? [];

          final unique = all.map((e) => e.category.trim()).toSet().toList()
            ..sort();
          final categories = [kAllCategory, ...unique];

          final shown = _apply(all);

          return RefreshIndicator(
            onRefresh: () async {
              setState(() => future = repo.fetchAll());
              await future;
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchBarBox(
                          value: query,
                          onChanged: (v) => setState(() => query = v),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              'Categories',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            Text(
                              '${shown.length} items',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CategoryChips(
                          categories: categories,
                          selected: selectedCategory,
                          onSelected: (c) => setState(() {
                            selectedCategory = c;
                            if (c == kAllCategory) query = '';
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: shown.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.60,
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
                          SnackBar(content: Text('${p.title} added to cart')),
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
