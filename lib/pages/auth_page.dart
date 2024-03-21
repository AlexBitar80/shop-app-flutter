import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5),
                  Color.fromRGBO(255, 188, 117, 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              // physics: const ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  SvgPicture.asset(
                    'assets/images/logo-shop.svg',
                    width: 180,
                    height: 180,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: AuthForm(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
