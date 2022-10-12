class Adress {
  final String placeId;
  final String description;

  Adress(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}
