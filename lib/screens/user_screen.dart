import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharma_invenqurec/screens/add_user_screen.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import '../utlis/colors.dart';
import '../widgets/text_widget.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final searchController = TextEditingController();
  String nameSearched = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: TextWidget(
          text: 'User Management',
          fontSize: 18,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(100)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Regular',
                          fontSize: 14),
                      onChanged: (value) {
                        setState(() {
                          nameSearched = value;
                        });
                      },
                      decoration: const InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: 'Search',
                          hintStyle: TextStyle(fontFamily: 'QRegular'),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          )),
                      controller: searchController,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  decoration:
                      BoxDecoration(color: primary, shape: BoxShape.circle),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddUserScreen()));
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .where('name',
                        isGreaterThanOrEqualTo:
                            toBeginningOfSentenceCase(nameSearched))
                    .where('name',
                        isLessThan:
                            '${toBeginningOfSentenceCase(nameSearched)}z')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(child: Text('Error'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                      )),
                    );
                  }

                  final data = snapshot.requireData;
                  return DataTable(columns: [
                    DataColumn(
                      label: TextWidget(
                        text: 'Image',
                        fontSize: 18,
                        fontFamily: 'Bold',
                      ),
                    ),
                    DataColumn(
                      label: TextWidget(
                        text: 'Name',
                        fontSize: 18,
                        fontFamily: 'Bold',
                      ),
                    ),
                    DataColumn(
                      label: TextWidget(
                        text: 'Actions',
                        fontSize: 18,
                        fontFamily: 'Bold',
                      ),
                    ),
                  ], rows: [
                    for (int i = 0; i < data.docs.length; i++)
                      DataRow(cells: [
                        DataCell(Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: 50,
                            height: 75,
                            decoration: const BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        )),
                        DataCell(
                          TextWidget(
                            text: data.docs[i]['name'],
                            fontSize: 14,
                          ),
                        ),
                        DataCell(
                          TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(data.docs[i].id)
                                  .delete();
                            },
                            child: TextWidget(
                              text: 'Delete',
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ])
                  ]);
                }),
          ],
        ),
      ),
    );
  }
}
