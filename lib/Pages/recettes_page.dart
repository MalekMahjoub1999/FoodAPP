import 'package:apprecette/Pages/AddRecettePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../ListRecettes.dart';
import '../homePage.dart';
import '../services/firestore_service.dart';
import 'detailsPage.dart';

class Recettespage extends StatefulWidget {
  final User? user;

  const Recettespage({super.key, this.user});

  @override
  State<Recettespage> createState() => _RecettespageState();
}

class _RecettespageState extends State<Recettespage> {
  final FirestoreService firestoreService = FirestoreService();
  late List<Recettes> recettes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecettes();
  }

  void fetchRecettes() async {
    try {
      final documents = await firestoreService.GetRecettes();
      setState(() {
        recettes = documents.map<Recettes>((doc) {
          final data = doc.data() as Map<String, dynamic>;

          final imageUrl = data['imageUrl'] ?? data['image'] ?? '';

          return Recettes(
            id: doc.id,
            name: data['name'] ?? '',
            description: data['description'] ?? '',
            image: imageUrl,
            category: data['category'] ?? '',
            difficulty: data['difficulty'] ?? '',
            preparationTime: data['preparationTime'] ?? 0,
            ingredients: data['ingredients'] != null
                ? List<String>.from(data['ingredients'])
                : [],
            steps: data['steps'] != null
                ? List<String>.from(data['steps'])
                : [],
          );
        }).toList();

        isLoading = false;
      });
    } catch (e) {
      print("Erreur lors de la récupération des recettes : $e");
      setState(() => isLoading = false);
    }
  }

  /// Widget pour une seule carte de recette
  Widget buildTemplate(Recettes recette) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                // Navigation vers la page de détails (optionnel)
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => DetailsPage(recette: recette),
                //   ),
                // );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: recette.image.isNotEmpty
                    ? Image.network(
                  recette.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                        child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset(
                        'assets/images/placeholder.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                )
                    : Image.asset(
                  'assets/images/placeholder.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              recette.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'The Good Food is here',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 4,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey[700]),
              child: Text(
                widget.user != null
                    ? '${widget.user!.email} est connecté'
                    : 'Utilisateur inconnu',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Connection Page'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Recette'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Addrecettepage()),
                );
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : recettes.isEmpty
      ? const Center(
      child: Text(
      'Aucune recette trouvée.',
      style: TextStyle(color: Colors.white),
    ),
    )
        : ListView(
    children: recettes.map((r) => buildTemplate(r)).toList(),
    ),
    floatingActionButton: FloatingActionButton(
    backgroundColor: Colors.deepOrange,
    tooltip: 'Ajouter une recette',
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Addrecettepage()),
    );
    },
    child: const Icon(Icons.add),
    ),
    );
  }
}
