import 'package:flutter/material.dart';
import 'package:obase_barcode/core/extensions/context_extension.dart';
import 'package:obase_barcode/core/lang/locale_keys.g.dart';

import '../../../../constants/app_contants.dart';
import '../../login/view/login_page.dart';
import '../../signup/view/signup_page.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.authentication_title.locale),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: Padding(
          padding: AppConstants.pagePadding,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LoginButton(),
                AppConstants.itemSeperator,
                _SignupButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage())),
      child: Text(LocaleKeys.authentication_login_button.locale),
    );
  }
}

class _SignupButton extends StatelessWidget {
  const _SignupButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignupPage())),
      child: Text(LocaleKeys.authentication_signup_button.locale),
    );
  }
}
