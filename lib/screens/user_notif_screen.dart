import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharma_invenqurec/widgets/text_widget.dart';

class UserNotifScreen extends StatelessWidget {
  const UserNotifScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: TextWidget(
          text: 'Notifications',
          fontSize: 18,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Items').snapshots(),
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
            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                return DateTime.now().isAfter(
                        DateTime.parse(data.docs[index]['expirationDate']))
                    ? ListTile(
                        leading: const Icon(
                          Icons.notifications,
                        ),
                        title: TextWidget(
                          text:
                              '${data.docs[index]['name']} expires on   ${DateFormat('dd/MM/yyyy').format(DateTime.parse(data.docs[index]['expirationDate']))}',
                          fontSize: 14,
                          fontFamily: 'Bold',
                        ),
                      )
                    : const SizedBox();
              },
            );
          }),
    );
  }
}
