class TOdoModel {
  final String title;
  final String description;

  TOdoModel(this.title, this.description);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }
}
