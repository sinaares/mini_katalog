import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../state/app_scope.dart';
import '../widgets/empty_state.dart';

// This screen shows the products that the user added to the cart.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Repository to load product data from JSON
  final repo = ProductRepository();

  // Future list that will hold all products
  late Future<List<Product>> future;

  @override
  void initState() {
    super.initState();

    // When screen starts, I load all products from local JSON
    future = repo.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    // Getting the global app state (cart, etc.)
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepet'),
        actions: [
          // If cart is not empty, show delete button
          if (state.cartItemCount > 0)
            IconButton(
              onPressed: state.clearCart,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Sepeti temizle',
            ),
        ],
      ),

      // I use FutureBuilder because products are loaded asynchronously
      body: FutureBuilder<List<Product>>(
        future: future,
        builder: (context, snap) {
          // While loading, show progress indicator
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // If there is an error while loading JSON
          if (snap.hasError) {
            return Center(child: Text('Hata: ${snap.error}'));
          }

          final all = snap.data ?? [];
          final cartMap = state.cart;

          // If cart is empty, show empty state widget
          if (cartMap.isEmpty) {
            return const EmptyState(
              title: 'Sepet boş',
              subtitle: 'Katalogtan ürün ekleyerek sepetini doldurabilirsin.',
              icon: Icons.shopping_cart_outlined,
            );
          }

          // Calculating total price
          double total = 0;

          // Creating a list that holds product and quantity together
          final items = <({Product p, int qty})>[];

          for (final entry in cartMap.entries) {
            // Finding the product by its id
            final p = all.firstWhere((x) => x.id == entry.key);

            final qty = entry.value;

            // Add product total price
            total += p.price * qty;

            items.add((p: p, qty: qty));
          }

          return Column(
            children: [
              // Product list section
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

                        // Buttons to increase or decrease quantity
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

              // Bottom payment button
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      // When pressed, show total price as snackbar
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
