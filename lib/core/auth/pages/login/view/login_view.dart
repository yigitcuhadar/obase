import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:obase_barcode/core/extensions/context_extension.dart';
import 'package:obase_barcode/core/extensions/error_extension.dart';
import 'package:obase_barcode/core/extensions/form_extension.dart';
import 'package:obase_barcode/core/lang/locale_keys.g.dart';

import '../../../../constants/app_contants.dart';
import '../../signup/view/signup_page.dart';
import '../cubit/login_cubit.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (p, c) => c.error != null && c.status.isFailure && c.status != p.status,
      listener: (context, state) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!.errorText)));
      },
      child: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.login_title.locale),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: const SingleChildScrollView(
              padding: AppConstants.pagePadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _EmailFormField(),
                  AppConstants.itemSeperator,
                  _PasswordFormField(),
                  AppConstants.itemSeperator,
                  _SubmitButton(),
                  AppConstants.itemSeperator,
                  _SignupButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailFormField extends StatelessWidget {
  const _EmailFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (p, c) => p.status.isInProgress || c.status.isInProgress || p.emailForm != c.emailForm,
      builder: (context, state) {
        return TextField(
          onChanged: (value) => context.read<LoginCubit>().onEmailChanged(value),
          decoration: InputDecoration(
            icon: const Icon(Icons.email_outlined),
            labelText: LocaleKeys.form_email_label.locale,
            errorText: state.emailForm.errorText,
            errorMaxLines: 2,
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          enabled: !state.status.isInProgress,
        );
      },
    );
  }
}

class _PasswordFormField extends StatelessWidget {
  const _PasswordFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (p, c) => p.status.isInProgress || c.status.isInProgress || p.passwordForm != c.passwordForm,
      builder: (context, state) {
        return TextField(
          onChanged: (value) => context.read<LoginCubit>().onPasswordChanged(value),
          decoration: InputDecoration(
            icon: const Icon(Icons.lock_outline),
            labelText: LocaleKeys.form_password_label.locale,
            errorText: state.passwordForm.errorText,
            errorMaxLines: 2,
          ),
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          obscureText: true,
          enabled: !state.status.isInProgress,
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (p, c) => p.status.isInProgress || c.status.isInProgress || p.isValid != c.isValid,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: !state.status.isInProgress && state.isValid ? () => context.read<LoginCubit>().onSubmitted() : null,
          child: !state.status.isInProgress ? Text(LocaleKeys.login_submit_button.locale) : AppConstants.smallCPI,
        );
      },
    );
  }
}

class _SignupButton extends StatelessWidget {
  const _SignupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (p, c) => p.status.isInProgress || c.status.isInProgress,
      builder: (context, state) {
        return TextButton(
          onPressed: !state.status.isInProgress
              ? () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignupPage()))
              : null,
          child: Text(LocaleKeys.login_signup_button.locale),
        );
      },
    );
  }
}
