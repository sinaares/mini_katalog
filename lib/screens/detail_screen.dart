import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/app_scope.dart';

class DetailScreen extends StatelessWidget {
  final Product product;
  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final isFav = state.isFavorite(product.id);
    final qty = state.cartQty(product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: () => state.toggleFavorite(product.id),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 260,
            child: Hero(
              tag: 'p_${product.id}',
              child: Image.asset(product.imageAsset, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 12),
          Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '${product.price.toStringAsFixed(2)} ₺',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
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
          Text(product.description),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              state.addToCart(product);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Sepete eklendi')));
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Sepete Ekle'),
          ),
          const SizedBox(height: 10),
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
