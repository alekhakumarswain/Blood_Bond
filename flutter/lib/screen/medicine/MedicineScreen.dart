import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medicine_store.dart';
import '../../providers/cart_provider.dart';
import 'MedicineDetailScreen.dart';
import 'ShopDetailScreen.dart';
import 'CartScreen.dart'; // Added import for CartScreen
import 'MyMedicine.dart'; // Added import for MyMedicineScreen

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
        backgroundColor: Color(0xFFD32F2F), // Crimson Red primary accent
        elevation: 4,
        shadowColor: Colors.black45,
        actions: [
          IconButton(
            icon: Icon(Icons.medical_services),
            tooltip: 'My Medicines',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyMedicineScreen()),
              );
            },
            color: Colors.white,
          ),
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
                color: Colors.white,
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Color.fromARGB(
                        255, 101, 212, 32), // Vibrant Orange highlight
                    child: Text(
                      cartProvider.itemCount.toString(),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 46, 6, 122),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFF4F6F8), // Soft Light Gray background
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Card background white
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search medicine stores...',
                    prefixIcon: Icon(Icons.search, color: Color(0xFFD32F2F)),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  cursorColor: Color(0xFFD32F2F),
                  style: TextStyle(color: Color(0xFF212121)),
                ),
              ),
            ),
            Expanded(
              child: filteredStores.isEmpty
                  ? Center(
                      child: Text(
                        'No medicine stores available',
                        style:
                            TextStyle(color: Color(0xFF616161), fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredStores.length,
                      itemBuilder: (context, index) {
                        final store = filteredStores[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadowColor: Color(0xFFD32F2F).withOpacity(0.3),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            leading: CircleAvatar(
                              backgroundColor: Color(0xFF283593).withOpacity(
                                  0.3), // Deep Indigo Blue secondary accent
                              child: Text(
                                store.storeName[0],
                                style: TextStyle(
                                    color: Color(0xFF283593),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              store.storeName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(store.area,
                                    style: TextStyle(color: Color(0xFF616161))),
                                Text(store.address,
                                    style: TextStyle(color: Color(0xFF616161))),
                                SizedBox(height: 4),
                                Text(
                                  '${store.medicines.length} medicines available',
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFF616161)),
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward,
                                color: Color(0xFFD32F2F)),
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
      ),
    );
  }
}
