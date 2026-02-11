import 'package:flutter/material.dart';
import '../models/product.dart';
import '../app/ui.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavTap;
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
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppUI.borderRadius(),
      child: Card(
        child: Padding(
          padding: AppUI.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: category + fav
              Row(
                children: [
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
                  IconButton(
                    onPressed: onFavTap,
                    tooltip: 'Favori',
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? cs.error : null,
                    ),
                  ),
                ],
              ),

              // Image
              Expanded(
                child: Center(
                  child: Hero(
                    tag: 'p_${product.id}',
                    child: Image.asset(product.imageAsset, fit: BoxFit.contain),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Title
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

              // Rating row
              Row(
                children: [
                  const Icon(Icons.star, size: 16),
                  const SizedBox(width: 4),
                  Text(product.rating.toStringAsFixed(1)),
                  const Spacer(),
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

              // CTA
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
