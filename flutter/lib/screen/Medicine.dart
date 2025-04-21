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
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal[900]),
          titleMedium: TextStyle(fontSize: 16, color: Colors.grey[700]),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        cardTheme: CardTheme(
          elevation: 6,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
        title: Text('Medicine Shops',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[800]!, Colors.teal[200]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadShops(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Colors.teal[700]));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading data: ${snapshot.error}',
                    style: TextStyle(color: Colors.red[700])));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No shops available',
                    style: TextStyle(color: Colors.grey[700])));
          }

          final shops = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: shops.length,
            itemBuilder: (context, index) {
              final shop = shops[index];
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.teal[100],
                    child: Text(
                      shop['StoreName'][0],
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.teal[900],
                          fontWeight: FontWeight.bold),
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
                      size: 18, color: Colors.teal[700]),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.teal[50],
      title: Text(
        shop['StoreName'],
        style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.teal[900]) ??
            TextStyle(color: Colors.teal[900]), // Fix for nullable
      ),
      content: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shop['Address'],
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            Text(
              'Contact: ${shop['ContactNumber']?.toString() ?? 'N/A'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 20),
            Text(
              'Available Medicines:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800]),
            ),
            SizedBox(height: 10),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: shop['Medicines'].length,
                itemBuilder: (context, index) {
                  final medicine = shop['Medicines'][index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      title: Text(medicine['Name'],
                          style: Theme.of(context).textTheme.bodyMedium),
                      subtitle: Text(
                        'Price: ₹${medicine['Price']} • ${medicine['Offers']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      trailing:
                          Icon(Icons.info_outline, color: Colors.teal[700]),
                      onTap: () {
                        Navigator.pop(context);
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
          child: Text('Close',
              style: TextStyle(
                  color: Colors.teal[700], fontWeight: FontWeight.bold)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShopDetailScreen(shop: shop),
              ),
            );
          },
          child: Text('View Store',
              style: TextStyle(
                  color: Colors.teal[700], fontWeight: FontWeight.bold)),
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
        title: Text(shop['StoreName'],
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[800]!, Colors.teal[200]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Fixed from CrossAlignment
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[600]!, Colors.teal[100]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Text(
                  shop['StoreName'][0],
                  style: TextStyle(
                      fontSize: 90,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop['StoreName'],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Area: ${shop['Area']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Address: ${shop['Address']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Phone: ${shop['ContactNumber']?.toString() ?? 'N/A'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Available Medicines:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[900]),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: shop['Medicines'].length,
                    itemBuilder: (context, index) {
                      final medicine = shop['Medicines'][index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          title: Text(medicine['Name'],
                              style: Theme.of(context).textTheme.bodyMedium),
                          subtitle: Text(
                            'Price: ₹${medicine['Price']} • ${medicine['Offers']}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 18, color: Colors.teal[700]),
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
        title: Text(medicine['Name'],
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[800]!, Colors.teal[200]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[600]!, Colors.teal[100]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Text(
                  medicine['Name'][0],
                  style: TextStyle(
                      fontSize: 70,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              medicine['Name'],
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12),
            Text(
              'Category: ${medicine['Category']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 12),
            Text(
              'Dosage: ${medicine['Dosage']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 12),
            Text(
              'Price: ₹${medicine['Price']} (${medicine['Offers']})',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.teal[900],
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Stock: ${medicine['Stock']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 12),
            Text(
              'Generic: ${medicine['GenericAlternative']['Name']} (₹${medicine['GenericAlternative']['Price']})',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order placed for ${medicine['Name']}!'),
                      backgroundColor: Colors.teal[700],
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[800],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Order Now',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
