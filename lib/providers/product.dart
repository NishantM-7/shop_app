import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFav(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    // Using Optimistic Updating...

    final oldStatus = isFavorite;
    isFavorite = !isFavorite;

    notifyListeners();
    final url = Uri.parse(
        'https://fluttershopapp-465-default-rtdb.asia-southeast1.firebasedatabase.app/userFav/$userId/$id.json?auth=$token');

    try {
      //Put request requires directly the value instead of map containing key and value in json.encode()
      final response = await http.put(url, body: json.encode(isFavorite));

      if (response.statusCode >= 400) {
        _setFav(oldStatus);
      }
    } catch (e) {
      _setFav(oldStatus);
    }
  }
}
