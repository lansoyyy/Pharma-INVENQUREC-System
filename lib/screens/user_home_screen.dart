import 'package:flutter/material.dart';
import 'package:pharma_invenqurec/screens/add_item_screen.dart';
import 'package:pharma_invenqurec/screens/item_screen.dart';
import 'package:pharma_invenqurec/screens/user_notif_screen.dart';
import 'package:pharma_invenqurec/utlis/colors.dart';
import 'package:pharma_invenqurec/widgets/text_widget.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final searchController = TextEditingController();
  String nameSearched = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                          builder: (context) => ItemScreen(
                                id: '',
                              )));
                    },
                    icon: Icon(
                      Icons.qr_code,
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
                          builder: (context) => const UserNotifScreen()));
                    },
                    icon: Icon(
                      Icons.notifications,
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddItemScreen()));
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(columns: [
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
                ], rows: [
                  for (int i = 0; i < 50; i++)
                    DataRow(cells: [
                      DataCell(Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 50,
                          height: 75,
                          color: Colors.black,
                        ),
                      )),
                      DataCell(
                        TextWidget(
                          text: 'Sample',
                          fontSize: 14,
                        ),
                      ),
                      DataCell(
                        TextWidget(
                          text: 'Sample',
                          fontSize: 14,
                        ),
                      ),
                      DataCell(
                        TextWidget(
                          text: 'Sample',
                          fontSize: 14,
                        ),
                      ),
                      DataCell(
                        TextWidget(
                          text: 'Sample',
                          fontSize: 14,
                        ),
                      ),
                    ])
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
