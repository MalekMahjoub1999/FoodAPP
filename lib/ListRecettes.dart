class Recettes {
  final String id;
  final String name;
  final String image; // URL de l'image
  final String description;
  final String category;
  final String difficulty;
  final int preparationTime;
  final List<String> ingredients;
  final List<String> steps;

  Recettes({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.preparationTime,
    required this.ingredients,
    required this.steps,
  });
}
