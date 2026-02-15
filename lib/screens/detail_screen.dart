import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/app_scope.dart';

// This screen shows detailed information about a selected product.
class DetailScreen extends StatelessWidget {
  // The selected product is passed to this screen.
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Accessing global state (favorites and cart)
    final state = AppScope.of(context);

    // Checking if this product is favorite
    final isFav = state.isFavorite(product.id);

    // Getting how many of this product is in the cart
    final qty = state.cartQty(product.id);

    return Scaffold(
      appBar: AppBar(
        // AppBar title shows product name
        title: Text(product.title),

        actions: [
          // Favorite button
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: () => state.toggleFavorite(product.id),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Product image with Hero animation
          SizedBox(
            height: 260,
            child: Hero(
              tag: 'p_${product.id}',
              child: Image.asset(product.imageAsset, fit: BoxFit.contain),
            ),
          ),

          const SizedBox(height: 12),

          // Product title
          Text(product.title, style: Theme.of(context).textTheme.headlineSmall),

          const SizedBox(height: 6),

          // Price and rating row
          Row(
            children: [
              // Product price
              Text(
                '${product.price.toStringAsFixed(2)} ₺',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const Spacer(),

              // Rating display
              Row(
                children: [
                  const Icon(Icons.star, size: 18),
                  const SizedBox(width: 4),
                  Text(product.rating.toStringAsFixed(1)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Product description
          Text(product.description),

          const SizedBox(height: 20),

          // Add to cart button
          FilledButton.icon(
            onPressed: () {
              // Add product to cart
              state.addToCart(product);

              // Show confirmation message
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Sepete eklendi')));
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Sepete Ekle'),
          ),

          const SizedBox(height: 10),

          // If product already exists in cart, show remove button
          if (qty > 0)
            OutlinedButton(
              onPressed: () => state.removeFromCart(product),
              child: Text('Sepetten 1 çıkar (Şu an: $qty)'),
            ),
        ],
      ),
    );
  }
}
