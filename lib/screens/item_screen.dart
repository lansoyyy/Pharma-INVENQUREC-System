import 'package:flutter/material.dart';
import 'package:pharma_invenqurec/widgets/button_widget.dart';
import 'package:pharma_invenqurec/widgets/text_widget.dart';

import '../utlis/colors.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  int qty = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
              color: primary,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: TextWidget(
              text: 'Sample',
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
                      label: 'Pain Relief Medications',
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
                      label: 'Top Shelf,  Section 1',
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
                      label: ' 987654321',
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
                      label: 'Bottle',
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
                      label: '2024-06-30',
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
                      label: '$qty',
                      onPressed: () {},
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () {
                          if (qty > 1) {
                            setState(() {
                              qty--;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.remove,
                          color: primary,
                        )),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            qty++;
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          color: primary,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
