import 'package:flutter/material.dart';

/// Material equivalents of the web lucide set (`order-menu.tsx`
/// `categoryIcon`), used for photo placeholders.
IconData categoryIconForSlug(String slug) {
  switch (slug) {
    case 'hot-drinks':
    case 'barista':
      return Icons.coffee;
    case 'cold-drinks':
      return Icons.emoji_food_beverage;
    case 'western':
      return Icons.restaurant;
    case 'crepes':
      return Icons.breakfast_dining;
    case 'oriental':
      return Icons.local_fire_department;
    case 'alcoholic-drinks':
      return Icons.wine_bar;
    case 'pizza':
      return Icons.local_pizza;
    case 'cold-appetizers':
    case 'salads':
      return Icons.eco;
    case 'hot-appetizers':
      return Icons.soup_kitchen;
    case 'pasta':
      return Icons.ramen_dining;
    case 'hookah':
      return Icons.air;
    case 'desserts':
      return Icons.cake;
    default:
      return Icons.restaurant_menu;
  }
}
