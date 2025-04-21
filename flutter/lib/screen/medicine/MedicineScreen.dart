import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medicine_store.dart';
import '../../providers/cart_provider.dart';
import 'MedicineDetailScreen.dart';
import 'ShopDetailScreen.dart';
import 'CartScreen.dart'; // Added import for CartScreen

class MedicineScreen extends StatefulWidget {
  @override
  _MedicineScreenState createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<MedicineProvider>(context, listen: false).loadMedicineData();
    _searchController.addListener(() {
      Provider.of<MedicineProvider>(context, listen: false)
          .setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final filteredStores = medicineProvider.searchedStores;

    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Shops'),
        backgroundColor: Color(0xFFBE179A),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartProvider.itemCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: medicineProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFBE179A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Color(0xFFBE179A)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search medicine stores...',
                        prefixIcon:
                            Icon(Icons.search, color: Color(0xFFBE179A)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      cursorColor: Color(0xFFBE179A),
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredStores.isEmpty
                      ? Center(child: Text('No medicine stores available'))
                      : ListView.builder(
                          itemCount: filteredStores.length,
                          itemBuilder: (context, index) {
                            final store = filteredStores[index];
                            return Card(
                              margin: EdgeInsets.all(8),
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadowColor: Color(0xFFBE179A).withOpacity(0.5),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Color(0xFFBE179A).withOpacity(0.3),
                                  child: Text(
                                    store.storeName[0],
                                    style: TextStyle(color: Color(0xFFBE179A)),
                                  ),
                                ),
                                title: Text(
                                  store.storeName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(store.area),
                                    Text(store.address),
                                    Text(
                                      '${store.medicines.length} medicines available',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                trailing: Icon(Icons.arrow_forward,
                                    color: Color(0xFFBE179A)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ShopDetailScreen(store: store),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
