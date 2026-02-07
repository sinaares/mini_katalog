import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../state/app_scope.dart';
import '../widgets/empty_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
      appBar: AppBar(
        title: const Text('Sepet'),
        actions: [
          if (state.cartItemCount > 0)
            IconButton(
              onPressed: state.clearCart,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Sepeti temizle',
            ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text('Hata: ${snap.error}'));

          final all = snap.data ?? [];
          final cartMap = state.cart;

          if (cartMap.isEmpty) {
            return const EmptyState(
              title: 'Sepet boş',
              subtitle: 'Katalogtan ürün ekleyerek sepetini doldurabilirsin.',
              icon: Icons.shopping_cart_outlined,
            );
          }

          double total = 0;
          final items = <({Product p, int qty})>[];

          for (final entry in cartMap.entries) {
            final p = all.firstWhere((x) => x.id == entry.key);
            final qty = entry.value;
            total += p.price * qty;
            items.add((p: p, qty: qty));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return Card(
                      child: ListTile(
                        leading: Image.asset(item.p.imageAsset, width: 44),
                        title: Text(item.p.title),
                        subtitle: Text(
                          '${item.p.price.toStringAsFixed(2)} ₺  x  ${item.qty}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => state.removeFromCart(item.p),
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            IconButton(
                              onPressed: () => state.addToCart(item.p),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Toplam: ${total.toStringAsFixed(2)} ₺',
                          ),
                        ),
                      );
                    },
                    child: Text('Öde  •  ${total.toStringAsFixed(2)} ₺'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
