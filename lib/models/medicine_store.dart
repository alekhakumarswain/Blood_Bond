import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class Medicine {
  final String medicineId;
  final String name;
  final double price;
  final String dosage;
  final String category;
  final String offers;
  final int stock;
  final Map<String, dynamic> genericAlternative;

  Medicine({
    required this.medicineId,
    required this.name,
    required this.price,
    required this.dosage,
    required this.category,
    required this.offers,
    required this.stock,
    required this.genericAlternative,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      medicineId: json['MedicineId'] as String,
      name: json['Name'] as String,
      price: (json['Price'] as num).toDouble(),
      dosage: json['Dosage'] as String,
      category: json['Category'] as String,
      offers: json['Offers'] as String,
      stock: json['Stock'] as int,
      genericAlternative: json['GenericAlternative'] as Map<String, dynamic>,
    );
  }
}

class MedicineStore {
  final String storeId;
  final String storeName;
  final String area;
  final String address;
  final String? contactNumber;
  final double latitude;
  final double longitude;
  final List<Medicine> medicines;

  MedicineStore({
    required this.storeId,
    required this.storeName,
    required this.area,
    required this.address,
    this.contactNumber,
    required this.latitude,
    required this.longitude,
    required this.medicines,
  });

  factory MedicineStore.fromJson(Map<String, dynamic> json) {
    return MedicineStore(
      storeId: json['StoreId'] as String,
      storeName: json['StoreName'] as String,
      area: json['Area'] as String,
      address: json['Address'] as String,
      contactNumber: json['ContactNumber']?.toString(),
      latitude: (json['Latitude'] as num).toDouble(),
      longitude: (json['Longitude'] as num).toDouble(),
      medicines: (json['Medicines'] as List)
          .map((medicine) => Medicine.fromJson(medicine))
          .toList(),
    );
  }
}

class MedicineProvider extends ChangeNotifier {
  List<MedicineStore> _stores = [];
  List<MedicineStore> get stores => _stores;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  List<MedicineStore> get searchedStores => _searchQuery.isEmpty
      ? _stores
      : _stores
          .where((store) => store.storeName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();

  Future<void> loadMedicineData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/Data/medicine_store_list.json');
      final List<dynamic> data = jsonDecode(response);
      _stores = data.map((json) => MedicineStore.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading medicine data: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners(); // Trigger UI update when search query changes
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners(); // Trigger UI update to show all stores
  }
}
