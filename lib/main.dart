import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:ob_auth/ob_auth.dart';
import 'package:ob_product/ob_product.dart';
import 'package:obase_barcode/core/constants/app_contants.dart';
import 'package:obase_barcode/company/bloc/company_bloc.dart';
import 'package:obase_barcode/company/model/company.dart';
import 'package:obase_barcode/core/lang/lang_manager.dart';
import 'package:obase_barcode/firebase_options.dart';
import 'package:obase_barcode/products/cubit/products_cubit.dart';
import 'package:obase_barcode/products/pages/stocktaking/cubit/stocktaking_cubit.dart';
import 'package:path_provider/path_provider.dart';

import 'core/auth/bloc/authentication_bloc.dart';
import 'core/auth/pages/authentication/view/authentication_page.dart';
import 'home/view/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getTemporaryDirectory(),
  );

  runApp(
    EasyLocalization(
      supportedLocales: LangManager.instance.supportedLocales,
      path: AppConstants.pathLocale,
      fallbackLocale: LangManager.instance.fallbackLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = AuthenticationBloc(repository: FirebaseAuthRepository());
    final companyBloc = CompanyBloc();
    final productsCubit = ProductsCubit(repository: SqlfliteProductRepository())..requestProducts();
    final stocktakingCubit = StocktakingCubit(productsCubit: productsCubit);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => authBloc),
        BlocProvider(create: (context) => companyBloc),
        BlocProvider.value(value: productsCubit),
        BlocProvider(create: (context) => stocktakingCubit),
      ],
      child: BlocBuilder<CompanyBloc, CompanyState>(
        builder: (context, state) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            title: 'Material App',
            home: const MyHome(),
            theme: ThemeData(primarySwatch: state.company.primaryColor.toColor().toMaterialColor()),
          );
        },
      ),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previous, current) => previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        Navigator.maybePop(context);
      },
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return const HomePage();
        } else {
          return const AuthenticationPage();
        }
      },
    );
  }
}
