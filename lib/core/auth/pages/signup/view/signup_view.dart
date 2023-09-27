import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:obase_barcode/core/extensions/context_extension.dart';
import 'package:obase_barcode/core/extensions/error_extension.dart';
import 'package:obase_barcode/core/extensions/form_extension.dart';
import 'package:obase_barcode/core/lang/locale_keys.g.dart';
import '../../../../../company/bloc/company_bloc.dart';
import '../../../../../company/model/company.dart';
import '../../../../constants/app_contants.dart';
import '../../login/view/login_page.dart';
import '../cubit/signup_cubit.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (p, c) => c.error != null && c.status.isFailure && c.status != p.status,
      listener: (context, state) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!.errorText)));
      },
      child: const _SignupForm(),
    );
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.signup_title.locale),
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
                  _CompanyDropdownButton(),
                  AppConstants.itemSeperator,
                  _EmailFormField(),
                  AppConstants.itemSeperator,
                  _PasswordFormField(),
                  AppConstants.itemSeperator,
                  _ConfirmedPasswordFormField(),
                  AppConstants.itemSeperator,
                  _SubmitButton(),
                  AppConstants.itemSeperator,
                  _LoginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompanyDropdownButton extends StatelessWidget {
  const _CompanyDropdownButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (p, c) => p.status.isInProgress || c.status.isInProgress,
      builder: (context, state) {
        return BlocBuilder<CompanyBloc, CompanyState>(
          buildWhen: (p, c) => p.company != c.company,
          builder: (context, state2) {
            return DropdownButton<Company>(
              value: state2.company,
              items: Company.companies.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
              onChanged: !state.status.isInProgress
                  ? (value) => context.read<CompanyBloc>().add(CompanyChangedEvent(company: value!))
                  : null,
            );
          },
        );
      },
    );
  }
}

class _EmailFormField extends StatelessWidget {
  const _EmailFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (p, c) => p.status.isInProgress || c.status.isInProgress || p.emailForm != c.emailForm,
      builder: (context, state) {
        return TextField(
          onChanged: (value) => context.read<SignupCubit>().onEmailChanged(value),
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
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (p, c) => p.status.isInProgress || c.status.isInProgress || p.passwordForm != c.passwordForm,
      builder: (context, state) {
        return TextField(
          onChanged: (value) => context.read<SignupCubit>().onPasswordChanged(value),
          decoration: InputDecoration(
            icon: const Icon(Icons.lock_outline),
            labelText: LocaleKeys.form_password_label.locale,
            errorText: state.passwordForm.errorText,
            errorMaxLines: 2,
          ),
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          obscureText: true,
          enabled: !state.status.isInProgress,
        );
      },
    );
  }
}

class _ConfirmedPasswordFormField extends StatelessWidget {
  const _ConfirmedPasswordFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (p, c) =>
          p.status.isInProgress ||
          c.status.isInProgress ||
          p.passwordForm != c.passwordForm ||
          p.confirmedPasswordForm != c.confirmedPasswordForm,
      builder: (context, state) {
        return TextField(
          onChanged: (value) => context.read<SignupCubit>().onConfirmedPasswordChanged(value),
          decoration: InputDecoration(
            icon: const Icon(Icons.lock_outline),
            labelText: LocaleKeys.form_confirmed_password_label.locale,
            errorText: state.confirmedPasswordForm.errorText,
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
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (p, c) => p.status.isInProgress || c.status.isInProgress || p.isValid != c.isValid,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: !state.status.isInProgress && state.isValid ? () => context.read<SignupCubit>().onSubmitted() : null,
          child: !state.status.isInProgress ? Text(LocaleKeys.signup_submit_button.locale) : AppConstants.smallCPI,
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (p, c) => p.status.isInProgress || c.status.isInProgress,
      builder: (context, state) {
        return TextButton(
          onPressed: !state.status.isInProgress
              ? () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()))
              : null,
          child: Text(LocaleKeys.signup_login_button.locale),
        );
      },
    );
  }
}
