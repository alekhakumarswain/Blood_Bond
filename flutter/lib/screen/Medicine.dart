import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(MedicineApp());
}

class MedicineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Shops',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800]),
          titleMedium: TextStyle(fontSize: 16, color: Colors.grey[600]),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: MedicineScreen(),
    );
  }
}

class MedicineScreen extends StatelessWidget {
  Future<List<Map<String, dynamic>>> _loadShops(BuildContext context) async {
    final String response = await DefaultAssetBundle.of(context)
        .loadString('assets/Data/medicine_store_list.json');
    return List<Map<String, dynamic>>.from(json.decode(response));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Shops'),
        elevation: 2,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadShops(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No shops available'));
          }

          final shops = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: shops.length,
            itemBuilder: (context, index) {
              final shop = shops[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.teal[100],
                    child: Text(
                      shop['StoreName'][0],
                      style: TextStyle(fontSize: 20, color: Colors.teal[800]),
                    ),
                  ),
                  title: Text(shop['StoreName'],
                      style: Theme.of(context).textTheme.titleLarge),
                  subtitle: Text(
                    '${shop['Area']} • ${shop['Address']}',
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.teal),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => MedicineDialog(shop: shop),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MedicineDialog extends StatelessWidget {
  final Map<String, dynamic> shop;

  MedicineDialog({required this.shop});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        shop['StoreName'],
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shop['Address'],
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Contact: ${shop['ContactNumber']?.toString() ?? 'N/A'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            Text(
              'Available Medicines:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800]),
            ),
            SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: shop['Medicines'].length,
                itemBuilder: (context, index) {
                  final medicine = shop['Medicines'][index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(medicine['Name'],
                          style: Theme.of(context).textTheme.bodyMedium),
                      subtitle: Text(
                        'Price: ₹${medicine['Price']} • ${medicine['Offers']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      trailing: Icon(Icons.info_outline, color: Colors.teal),
                      onTap: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MedicineDetailScreen(medicine: medicine),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close', style: TextStyle(color: Colors.teal)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShopDetailScreen(shop: shop),
              ),
            );
          },
          child: Text('View Store', style: TextStyle(color: Colors.teal)),
        ),
      ],
    );
  }
}

class ShopDetailScreen extends StatelessWidget {
  final Map<String, dynamic> shop;

  ShopDetailScreen({required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shop['StoreName']),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.teal[50],
              child: Center(
                child: Text(
                  shop['StoreName'][0],
                  style: TextStyle(fontSize: 80, color: Colors.teal[200]),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop['StoreName'],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Area: ${shop['Area']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Address: ${shop['Address']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Phone: ${shop['ContactNumber']?.toString() ?? 'N/A'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Available Medicines:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800]),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: shop['Medicines'].length,
                    itemBuilder: (context, index) {
                      final medicine = shop['Medicines'][index];
                      return Card(
                        child: ListTile(
                          title: Text(medicine['Name']),
                          subtitle: Text(
                            'Price: ₹${medicine['Price']} • ${medicine['Offers']}',
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.teal),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MedicineDetailScreen(medicine: medicine),
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
          ],
        ),
      ),
    );
  }
}

class MedicineDetailScreen extends StatelessWidget {
  final Map<String, dynamic> medicine;

  MedicineDetailScreen({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medicine['Name']),
        elevation: 2,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.teal[50],
              child: Center(
                child: Text(
                  medicine['Name'][0],
                  style: TextStyle(fontSize: 60, color: Colors.teal[200]),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              medicine['Name'],
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Category: ${medicine['Category']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Dosage: ${medicine['Dosage']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Price: ₹${medicine['Price']} (${medicine['Offers']})',
              style: TextStyle(fontSize: 18, color: Colors.teal[700]),
            ),
            SizedBox(height: 8),
            Text(
              'Stock: ${medicine['Stock']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Generic: ${medicine['GenericAlternative']['Name']} (₹${medicine['GenericAlternative']['Price']})',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order placed for ${medicine['Name']}!'),
                      backgroundColor: Colors.teal,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Order Now', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
