import 'package:flutter/material.dart';

class AppIcons {
  static const Map<String, IconData> _map = {
    'home': Icons.home,
    'food': Icons.restaurant,
    'drink': Icons.local_cafe,
    'fashion': Icons.checkroom,
    'electronics': Icons.devices,
    'health': Icons.health_and_safety,
    'beauty': Icons.face,
    'sport': Icons.sports,
    'book': Icons.book,
    'toy': Icons.toys,
    'grocery': Icons.shopping_basket,
    'service': Icons.build,
  };

  static IconData get(String? name) {
    if (name == null || name.isEmpty) return Icons.category;
    return _map[name.toLowerCase()] ?? Icons.category;
  }
}