import 'package:flutter/material.dart';
import 'package:winui_n2n/main.dart';
import 'package:winui_n2n/shared_pref_singleton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.autoFirewall),
            Switch(
              value: SharedPrefSingleton().autoFirewall,
              onChanged: (value) {
                final setting = !SharedPrefSingleton().autoFirewall;
                SharedPrefSingleton().setAutoFirewall(setting).then((ok) {
                  setState(() {});
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.minimizeOnQuit),
            Switch(
              value: SharedPrefSingleton().minimizeOnQuit ?? false,
              onChanged: (bool value) {
                SharedPrefSingleton().setMinimizeOrNot(value).then(
                  (_) {
                    setState(() {});
                  },
                );
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.chooseLanguage),
            const SizedBox(
              width: 10,
            ),
            DropdownButton<Locale>(
              value: Localizations.localeOf(context),
              items: AppLocalizations.supportedLocales
                  .map<DropdownMenuItem<Locale>>(
                (e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.toString() == 'en' ? 'English' : '中文'),
                  );
                },
              ).toList(),
              onChanged: (value) {
                setState(() {
                  MainApp.of(context).changeLocale(value!);
                });
              },
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.notImplement),
                  duration: const Duration(seconds: 2),
                ),
              );
          },
          child: Text(AppLocalizations.of(context)!.checkUpdate),
        ),
      ],
    );
  }
}
