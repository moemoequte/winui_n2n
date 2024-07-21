import 'package:flutter/material.dart';
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
