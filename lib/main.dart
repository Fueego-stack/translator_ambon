import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/database_service.dart';
import 'services/api_service.dart';
import 'services/translation_service.dart';
import 'screens/home_screen.dart';
import 'screens/translation_screen.dart'; // Import TranslationScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  final DatabaseService databaseService = DatabaseService();
  final ApiService apiService = ApiService();
  final TranslationService translationService = TranslationService(databaseService, apiService);
  
  await databaseService.database; // Initialize database

  runApp(
    MultiProvider(
      providers: [
        Provider<DatabaseService>(create: (_) => databaseService),
        Provider<ApiService>(create: (_) => apiService),
        Provider<TranslationService>(create: (_) => translationService),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ambon Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: {
        '/': (context) => HomeScreen(),
        '/translation': (context) => TranslationScreen(),
        // Kita akan tambahkan route untuk dictionary management nanti
      },
      debugShowCheckedModeBanner: false,
    );
  }
}