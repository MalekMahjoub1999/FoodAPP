//ce fichier va assurer l interaction entre l ui  and le database fb
import 'package:cloud_firestore/cloud_firestore.dart';
//CuisineBase//collection name


class FirestoreService {
  //la je vais creer une instance de firestore pour acceder ala bd

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  //la je vais initiliser la bd plutot la collections ou mes recttes sont stockés

  final String CuisineBase = 'recette';

  //  Ajouter une recette
// Ajouter une recette dans la collection globale "cuisineBase"
  Future<void> addRecette({
    required String userId,
    required String name,
    required String description,
    required String category,
    required String difficulty,

    required List<String> ingredients,
    required List<String> steps,
    required String imageUrl,
  }) async {
    try {
      final recette = {
        'name': name,
        'description': description,
        'category': category,
        'difficulty': difficulty,
        'ingredients': ingredients,
        'steps': steps,
        'imageUrl': imageUrl,
        'createdAt': DateTime.now(),
        'userId': userId,
      };

      // Ici tu peux choisir où stocker :
      // soit dans une collection globale "cuisineBase"
      await _db.collection('cuisineBase').add(recette);

      // soit dans une sous-collection par utilisateur :
      // await _db.collection('users').doc(userId).collection('cuisineBase').add(recette);

      print("Recette ajoutée avec succès !");
    } catch (e) {
      print(" Erreur lors de l'ajout de la recette : $e");
    }
  }


  //  Récupérer toutes les recettes (dans la collection globale "recette")
  Future<List<QueryDocumentSnapshot>> GetRecettes() async {
    final snapshot = await _db.collection('CuisineBase').get();
    return snapshot.docs;
  }

  //  Mettre à jour une recette
  Future<void> updateRecette(String id, Map<String, dynamic> updatedData) async {
    await _db.collection(CuisineBase).doc(id).update(updatedData);
  }

  //  Supprimer une recette
  Future<void> Deleterecette(String id) async {
    await _db.collection(CuisineBase).doc(id).delete();
  }
  Future<void> normalizeFields() async {
    final snapshot = await FirebaseFirestore.instance.collection('cuisineBase').get();

    for (var doc in snapshot.docs) {
      final data = doc.data();

      // Crée les nouveaux champs avec les bons noms
      final updatedData = {
        'name': data['Name'],
        'description': data['Description'],
        'category': data['Category'],
        'imageUrl': data['ImageUrl'],
        'difficulty': data['difficulty'],

        'ingredients': data['Ingredients'],
        'steps': data['Steps'],
      };

      // Mets à jour le document
      await doc.reference.update(updatedData);

      // Supprime les anciens champs si tu veux nettoyer
      await doc.reference.update({
        'Name': FieldValue.delete(),
        'Description': FieldValue.delete(),
        'Category': FieldValue.delete(),
        'ImageUrl': FieldValue.delete(),
        'Ingredients': FieldValue.delete(),
        'Steps': FieldValue.delete(),
      });
    }
  }

}
