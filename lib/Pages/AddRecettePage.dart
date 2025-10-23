// lib/Pages/Addrecettepage.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firestore_service.dart';
import 'recettes_page.dart'; // pour revenir à la liste
import 'package:firebase_auth/firebase_auth.dart'; // pour récupérer l’utilisateur


class Addrecettepage extends StatefulWidget {


  final FirestoreService firestoreService = FirestoreService();

  Addrecettepage({super.key}); // ⚠️ pas de const ici

  @override
  State<Addrecettepage> createState() => _AddrecettepageState();
}

class _AddrecettepageState extends State<Addrecettepage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers pour chaque champ
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController difficultyController = TextEditingController();

  final TextEditingController stepsController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text(
          "Add Recettes",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              buildTextField("Name", nameController),
              buildTextField("Description", descriptionController),
              buildTextField("Category", categoryController),
              buildTextField("Difficulty", difficultyController),

              buildTextField("Steps", stepsController),
              buildTextField("Ingredients", ingredientsController),

              const SizedBox(height: 10),
              const Text("Image", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white),
                  ),
                  child: _image != null
                      ? Image.file(_image!, fit: BoxFit.cover)
                      : const Center(
                    child: Text(
                      "Tap to select image",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = FirebaseAuth.instance.currentUser;

                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Veuillez vous connecter")),
                      );
                      return;
                    }

                    try {
                      // Sauvegarde dans Firestore avec la nouvelle fonction
                      await widget.firestoreService.addRecette(
                        userId: user.uid,
                        name: nameController.text,
                        description: descriptionController.text,
                        category: categoryController.text,
                        difficulty: difficultyController.text,

                        ingredients: ingredientsController.text
                            .split(',')
                            .map((e) => e.trim())
                            .toList(),
                        steps: stepsController.text
                            .split(',')
                            .map((e) => e.trim())
                            .toList(),
                        imageUrl: _image?.path ?? '',
                      );

                      // Nettoyer les champs
                      nameController.clear();
                      descriptionController.clear();
                      categoryController.clear();
                      difficultyController.clear();

                      stepsController.clear();
                      ingredientsController.clear();
                      setState(() {
                        _image = null;
                      });

                      // Redirection vers la liste des recettes
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Recettespage(user: user),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Erreur: $e")),
                      );
                    }
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.white10,
        ),
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter a text';
          }
          return null;
        },
      ),
    );
  }
}
