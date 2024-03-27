import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharma_invenqurec/widgets/button_widget.dart';
import 'package:pharma_invenqurec/widgets/text_widget.dart';
import 'package:pharma_invenqurec/widgets/toast_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../utlis/colors.dart';

class ItemScreen extends StatefulWidget {
  String id;

  ItemScreen({super.key, required this.id});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  int qty = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Items')
              .doc(widget.id)
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
            return SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: primary,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    width: 125,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            data['img'],
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: TextWidget(
                    text: data['name'],
                    fontSize: 18,
                    fontFamily: 'Bold',
                    color: primary,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: 'Category:',
                            fontSize: 14,
                            fontFamily: 'Bold',
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 100,
                          ),
                          ButtonWidget(
                            width: 125,
                            radius: 100,
                            height: 35,
                            fontSize: 14,
                            color: primary,
                            label: data['categ'],
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: 'Shelf Description:',
                            fontSize: 14,
                            fontFamily: 'Bold',
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          ButtonWidget(
                            width: 125,
                            radius: 100,
                            height: 35,
                            fontSize: 14,
                            color: primary,
                            label: data['desc'],
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: 'Code #:',
                            fontSize: 14,
                            fontFamily: 'Bold',
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 115,
                          ),
                          ButtonWidget(
                            width: 125,
                            radius: 100,
                            height: 35,
                            fontSize: 14,
                            color: primary,
                            label: data['code'].toString(),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: 'Packaging Unit:',
                            fontSize: 14,
                            fontFamily: 'Bold',
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 70,
                          ),
                          ButtonWidget(
                            width: 125,
                            radius: 100,
                            height: 35,
                            fontSize: 14,
                            color: primary,
                            label: data['unit'],
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: 'Expiration Date:',
                            fontSize: 14,
                            fontFamily: 'Bold',
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 70,
                          ),
                          ButtonWidget(
                            width: 125,
                            radius: 100,
                            height: 35,
                            fontSize: 14,
                            color: primary,
                            label: data['expirationDate'],
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: 'Quantity:',
                            fontSize: 14,
                            fontFamily: 'Bold',
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 70,
                          ),
                          ButtonWidget(
                            width: 125,
                            radius: 100,
                            height: 35,
                            fontSize: 14,
                            color: primary,
                            label: '${data['qty']}',
                            onPressed: () {},
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              onPressed: () async {
                                if (data['qty'] > 1) {
                                  await FirebaseFirestore.instance
                                      .collection('Items')
                                      .doc(widget.id)
                                      .update(
                                          {'qty': FieldValue.increment(-1)});
                                }
                              },
                              icon: Icon(
                                Icons.remove,
                                color: primary,
                              )),
                          IconButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('Items')
                                    .doc(widget.id)
                                    .update({'qty': FieldValue.increment(1)});
                              },
                              icon: Icon(
                                Icons.add,
                                color: primary,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ButtonWidget(
                        radius: 100,
                        color: primary,
                        label: 'Generate QR',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  title: TextWidget(
                                      text: 'Your QR Code',
                                      fontSize: 18,
                                      color: Colors.black),
                                  content: SizedBox(
                                    height: 300,
                                    width: 300,
                                    child: QrImageView(
                                      data: data['id'],
                                      version: QrVersions.auto,
                                      size: 200.0,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: (() {
                                          Navigator.pop(context);
                                        }),
                                        child: TextWidget(
                                            text: 'Close',
                                            fontSize: 14,
                                            color: Colors.black)),
                                    TextButton(
                                        onPressed: (() {
                                          showToast(
                                              'This feature is under development!');
                                          Navigator.pop(context);
                                        }),
                                        child: TextWidget(
                                            text: 'Print QR',
                                            fontSize: 14,
                                            color: Colors.black)),
                                  ],
                                );
                              }));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ));
          }),
    );
  }
}
