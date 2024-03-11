import 'package:flutter/material.dart';
import 'package:pharma_invenqurec/screens/admin_home_screen.dart';
import 'package:pharma_invenqurec/utlis/colors.dart';
import 'package:pharma_invenqurec/widgets/button_widget.dart';
import 'package:pharma_invenqurec/widgets/text_widget.dart';
import 'package:pharma_invenqurec/widgets/textfield_widget.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Image.asset(
                'assets/images/text.png',
                width: 250,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 150,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    align: TextAlign.start,
                    text: 'Enter details below to\ncreate an account',
                    fontSize: 18,
                    fontFamily: 'Medium',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: TextFieldWidget(
                borderColor: primary,
                controller: name,
                label: 'Name',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: TextFieldWidget(
                borderColor: primary,
                controller: email,
                label: 'Email',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: TextFieldWidget(
                borderColor: primary,
                controller: password,
                label: 'Password',
                isObscure: true,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: ButtonWidget(
                radius: 100,
                width: 300,
                color: primary,
                label: 'Create',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AdminHomeScreen()));
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
