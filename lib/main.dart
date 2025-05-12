import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blood_bond/models/medicine_store.dart';
import 'package:blood_bond/providers/cart_provider.dart';
import 'package:blood_bond/providers/appointment_provider.dart';
import 'package:blood_bond/screen/medicine/CartScreen.dart';
import 'package:blood_bond/screen/welcome.dart';
import 'package:blood_bond/screen/Signup.dart';
import 'package:blood_bond/screen/Login.dart';
import 'package:blood_bond/widgets/Navbar.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final Color primaryAccent = const Color(0xFFD32F2F);
  final Color secondaryAccent = const Color(0xFF283593);
  final Color backgroundColor = const Color(0xFFF4F6F8);
  final Color cardBackground = const Color(0xFFFFFFFF);
  final Color highlightColor = const Color(0xFFFFA726);
  final Color textPrimary = const Color(0xFF212121);
  final Color textSecondary = const Color(0xFF616161);
  final Color pinkColor = Colors.pink;

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.light(
      primary: primaryAccent,
      secondary: secondaryAccent,
      surface: cardBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
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
              textStyle: const TextStyle(color: Colors.white),
            ),
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(color: textPrimary),
            bodyMedium: TextStyle(color: textSecondary),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: primaryAccent,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/welcome',
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/signup': (context) => const SignupScreen(),
          '/login': (context) => const LoginScreen(),
          '/cart': (context) => CartScreen(),
          '/nav': (context) => NavScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
