import 'package:flutter/material.dart';
import 'package:pharma_invenqurec/widgets/text_widget.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: TextWidget(
          text: '',
          fontSize: 18,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(
              Icons.notifications,
            ),
            title: TextWidget(
              text: 'Notification type here',
              fontSize: 18,
              fontFamily: 'Bold',
            ),
            trailing: TextWidget(text: 'January 01, 2023', fontSize: 12),
          );
        },
      ),
    );
  }
}
