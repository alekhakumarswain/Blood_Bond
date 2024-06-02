import 'package:flutter/material.dart';

class MedicineScreen extends StatelessWidget {
  final List<Map<String, dynamic>> shops = [
    {
      'name': 'Health Plus Pharmacy',
      'image': 'images/shop1.jpg',
      'rating': 4.5,
      'address': '123 Main Street',
      'phone': '123-456-7890',
      'medicines': [
        {
          'name': 'Paracetamol',
          'description': 'Used for pain relief and fever reduction.',
          'price': '\$10',
          'image': 'images/medicine1.jpg'
        },
        {
          'name': 'Amoxicillin',
          'description': 'Antibiotic used to treat bacterial infections.',
          'price': '\$15',
          'image': 'images/medicine2.jpg'
        },
      ],
    },
    {
      'name': 'Wellness Pharmacy',
      'image': null,
      'rating': 4.0,
      'address': '456 Market Street',
      'phone': '987-654-3210',
      'medicines': [
        {
          'name': 'Ibuprofen',
          'description': 'Used for pain relief and inflammation.',
          'price': '\$12',
          'image': 'images/medicine3.jpg'
        },
        {
          'name': 'Aspirin',
          'description': 'Used for pain relief and reducing fever.',
          'price': '\$8',
          'image': 'images/medicine4.jpg'
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Shops'),
      ),
      body: ListView.builder(
        itemCount: shops.length,
        itemBuilder: (context, index) {
          final shop = shops[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: shop['image'] != null
                  ? AssetImage(shop['image'])
                  : AssetImage('images/default_shop.png'),
            ),
            title: Text(shop['name']),
            subtitle: Text('Rating: ${shop['rating']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopDetailScreen(shop: shop),
                ),
              );
            },
          );
        },
      ),
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
        title: Text(shop['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            shop['image'] != null
                ? Image.asset(shop['image'])
                : Image.asset('images/default_shop.png'),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Rating: ${shop['rating']}'),
                  SizedBox(height: 8),
                  Text('Address: ${shop['address']}'),
                  SizedBox(height: 8),
                  Text('Phone: ${shop['phone']}'),
                  SizedBox(height: 16),
                  Text(
                    'Available Medicines:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: shop['medicines'].length,
                    itemBuilder: (context, index) {
                      final medicine = shop['medicines'][index];
                      return ListTile(
                        leading: Image.asset(medicine['image']),
                        title: Text(medicine['name']),
                        subtitle: Text(medicine['description']),
                        trailing: Text(medicine['price']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MedicineDetailScreen(medicine: medicine),
                            ),
                          );
                        },
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
  final Map<String, String> medicine;

  MedicineDetailScreen({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medicine['name']!),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(medicine['image']!),
            SizedBox(height: 16),
            Text(
              medicine['name']!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              medicine['description']!,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Price: ${medicine['price']}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle order placement
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order placed for ${medicine['name']}!'),
                  ),
                );
              },
              child: Text('Order Now'),
            ),
          ],
        ),
      ),
    );
  }
}
