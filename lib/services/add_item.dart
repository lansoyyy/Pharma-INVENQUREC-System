import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addItem(name, categ, desc, code, unit, expirationDate, img) async {
  final docUser = FirebaseFirestore.instance.collection('Items').doc();

  final json = {
    'name': name,
    'categ': categ,
    'desc': desc,
    'code': code,
    'unit': unit,
    'expirationDate': expirationDate,
    'img': img,
    'id': docUser.id,
    'dateTime': DateTime.now(),
    'qty': 0,
  };

  await docUser.set(json);
}
