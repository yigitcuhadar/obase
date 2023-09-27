import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/auth/pages/account/view/account_page.dart';
import '../../core/extensions/context_extension.dart';
import '../../../products/pages/all_products/view/all_products_page.dart';
import '../../../products/pages/stocktaking/view/stocktaking_page.dart';
import '../../core/lang/locale_keys.g.dart';
import '../bloc/home_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const HomeView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const List<PreferredSizeWidget?> appBars = [
      AllProductsAppBar(),
      StocktakingAppBar(),
      AccountAppBar(),
    ];
    const List<Widget> bodies = [
      AllProductBody(),
      StocktakingBody(),
      AccountBody(),
    ];
    List<BottomNavigationBarItem> navBarItems = [
      BottomNavigationBarItem(icon: const Icon(Icons.category), label: LocaleKeys.home_navigation_all_products.locale),
      BottomNavigationBarItem(icon: const Icon(Icons.inventory), label: LocaleKeys.home_navigation_stocktaking.locale),
      BottomNavigationBarItem(icon: const Icon(Icons.account_circle), label: LocaleKeys.home_navigation_account.locale),
    ];
    const List<Widget?> floatingActionButtons = [
      AllProductsFAB(),
      StocktakingFAB(),
      null,
    ];
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: appBars[state.tabIndex],
          body: SafeArea(
            child: bodies[state.tabIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: navBarItems,
            currentIndex: state.tabIndex,
            onTap: (index) {
              context.read<HomeBloc>().add(HomeTabChangedEvent(newTabIndex: index));
            },
          ),
          floatingActionButton: floatingActionButtons[state.tabIndex],
        );
      },
    );
  }
}
