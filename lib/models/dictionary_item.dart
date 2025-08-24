class DictionaryItem {
  final int id;
  final String ambon;
  final String indonesia;
  final String? english;
  final String category;
  final String? description;

  DictionaryItem({
    required this.id,
    required this.ambon,
    required this.indonesia,
    this.english,
    required this.category,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ambon': ambon,
      'indonesia': indonesia,
      'english': english,
      'category': category,
      'description': description,
    };
  }

  factory DictionaryItem.fromMap(Map<String, dynamic> map) {
    return DictionaryItem(
      id: map['id'],
      ambon: map['ambon'],
      indonesia: map['indonesia'],
      english: map['english'],
      category: map['category'],
      description: map['description'],
    );
  }

  @override
  String toString() {
    return 'DictionaryItem{id: $id, ambon: $ambon, indonesia: $indonesia, english: $english, category: $category, description: $description}';
  }
}
