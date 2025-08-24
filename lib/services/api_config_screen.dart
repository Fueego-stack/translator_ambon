import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class ApiConfigScreen extends StatefulWidget {
  @override
  _ApiConfigScreenState createState() => _ApiConfigScreenState();
}

class _ApiConfigScreenState extends State<ApiConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _engineController = TextEditingController();
  late String _currentEngine;

  @override
  void initState() {
    super.initState();
    _currentEngine = AppConstants.defaultEngine;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final apiService = Provider.of<ApiService>(context, listen: false);
    _currentEngine = apiService.getEngine();
    _engineController.text = _currentEngine;
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Konfigurasi API'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'API Translation Engine',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _engineController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Masukkan Engine',
                  hintText: 'google, bing, libre, dll.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Engine tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text(
                'Engine saat ini: $_currentEngine',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    apiService.setEngine(_engineController.text);
                    setState(() {
                      _currentEngine = _engineController.text;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Engine berhasil diubah ke $_currentEngine')),
                    );
                  }
                },
                child: Text('Simpan Engine'),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              Text(
                'Informasi API:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Endpoint: ${AppConstants.customTranslateApiUrl}'),
              Text('Format: GET /translate?engine={engine}&text={text}&from={from}&to={to}'),
              SizedBox(height: 10),
              Text(
                'Engine yang tersedia:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('- google: Google Translate'),
              Text('- bing: Microsoft Bing Translator'),
              Text('- libre: LibreTranslate'),
              Text('- yandex: Yandex Translate'),
            ],
          ),
        ),
      ),
    );
  }
}