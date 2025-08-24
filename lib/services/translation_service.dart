import '../models/dictionary_item.dart';
import '../services/database_service.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class TranslationService {
  final DatabaseService _databaseService;
  final ApiService _apiService;

  TranslationService(this._databaseService, this._apiService);

  Future<String> translateText(String text, String fromLang, String toLang) async {
    if (text.isEmpty) return '';

    // Bersihkan teks input
    final cleanText = text.trim();

    // Jika terjemahan melibatkan bahasa Ambon, gunakan database lokal
    if (fromLang == 'Ambon' || toLang == 'Ambon') {
      return await _translateWithAmbon(cleanText, fromLang, toLang);
    }
    
    // Untuk terjemahan Indonesia-Inggris, gunakan API
    return await _translateWithApi(cleanText, fromLang, toLang);
  }

  Future<String> _translateWithAmbon(String text, String fromLang, String toLang) async {
    try {
      // Cari di database lokal
      final results = await _databaseService.searchWords(text, fromLang, toLang);
      
      if (results.isNotEmpty) {
        // Ambil hasil terjemahan pertama
        final DictionaryItem item = results.first;
        
        switch (toLang) {
          case 'Ambon': return item.ambon;
          case 'Indonesia': return item.indonesia;
          case 'Inggris': return item.english ?? text;
          default: return text;
        }
      }
      
      // Jika tidak ditemukan di database, coba terjemahkan tidak langsung
      return await _indirectTranslation(text, fromLang, toLang);
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> _translateWithApi(String text, String fromLang, String toLang) async {
    try {
      // Konversi nama bahasa ke kode bahasa untuk API
      final fromCode = AppConstants.languageApiCodes[fromLang] ?? 'auto';
      final toCode = AppConstants.languageApiCodes[toLang] ?? 'en';
      
      return await _apiService.translateText(text, fromCode, toCode);
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> _indirectTranslation(String text, String fromLang, String toLang) async {
    // Untuk terjemahan tidak langsung (contoh: Inggris -> Ambon)
    if (fromLang == 'Inggris' && toLang == 'Ambon') {
      // Terjemahkan Inggris -> Indonesia dulu
      final indonesianText = await _translateWithApi(text, 'Inggris', 'Indonesia');
      
      // Kemudian Indonesia -> Ambon
      return await _translateWithAmbon(indonesianText, 'Indonesia', 'Ambon');
    }
    else if (fromLang == 'Ambon' && toLang == 'Inggris') {
      // Terjemahkan Ambon -> Indonesia dulu
      final indonesianText = await _translateWithAmbon(text, 'Ambon', 'Indonesia');
      
      // Kemudian Indonesia -> Inggris
      return await _translateWithApi(indonesianText, 'Indonesia', 'Inggris');
    }
    
    return 'Terjemahan tidak ditemukan';
  }
}