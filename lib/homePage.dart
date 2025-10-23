import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Pages/recettes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String message = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Fonction de connexion Firebase
  void signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),//trim pour eviter l ep avt et aprés
        password: passwordController.text.trim(),
      );

      setState(() {
        message = "Connecté : ${userCredential.user?.email}";
      });

      // Naviguer vers la page des recettes après connexion réussie
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Recettespage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        message = "Erreur : ${e.message}";//errur besm el user
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Recettespage()),
                    );
                  },
                  child: Image.asset(
                    "assets/images/imagerec.jpg",
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Login to your account",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white10,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                ),
              ),
              const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            try {
              UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );

              setState(() {
                message = "Connecté : ${userCredential.user?.email}";
              });

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Recettespage(user: userCredential.user),
                ),
              );
            } on FirebaseAuthException catch (e) {
              setState(() {
                message = "Erreur : ${e.message}";
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
          ),
          child: const Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),

              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(color: Colors.white),//si il a esst  connecté ou nn
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't Have An Account ? ",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: "Register",
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
