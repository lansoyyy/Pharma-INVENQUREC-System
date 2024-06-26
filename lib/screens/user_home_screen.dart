import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharma_invenqurec/screens/add_item_screen.dart';
import 'package:pharma_invenqurec/screens/item_screen.dart';
import 'package:pharma_invenqurec/screens/user_notif_screen.dart';
import 'package:pharma_invenqurec/utlis/colors.dart';
import 'package:pharma_invenqurec/widgets/text_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io' as io;
import 'package:pdf/pdf.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final searchController = TextEditingController();
  String nameSearched = '';

  String qrCode = 'Unknown';
  String id = '';

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
      });

      await FirebaseFirestore.instance
          .collection('Items')
          .doc(qrCode)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          setState(() {
            id = documentSnapshot['id'];
          });
        }
      }).whenComplete(() => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ItemScreen(
                    id: id,
                  ))));
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }

  final categ = TextEditingController();

  String selectedCateg = '';

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: userData,
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
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          scanQRCode();
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => ItemScreen(
                          //           id: '',
                          //         )));
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
                        decoration: BoxDecoration(
                            color: primary, shape: BoxShape.circle),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddItemScreen(
                                      inAdmin: false,
                                    )));
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
                  selectedCateg != ''
                      ? tableWidget()
                      : Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Categs')
                                  .where('pharmacy',
                                      isEqualTo: data['pharmacy'])
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
                                        onTap: () {
                                          setState(() {
                                            selectedCateg =
                                                data.docs[index]['name'];
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
                ],
              ),
            );
          }),
    );
  }

  Widget tableWidget() {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Items')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where('name',
                    isGreaterThanOrEqualTo:
                        toBeginningOfSentenceCase(nameSearched))
                .where('name',
                    isLessThan: '${toBeginningOfSentenceCase(nameSearched)}z')
                .where('categ', isEqualTo: selectedCateg)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedCateg = '';
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        generatePdf(data.docs);
                      },
                      icon: const Icon(
                        Icons.save,
                      ),
                    ),
                  ],
                ),
              );
            }),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Items')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                        data.docs[i]['qty'] < 5
                            ? Badge(
                                label: TextWidget(
                                  text: 'Low qty',
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                                child: TextWidget(
                                  text: data.docs[i]['name'],
                                  fontSize: 14,
                                ),
                              )
                            : TextWidget(
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
                    ])
                ]);
              }),
        ),
      ],
    );
  }

  void generatePdf(List tableDataList) async {
    final pdf = pw.Document();
    final tableHeaders = [
      'Item Name',
      'Packaging Unit',
      'Category',
      'Qty',
    ];

    List<List<String>> tableData = [];
    for (var i = 0; i < tableDataList.length; i++) {
      tableData.add([
        tableDataList[i]['name'],
        tableDataList[i]['unit'],
        tableDataList[i]['categ'],
        tableDataList[i]['qty'].toString(),
      ]);
    }

    pdf.addPage(
      pw.MultiPage(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        pageFormat: PdfPageFormat.letter,
        orientation: pw.PageOrientation.portrait,
        build: (context) => [
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('PHARMA - Invenqurec',
                    style: const pw.TextStyle(
                      fontSize: 18,
                    )),
                pw.SizedBox(height: 10),
                pw.Text(
                  style: const pw.TextStyle(
                    fontSize: 15,
                  ),
                  'Medicine List',
                ),
                pw.SizedBox(height: 5),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: tableHeaders,
            data: tableData,
            headerDecoration: const pw.BoxDecoration(),
            rowDecoration: const pw.BoxDecoration(),
            headerHeight: 25,
            cellHeight: 45,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
            },
          ),
          pw.SizedBox(height: 20),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());

    final output = await getTemporaryDirectory();
    final file = io.File("${output.path}/payroll_report.pdf");
    await file.writeAsBytes(await pdf.save());
  }
}
