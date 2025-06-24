import 'package:flutter/material.dart';
import '../../domain/entities/country.dart';

class CountryCard extends StatefulWidget {
  final Country country;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const CountryCard({
    super.key,
    required this.country,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard> {
  bool _imageError = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: 173,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          image: _imageError
              ? null
              : DecorationImage(
                  image: NetworkImage(
                    widget.country.flag.isNotEmpty
                        ? widget.country.flag
                        : "https://placehold.co/173x173"
                  ),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    setState(() {
                      _imageError = true;
                    });
                  },
                ),
          color: _imageError ? Colors.grey[300] : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Stack(
          children: [
            // Show error icon if image failed to load
            if (_imageError)
              const Center(
                child: Icon(
                  Icons.flag,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            // Gradient overlay at the bottom
            Positioned(
              left: 0,
              top: 119,
              child: Container(
                width: 173,
                height: 54,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.50, -0.04),
                    end: Alignment(0.50, 1.00),
                    colors: [
                      Color(0x21848484),
                      Color(0x87111416),
                      Color(0xFF111416)
                    ],
                  ),
                ),
              ),
            ),
            // Favorite heart icon
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                onTap: widget.onFavoriteToggle,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.isFavorite ? Colors.red : Colors.grey,
                    size: 18,
                  ),
                ),
              ),
            ),
            // Population info at bottom left
            Positioned(
              left: 8,
              bottom: 8,
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Icon(
                      Icons.people,
                      size: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatNumber(widget.country.population),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ),
            // Country name at bottom
            Positioned(
              left: 8,
              bottom: 25,
              right: 8,
              child: Text(
                widget.country.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
