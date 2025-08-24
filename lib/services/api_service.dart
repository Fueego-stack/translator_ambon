import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  String _apiEngine = AppConstants.defaultEngine;

  // Method untuk menerjemahkan teks menggunakan API custom
  Future<String> translateText(String text, String fromCode, String toCode) async {
    try {
      // Bangun URL dengan parameter
      final Uri uri = Uri.parse(AppConstants.customTranslateApiUrl).replace(
        queryParameters: {
          'engine': _apiEngine,
          'text': text,
          'from': fromCode,
          'to': toCode,
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Coba berbagai kemungkinan format response
        if (data['translatedText'] != null) {
          return data['translatedText'];
        } else if (data['translation'] != null) {
          return data['translation'];
        } else if (data['text'] != null) {
          return data['text'];
        } else {
          return 'Format response tidak dikenali';
        }
      } else {
        return await _translateWithFallback(text, fromCode, toCode);
      }
    } catch (e) {
      return await _translateWithFallback(text, fromCode, toCode);
    }
  }
  
  // Fallback method jika API tidak tersedia atau gagal
  Future<String> _translateWithFallback(String text, String fromCode, String toCode) async {
    // Simulasi delay seperti API nyata
    await Future.delayed(Duration(milliseconds: 500));
    
    // Daftar terjemahan sederhana untuk demo
    final simpleTranslations = {
      'id': {
        'en': {
          'selamat pagi': 'good morning',
          'terima kasih': 'thank you',
          'apa kabar': 'how are you',
          'saya': 'i',
          'kamu': 'you',
          'rumah': 'house',
          'air': 'water',
        }
      },
      'en': {
        'id': {
          'good morning': 'selamat pagi',
          'thank you': 'terima kasih',
          'how are you': 'apa kabar',
          'i': 'saya',
          'you': 'kamu',
          'house': 'rumah',
          'water': 'air',
        }
      }
    };
    
    // Coba cari terjemahan sederhana
    final translation = simpleTranslations[fromCode]?[toCode]?[text.toLowerCase()];
    
    // Jika tidak ditemukan, kembalikan teks asli dengan penanda
    return translation ?? '[FALLBACK] $text';
  }
  
  // Method untuk mengubah engine terjemahan
  void setEngine(String newEngine) {
    _apiEngine = newEngine;
  }
  
  // Method untuk mendapatkan engine saat ini
  String getEngine() {
    return _apiEngine;
  }
}