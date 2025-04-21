import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blood_bond/widgets/Navbar.dart';
import 'package:blood_bond/models/medicine_store.dart';
import 'package:blood_bond/providers/cart_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Blood Bond',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: NavScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
