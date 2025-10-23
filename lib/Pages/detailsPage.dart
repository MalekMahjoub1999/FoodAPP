// // lib/Pages/details_page.dart
//
// import 'package:flutter/material.dart';
//
// class DetailsPage extends StatefulWidget {
//   final Map<String, dynamic> recette;
//
//   const DetailsPage({super.key, required this.recette});
//
//   @override
//   State<DetailsPage> createState() => _DetailsPageState();
// }
//
// class _DetailsPageState extends State<DetailsPage> {
//   @override
//   Widget build(BuildContext context) {
//     final recette = widget.recette;
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text("Details Page"),
//         actions: <Widget>[
//           IconButton(
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Recette is deleted")),
//               );
//             },
//             icon: const Icon(Icons.delete),
//             tooltip: 'Show Snackbar',
//           )
//         ],
//       ),
//       body: Center(
//         child: Text(
//           'Recette: ${recette['name']}',
//           style: const TextStyle(color: Colors.white, fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
