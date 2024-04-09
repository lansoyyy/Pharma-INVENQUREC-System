import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addCateg(name) async {
  final docUser = FirebaseFirestore.instance.collection('Categs').doc();

  final json = {
    'name': name,
    'id': docUser.id,
    'dateTime': DateTime.now(),
  };

  await docUser.set(json);
}
