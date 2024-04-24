import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharma_invenqurec/services/add_item.dart';
import 'package:pharma_invenqurec/utlis/colors.dart';
import 'package:pharma_invenqurec/widgets/button_widget.dart';
import 'package:pharma_invenqurec/widgets/text_widget.dart';
import 'package:pharma_invenqurec/widgets/textfield_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:pharma_invenqurec/widgets/toast_widget.dart';

class AddItemScreen extends StatefulWidget {
  bool inAdmin;

  AddItemScreen({super.key, required this.inAdmin});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final name = TextEditingController();
  final categ = TextEditingController();
  final desc = TextEditingController();
  final code = TextEditingController();
  final unit = TextEditingController();
  final date = TextEditingController();

  late String fileName = '';

  late File imageFile;

  late String imageURL = '';
  String _selectedItem = '';
  Random random = Random();
  int min = 100000; // Minimum 6-digit number
  int max = 999999; // Maximum 6-digit number

  Future<void> uploadPicture(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Row(
              children: [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Loading . . .',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QRegular'),
                ),
              ],
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref('Items/$fileName')
            .putFile(imageFile);
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref('Items/$fileName')
            .getDownloadURL();

        setState(() {});

        Navigator.of(context).pop();
        showToast('Image uploaded!');
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (code.text == '') {
      code.text = '${min + random.nextInt(max - min)}';
    }
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: TextWidget(
            text: '',
            fontSize: 18,
            color: Colors.black,
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: widget.inAdmin
                ? FirebaseFirestore.instance
                    .collection('Admins')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              dynamic data = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Icon(
                      Icons.image,
                      size: 75,
                      color: primary,
                    ),
                    TextButton(
                      onPressed: () {
                        uploadPicture('gallery');
                      },
                      child: TextWidget(
                        text: 'Add Photo',
                        fontSize: 14,
                        color: primary,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldWidget(
                      borderColor: primary,
                      controller: name,
                      label: 'Item Name',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 45, right: 45, top: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Category',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Bold',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Bold',
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Categs')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                  return const Center(child: Text('Error'));
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 50),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.black,
                                    )),
                                  );
                                }

                                final data = snapshot.requireData;
                                if (_selectedItem == '') {
                                  _selectedItem = data.docs.first['name'];
                                }
                                return Center(
                                    child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: primary,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SizedBox(
                                    width: 325,
                                    height: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: DropdownButton<String>(
                                        underline: const SizedBox(),
                                        value: _selectedItem,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _selectedItem = value!;
                                          });
                                        },
                                        items: <String>[
                                          for (int i = 0;
                                              i < data.docs.length;
                                              i++)
                                            data.docs[i]['name'],
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ));
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                      borderColor: primary,
                      controller: desc,
                      label: 'Shelf Description',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 150,
                          child: TextFieldWidget(
                            borderColor: primary,
                            isEnabled: false,
                            controller: code,
                            label: 'Code #',
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: TextFieldWidget(
                            borderColor: primary,
                            controller: unit,
                            label: 'Packaging Unit',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Expiration Date',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Bold',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Bold',
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              dateFromPicker(context);
                            },
                            child: SizedBox(
                              width: 325,
                              height: 50,
                              child: TextFormField(
                                enabled: false,
                                style: TextStyle(
                                  fontFamily: 'Regular',
                                  fontSize: 14,
                                  color: primary,
                                ),

                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.calendar_month_outlined,
                                    color: primary,
                                  ),
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  hintText: date.text,
                                  border: InputBorder.none,
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: primary,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: primary,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: primary,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorStyle: const TextStyle(
                                      fontFamily: 'Bold', fontSize: 12),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),

                                controller: date,
                                // Pass the validator to the TextFormField
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonWidget(
                      radius: 100,
                      color: primary,
                      label: 'Save Item',
                      onPressed: () {
                        addItem(
                            name.text,
                            _selectedItem,
                            desc.text,
                            min + random.nextInt(max - min),
                            unit.text,
                            date.text,
                            imageURL,
                            data['pharmacy']);
                        showToast('Item added succesfully!');
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }));
  }

  void dateFromPicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primary,
                onPrimary: Colors.white,
                onSurface: Colors.grey,
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2030));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      setState(() {
        date.text = formattedDate;
      });
    } else {
      return null;
    }
  }
}
