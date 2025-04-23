import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blood_bond/models/medicine_store.dart';
import 'package:blood_bond/providers/cart_provider.dart';
import 'package:blood_bond/providers/appointment_provider.dart';
import 'package:blood_bond/screen/medicine/CartScreen.dart';
import 'package:blood_bond/screen/welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color primaryAccent = Color(0xFFD32F2F); // Crimson Red
  final Color secondaryAccent = Color(0xFF283593); // Deep Indigo Blue
  final Color backgroundColor = Color(0xFFF4F6F8); // Soft Light Gray
  final Color cardBackground = Color(0xFFFFFFFF); // White
  final Color highlightColor = Color(0xFFFFA726); // Vibrant Orange
  final Color textPrimary = Color(0xFF212121); // Dark Charcoal
  final Color textSecondary = Color(0xFF616161); // Medium Grey
  final Color pinkColor = Colors.pink; // Added pink

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.light(
      primary: primaryAccent,
      secondary: secondaryAccent,
      background: backgroundColor,
      surface: cardBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: textPrimary,
      onSurface: textPrimary,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ],
      child: MaterialApp(
        title: 'Blood Bond',
        theme: ThemeData.from(colorScheme: colorScheme).copyWith(
          scaffoldBackgroundColor: backgroundColor,
          cardColor: cardBackground,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(color: textPrimary),
            bodyMedium: TextStyle(color: textSecondary),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: primaryAccent,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: WelcomeScreen(),
        routes: {
          '/cart': (context) => CartScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
