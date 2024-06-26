import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addCateg(name, pharmacy) async {
  final docUser = FirebaseFirestore.instance.collection('Categs').doc();

  final json = {
    'name': name,
    'id': docUser.id,
    'pharmacy': pharmacy,
    'dateTime': DateTime.now(),
  };

  await docUser.set(json);
}
