import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import 'package:intl/intl.dart';
import 'ShopDetailScreen.dart';
import 'MedicineDetailScreen.dart';

class MyMedicineScreen extends StatelessWidget {
  static const int medicinesPerStrip = 10;
  static const int dailyIntake = 2;
  static const String intakeTime =
      "Before Food"; // Placeholder, can be dynamic if data available

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final purchasedItems = cartProvider.purchasedItems;

    final DateTime purchaseDate = DateTime.now();
    final DateFormat dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text('My Medicines'),
        backgroundColor: Color(0xFFBE179A),
      ),
      body: purchasedItems.isEmpty
          ? Center(child: Text('You have not purchased any medicines yet.'))
          : ListView.builder(
              itemCount: purchasedItems.length,
              itemBuilder: (context, index) {
                final item = purchasedItems[index];
                final strips = item.quantity; // quantity is number of strips
                final totalMedicines = strips * medicinesPerStrip;
                final daysLeft = (totalMedicines / dailyIntake).ceil();

                double progress = 1.0; // full strip

                final DateTime finishDate =
                    purchaseDate.add(Duration(days: daysLeft));

                return Card(
                  margin: EdgeInsets.all(12),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Color(0xFFBE179A).withOpacity(0.7),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.medication,
                                color: Color(0xFFBE179A), size: 40),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.medicine.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFBE179A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                // Navigate to ShopDetailScreen for rebuy
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ShopDetailScreen(store: item.store),
                                  ),
                                );
                              },
                              child: Text('Rebuy'),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                            'Strips: $strips (Each strip has $medicinesPerStrip medicines)'),
                        Text('Total Medicines: $totalMedicines'),
                        Text('Daily Intake: $dailyIntake times ($intakeTime)'),
                        SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          color: Color(0xFFBE179A),
                          minHeight: 12,
                        ),
                        SizedBox(height: 12),
                        Text('Estimated days left: $daysLeft'),
                        Text('Start Date: ${dateFormat.format(purchaseDate)}'),
                        Text('Last Date: ${dateFormat.format(finishDate)}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
