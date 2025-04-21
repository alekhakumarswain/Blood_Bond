import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class Medicine {
  final String name;
  final double price;
  final String description;

  Medicine(
      {required this.name, required this.price, required this.description});

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
    );
  }
}

class MedicineStore extends ChangeNotifier {
  List<Medicine> _medicineList = [];
  List<Medicine> get medicineList => _medicineList;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> loadMedicineData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/Data/medicine_store_list.json');
      final List<dynamic> data = jsonDecode(response);
      _medicineList = data.map((json) => Medicine.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading medicine data: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void addToCart(Medicine medicine) {
    print('Added ${medicine.name} to cart');
    notifyListeners();
  }
}
