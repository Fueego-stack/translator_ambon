class AppConstants {
  static const String appName = 'Ambon Translator';
  static const List<String> supportedLanguages = ['Ambon', 'Indonesia', 'Inggris'];
  static const List<String> languageCodes = ['amb', 'id', 'en'];
  
  // API Configuration
  static const String customTranslateApiUrl = 'https://amm-api-translate.herokuapp.com/translate';
  static const String defaultEngine = 'google'; // Engine default untuk API
  
  // Kode bahasa untuk API
  static const Map<String, String> languageApiCodes = {
    'Indonesia': 'id',
    'Inggris': 'en',
    'Ambon': 'amb', // Perlu konfirmasi apakah API mendukung bahasa Ambon
  };
}

class AppRoutes {
  static const String home = '/';
  static const String translation = '/translation';
  static const String dictionary = '/dictionary';
  static const String history = '/history';
  static const String apiConfig = '/api-config';
}