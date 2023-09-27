import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/authentication_bloc.dart';
import '../cubit/signup_cubit.dart';
import 'signup_view.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(
        repository: context.read<AuthenticationBloc>().repository,
      ),
      child: const SignUpView(),
    );
  }
}
