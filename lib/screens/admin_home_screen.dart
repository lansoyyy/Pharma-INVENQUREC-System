import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharma_invenqurec/screens/add_item_screen.dart';
import 'package:pharma_invenqurec/screens/item_screen.dart';
import 'package:pharma_invenqurec/screens/user_screen.dart';
import 'package:pharma_invenqurec/services/add_categ.dart';
import 'package:pharma_invenqurec/utlis/colors.dart';
import 'package:pharma_invenqurec/widgets/text_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import 'package:pharma_invenqurec/widgets/textfield_widget.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final searchController = TextEditingController();

  String nameSearched = '';
  final categ = TextEditingController();

  String selectedCateg = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UsersScreen()));
                  },
                  icon: Icon(
                    Icons.account_circle,
                    color: primary,
                  ),
                ),
                TextWidget(
                  text: 'Inventory',
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'Bold',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddItemScreen()));
                  },
                  icon: Icon(
                    Icons.add,
                    color: primary,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
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
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: TextWidget(
                              text: 'Adding category',
                              fontSize: 18,
                              fontFamily: 'Bold',
                            ),
                            content: SizedBox(
                              height: 75,
                              child: TextFieldWidget(
                                controller: categ,
                                label: 'Category Name',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: TextWidget(
                                  text: 'Close',
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  addCateg(categ.text);
                                  Navigator.pop(context);
                                },
                                child: TextWidget(
                                  text: 'Add',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.category_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            selectedCateg != ''
                ? tableWidget()
                : Expanded(
                    child: StreamBuilder<QuerySnapshot>(
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
                          return GridView.builder(
                            itemCount: data.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onDoubleTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return ListTile(
                                          onTap: () async {
                                            await FirebaseFirestore.instance
                                                .collection('Categs')
                                                .doc(data.docs[index].id)
                                                .delete();
                                            Navigator.pop(context);
                                          },
                                          leading: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                          ),
                                          title: TextWidget(
                                              text: 'Delete category',
                                              fontSize: 14),
                                        );
                                      },
                                    );
                                  },
                                  onTap: () {
                                    setState(() {
                                      selectedCateg = data.docs[index]['name'];
                                    });
                                  },
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.folder_copy_outlined,
                                          size: 50,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextWidget(
                                          text: data.docs[index]['name'],
                                          fontSize: 13,
                                          fontFamily: 'Bold',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                  ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget tableWidget() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              setState(() {
                selectedCateg = '';
              });
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Items')
                  .where('name',
                      isGreaterThanOrEqualTo:
                          toBeginningOfSentenceCase(nameSearched))
                  .where('name',
                      isLessThan: '${toBeginningOfSentenceCase(nameSearched)}z')
                  .where('categ', isEqualTo: selectedCateg)
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
                      text: 'Item Name',
                      fontSize: 18,
                      fontFamily: 'Bold',
                    ),
                  ),
                  DataColumn(
                    label: TextWidget(
                      text: 'Packaging Unit',
                      fontSize: 18,
                      fontFamily: 'Bold',
                    ),
                  ),
                  DataColumn(
                    label: TextWidget(
                      text: 'Category',
                      fontSize: 18,
                      fontFamily: 'Bold',
                    ),
                  ),
                  DataColumn(
                    label: TextWidget(
                      text: 'Quantity',
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
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  data.docs[i]['img'],
                                ),
                                fit: BoxFit.cover),
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
                        TextWidget(
                          text: data.docs[i]['unit'],
                          fontSize: 14,
                        ),
                      ),
                      DataCell(
                        TextWidget(
                          text: data.docs[i]['categ'],
                          fontSize: 14,
                        ),
                      ),
                      DataCell(
                        TextWidget(
                          text: '${data.docs[i]['qty']}',
                          fontSize: 14,
                        ),
                      ),
                      DataCell(
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ItemScreen(
                                      id: data.docs[i].id,
                                    )));
                          },
                          child: TextWidget(
                            text: 'Edit',
                            color: primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ])
                ]);
              }),
        ),
      ],
    );
  }
}
