import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addAdmin(name, id, email, pharmacy) async {
  final docUser = FirebaseFirestore.instance.collection('Admins').doc(id);

  final json = {
    'pharmacy': pharmacy,
    'name': name,
    'email': email,
    'id': docUser.id,
  };

  await docUser.set(json);
}
