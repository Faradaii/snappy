import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/localizations/common.dart';
import '../../common/localizations/localization.dart';
import '../bloc/shared_preferences/shared_preference_bloc.dart';

class FlagLanguage extends StatelessWidget {
  const FlagLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          alignment: AlignmentDirectional.centerEnd,
          dropdownStyleData: DropdownStyleData(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          customButton: Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 15,
              children: [
                Flexible(
                  child: Text(
                    Localization.getFlag(
                        AppLocalizations.of(context)!.localeName),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.localeName.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          items: AppLocalizations.supportedLocales.map((Locale locale) {
            final flag = Localization.getFlag(locale.languageCode);
            return DropdownMenuItem(
              value: locale,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  Expanded(
                    child: Text(
                      flag,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      locale.languageCode.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (Locale? locale) {
            if (locale != null) {
              context
                  .read<SharedPreferenceBloc>()
                  .add(SharedPreferenceSetLanguageEvent(locale));
            }
          },
        ),
      ),
    );
  }
}
