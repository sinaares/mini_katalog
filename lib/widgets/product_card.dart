import 'package:flutter/material.dart';
import '../models/product.dart';
import '../app/ui.dart';

// This widget shows a single product as a card.
// It is used in catalog and favorites screens.
class ProductCard extends StatelessWidget {
  // Product data
  final Product product;

  // Is this product in favorites?
  final bool isFavorite;

  // When card is tapped (go to detail)
  final VoidCallback onTap;

  // When favorite icon is tapped
  final VoidCallback onFavTap;

  // When add to cart button is pressed
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onTap,
    required this.onFavTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Getting theme colors
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      // When user taps anywhere on card
      onTap: onTap,

      borderRadius: AppUI.borderRadius(),

      child: Card(
        child: Padding(
          padding: AppUI.cardPadding,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: category label and favorite button
              Row(
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.secondaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cs.onSecondaryContainer,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Favorite icon button
                  IconButton(
                    onPressed: onFavTap,
                    tooltip: 'Favori',
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,

                      // If favorite, make it red
                      color: isFavorite ? cs.error : null,
                    ),
                  ),
                ],
              ),

              // Product image section
              Expanded(
                child: Center(
                  child: Hero(
                    // Hero animation for smooth transition
                    tag: 'p_${product.id}',
                    child: Image.asset(product.imageAsset, fit: BoxFit.contain),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Product title
              Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 6),

              // Rating and price row
              Row(
                children: [
                  const Icon(Icons.star, size: 16),
                  const SizedBox(width: 4),

                  // Rating value
                  Text(product.rating.toStringAsFixed(1)),

                  const Spacer(),

                  // Price text
                  Text(
                    '${product.price.toStringAsFixed(2)} ₺',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: cs.primary,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Add to cart button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onAddToCart,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
