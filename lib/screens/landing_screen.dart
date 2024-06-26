import 'package:flutter/material.dart';
import 'package:pharma_invenqurec/screens/admin_login_screen.dart';
import 'package:pharma_invenqurec/screens/user_login_screen.dart';
import 'package:pharma_invenqurec/widgets/button_widget.dart';
import 'package:pharma_invenqurec/widgets/text_widget.dart';

import '../utlis/colors.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/Rectangle 2.png',
              ),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'Pharma-',
                  fontSize: 18,
                  fontFamily: 'Medium',
                  color: Colors.white,
                ),
                TextWidget(
                  text: 'INVENQUREC',
                  fontSize: 38,
                  fontFamily: 'Bold',
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonWidget(
                  color: primary,
                  width: 175,
                  radius: 100,
                  fontSize: 12,
                  label: 'Continue as Technician',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UserLoginScreen()));
                  },
                ),
                ButtonWidget(
                  color: primary,
                  width: 175,
                  radius: 100,
                  fontSize: 12,
                  label: 'Continue as Admin',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AdminLoginScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
