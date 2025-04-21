import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _selectedPaymentMethod = 'Credit Card';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Color(0xFFBE179A),
      ),
      body: cartProvider.items.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.items.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.items[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Color(0xFFBE179A).withOpacity(0.5),
                        child: ListTile(
                          title: Text(
                            item.medicine.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline,
                                    color: Color(0xFFBE179A)),
                                onPressed: () {
                                  cartProvider.decreaseQuantity(
                                      item.medicine.medicineId);
                                },
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline,
                                    color: Color(0xFFBE179A)),
                                onPressed: () {
                                  cartProvider.increaseQuantity(
                                      item.medicine.medicineId);
                                },
                              ),
                              SizedBox(width: 20),
                              Text('₹${item.totalPrice.toStringAsFixed(2)}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Color(0xFFBE179A)),
                            onPressed: () {
                              cartProvider.removeItem(item.medicine.medicineId);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Divider(),
                      _buildPriceRow('Total Price', cartProvider.totalAmount),
                      _buildPriceRow(
                          'Discount (10%)', cartProvider.totalAmount * 0.10),
                      Divider(),
                      _buildPriceRow(
                          'Final Price', cartProvider.totalAmount * 0.90),
                      SizedBox(height: 20),
                      Text(
                        'Select Payment Method',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      ListTile(
                        title: const Text('Credit Card'),
                        leading: Radio<String>(
                          value: 'Credit Card',
                          groupValue: _selectedPaymentMethod,
                          activeColor: Color(0xFFBE179A),
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('UPI'),
                        leading: Radio<String>(
                          value: 'UPI',
                          groupValue: _selectedPaymentMethod,
                          activeColor: Color(0xFFBE179A),
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Cash on Delivery'),
                        leading: Radio<String>(
                          value: 'Cash on Delivery',
                          groupValue: _selectedPaymentMethod,
                          activeColor: Color(0xFFBE179A),
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFBE179A),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Payment'),
                              content: Text(
                                  'This is a fake online payment popup for $_selectedPaymentMethod.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
                          'Proceed to Pay',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
          Text('₹${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
        ],
      ),
    );
  }
}
