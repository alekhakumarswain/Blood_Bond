import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medicine_store.dart';
import '../../providers/cart_provider.dart';
import 'MedicineDetailScreen.dart';

class ShopDetailScreen extends StatefulWidget {
  final MedicineStore store;

  const ShopDetailScreen({required this.store});

  @override
  _ShopDetailScreenState createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  final TextEditingController _medicineSearchController =
      TextEditingController();
  String _medicineSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _medicineSearchController.addListener(() {
      setState(() {
        _medicineSearchQuery = _medicineSearchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _medicineSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final filteredMedicines = widget.store.medicines.where((medicine) {
      return medicine.name.toLowerCase().contains(_medicineSearchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.store.storeName),
        backgroundColor: Color(0xFFD32F2F), // Crimson Red primary accent
        elevation: 4,
        shadowColor: Colors.black45,
        actions: [
          Builder(
            builder: (context) {
              bool isNavigating = false;
              return IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  if (isNavigating) return;
                  isNavigating = true;
                  Navigator.pushNamed(context, '/cart').then((_) {
                    isNavigating = false;
                  });
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFF4F6F8), // Soft Light Gray background
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Store Information',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121), // Dark Charcoal
                ),
              ),
              Divider(color: Color(0xFF616161)), // Medium Grey
              _buildDetailRow('Area', widget.store.area),
              _buildDetailRow('Address', widget.store.address),
              if (widget.store.contactNumber != null)
                _buildDetailRow('Contact', widget.store.contactNumber!),
              _buildDetailRow('Location',
                  'Lat: ${widget.store.latitude.toStringAsFixed(6)}, Long: ${widget.store.longitude.toStringAsFixed(6)}'),
              SizedBox(height: 20),
              Text(
                'Available Medicines',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              Divider(color: Color(0xFF616161)),
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  controller: _medicineSearchController,
                  decoration: InputDecoration(
                    hintText: 'Search medicines...',
                    prefixIcon: Icon(Icons.search, color: Color(0xFFD32F2F)),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  cursorColor: Color(0xFFD32F2F),
                  style: TextStyle(color: Color(0xFF212121)),
                ),
              ),
              filteredMedicines.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No medicines found',
                        style: TextStyle(color: Color(0xFF616161)),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredMedicines.length,
                      itemBuilder: (context, index) {
                        final medicine = filteredMedicines[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadowColor: Color(0xFFD32F2F).withOpacity(0.3),
                          child: ListTile(
                            title: Text(
                              medicine.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('₹${medicine.price} (${medicine.offers})',
                                    style: TextStyle(color: Color(0xFF616161))),
                                Text('Category: ${medicine.category}',
                                    style: TextStyle(color: Color(0xFF616161))),
                                Text('Stock: ${medicine.stock}',
                                    style: TextStyle(color: Color(0xFF616161))),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.add_shopping_cart,
                                  color: Color(0xFFD32F2F)),
                              onPressed: () {
                                cartProvider.addItem(medicine, widget.store);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Added ${medicine.name} to cart'),
                                    duration: Duration(seconds: 1),
                                    backgroundColor: Color(0xFFD32F2F),
                                  ),
                                );
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MedicineDetailScreen(
                                      medicine: medicine, store: widget.store),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
