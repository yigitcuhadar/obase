import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/authentication_bloc.dart';
import '../cubit/login_cubit.dart';
import 'login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        repository: context.read<AuthenticationBloc>().repository,
      ),
      child: const LoginView(),
    );
  }
}
