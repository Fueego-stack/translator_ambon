import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LanguageSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  final String label;

  const LanguageSelector({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: AppConstants.supportedLanguages.map((String language) {
        return DropdownMenuItem<String>(
          value: language,
          child: Text(language),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}