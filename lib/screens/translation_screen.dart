import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/translation_service.dart';
import '../widgets/language_selector.dart';

class TranslationScreen extends StatefulWidget {
  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _textController = TextEditingController();
  String _translatedText = '';
  String _fromLanguage = 'Indonesia';
  String _toLanguage = 'Ambon';
  bool _isTranslating = false;

  void _translateText() async {
    if (_textController.text.isEmpty) return;

    setState(() {
      _isTranslating = true;
    });

    final translationService = Provider.of<TranslationService>(context, listen: false);
    final result = await translationService.translateText(
      _textController.text,
      _fromLanguage,
      _toLanguage,
    );

    setState(() {
      _translatedText = result;
      _isTranslating = false;
    });
  }

  void _swapLanguages() {
    setState(() {
      final temp = _fromLanguage;
      _fromLanguage = _toLanguage;
      _toLanguage = temp;
      _translatedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Penerjemah'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              // Akan kita implementasi nanti
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Language Selectors
            Row(
              children: [
                Expanded(
                  child: LanguageSelector(
                    value: _fromLanguage,
                    onChanged: (String? newValue) {
                      setState(() {
                        _fromLanguage = newValue!;
                      });
                    },
                    label: 'Dari',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz),
                  onPressed: _swapLanguages,
                ),
                Expanded(
                  child: LanguageSelector(
                    value: _toLanguage,
                    onChanged: (String? newValue) {
                      setState(() {
                        _toLanguage = newValue!;
                      });
                    },
                    label: 'Ke',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Input Text
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Masukkan teks',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _textController.clear();
                    setState(() {
                      _translatedText = '';
                    });
                  },
                ),
              ),
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  _translatedText = '';
                });
              },
            ),
            SizedBox(height: 20),
            
            // Translate Button
            ElevatedButton(
              onPressed: _isTranslating ? null : _translateText,
              child: _isTranslating 
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text('Terjemahkan'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 30),
            
            // Translation Result
            Text(
              'Hasil Terjemahan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _translatedText,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}