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
                          'Discount', _calculateTotalDiscount(cartProvider)),
                      Divider(),
                      _buildPriceRow(
                          'Final Price',
                          cartProvider.totalAmount -
                              _calculateTotalDiscount(cartProvider)),
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
                          // Add current cart items to purchasedItems using method
                          cartProvider.addPurchasedItems(cartProvider.items);
                          cartProvider.clearCart();

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Payment Successful'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle,
                                      color: Colors.green, size: 60),
                                  SizedBox(height: 10),
                                  Text(
                                      'Payment successful for $_selectedPaymentMethod.'),
                                ],
                              ),
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

  double _parseDiscountPercent(String offers) {
    final RegExp regex = RegExp(r'(\d+)%');
    final match = regex.firstMatch(offers);
    if (match != null) {
      return double.tryParse(match.group(1)!) ?? 0.0;
    }
    return 0.0;
  }

  double _calculateTotalDiscount(cartProvider) {
    double totalDiscount = 0.0;
    for (var item in cartProvider.items) {
      double discountPercent = _parseDiscountPercent(item.medicine.offers);
      double discountAmount =
          item.medicine.price * item.quantity * discountPercent / 100;
      totalDiscount += discountAmount;
    }
    return totalDiscount;
  }
}
