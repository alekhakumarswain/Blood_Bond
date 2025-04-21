import 'package:flutter/material.dart';
import '../models/medicine_store.dart';

class CartItem {
  final Medicine medicine;
  final MedicineStore store;
  int quantity;

  CartItem({
    required this.medicine,
    required this.store,
    this.quantity = 1,
  });

  double get totalPrice => medicine.price * quantity;
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  List<CartItem> _purchasedItems = [];

  List<CartItem> get items => List.unmodifiable(_items);
  List<CartItem> get purchasedItems => List.unmodifiable(_purchasedItems);
  int get itemCount => _items.length;
  double get totalAmount =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addItem(Medicine medicine, MedicineStore store) {
    final existingIndex = _items.indexWhere(
      (item) => item.medicine.medicineId == medicine.medicineId,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(medicine: medicine, store: store));
    }
    notifyListeners();
  }

  void addPurchasedItems(List<CartItem> items) {
    for (var item in items) {
      final existingIndex = _purchasedItems.indexWhere(
          (pItem) => pItem.medicine.medicineId == item.medicine.medicineId);
      if (existingIndex >= 0) {
        _purchasedItems[existingIndex].quantity += item.quantity;
      } else {
        _purchasedItems.add(CartItem(
            medicine: item.medicine,
            store: item.store,
            quantity: item.quantity));
      }
    }
    notifyListeners();
  }

  void removeItem(String medicineId) {
    _items.removeWhere((item) => item.medicine.medicineId == medicineId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void increaseQuantity(String medicineId) {
    final index =
        _items.indexWhere((item) => item.medicine.medicineId == medicineId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String medicineId) {
    final index =
        _items.indexWhere((item) => item.medicine.medicineId == medicineId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }
}
