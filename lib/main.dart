import 'dart:async';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:winui_n2n/application_exit_control.dart';
import 'package:winui_n2n/edge_state.dart';
import 'package:winui_n2n/shared_pref_singleton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(630, 420),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    windowButtonVisibility: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  await initSingleton();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();

  static _MainAppState of(BuildContext context) {
    return context.findAncestorStateOfType<_MainAppState>()!;
  }
}

class _MainAppState extends State<MainApp> {
  // false = dark, true = light
  ThemeMode _themeMode =
      SharedPrefSingleton().appTheme ? ThemeMode.light : ThemeMode.dark;
  ThemeMode get getCurrentTheme => _themeMode;

  Locale? _locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
        body: ApplicationExitControl(),
      ),
    );
  }

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void changeTheme(ThemeMode mode) {
    mode == ThemeMode.light
        ? SharedPrefSingleton().setAppTheme(true).then((onValue) {
            setState(() {
              _themeMode = mode;
            });
          })
        : SharedPrefSingleton().setAppTheme(false).then((onValue) {
            setState(() {
              _themeMode = mode;
            });
          });
  }
}

Future<void> initSingleton() async {
  EdgeState.instance;
  await SharedPrefSingleton().initialize();
}
