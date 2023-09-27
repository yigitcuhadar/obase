import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obase_barcode/core/constants/app_contants.dart';
import 'package:obase_barcode/core/extensions/context_extension.dart';
import 'package:obase_barcode/core/lang/locale_keys.g.dart';

import '../../../../lang/lang_manager.dart';
import '../../../bloc/authentication_bloc.dart';

class AccountAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AccountAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(LocaleKeys.account_title.locale),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AccountBody extends StatelessWidget {
  const AccountBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: AppConstants.pagePadding,
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Text(LocaleKeys.account_settings_lang.locale),
                      const SizedBox(width: 10),
                      DropdownButton<Locale>(
                        items: LangManager.instance.supportedLocales
                            .map(
                              (locale) => DropdownMenuItem(
                                value: locale,
                                child: Text(locale.languageCode.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (locale) => context.setLocale(locale!),
                        value: context.locale,
                      ),
                    ],
                  ),
                  leading: const Icon(Icons.language),
                ),
                ListTile(
                  title: Text(LocaleKeys.account_settings_logout.locale),
                  leading: const Icon(Icons.logout),
                  onTap: () => context.read<AuthenticationBloc>().repository.logout(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
