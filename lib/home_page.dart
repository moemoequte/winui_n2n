import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:winui_n2n/control_page.dart';
import 'package:winui_n2n/about_page.dart';
import 'package:winui_n2n/logger_page.dart';
import 'package:winui_n2n/main.dart';
import 'package:winui_n2n/setting_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tray_manager/tray_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TrayListener {
  int _selectedIndex = 0;

  @override
  void initState() {
    trayManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  Widget _homePageShow() {
    if (_selectedIndex == 0) {
      return const ControlPage();
    } else if (_selectedIndex == 1) {
      return const AboutPage();
    } else if (_selectedIndex == 2) {
      return const LoggerPage();
    } else if (_selectedIndex == 3) {
      return const SettingPage();
    }

    // Must contain a default widget.
    return const Text('Default');
  }

  @override
  Widget build(BuildContext context) {
    trayManager.setIcon(''); // TODO
    Menu menu = Menu(
      items: [
        MenuItem(
          key: 'show_window',
          label: AppLocalizations.of(context)!.showWindow,
          onClick: (menuItem) {
            windowManager.show();
          },
        ),
      ],
    );
    trayManager.setContextMenu(menu);

    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: IconButton(
                      icon:
                          MainApp.of(context).getCurrentTheme == ThemeMode.light
                              ? const Icon(Icons.dark_mode)
                              : const Icon(Icons.light_mode),
                      onPressed: () {
                        MainApp.of(context).getCurrentTheme == ThemeMode.light
                            ? MainApp.of(context).changeTheme(ThemeMode.dark)
                            : MainApp.of(context).changeTheme(ThemeMode.light);
                        setState(() {});
                      }),
                ),
              ),
            ),
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                icon: const Icon(Icons.favorite_border),
                selectedIcon: const Icon(Icons.favorite),
                label: Text(AppLocalizations.of(context)!.mainPage),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.bookmark_border),
                selectedIcon: const Icon(Icons.book),
                label: Text(AppLocalizations.of(context)!.aboutPage),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.pause_circle_filled),
                selectedIcon: const Icon(Icons.pause_circle),
                label: Text(AppLocalizations.of(context)!.logPage),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.star_border),
                selectedIcon: const Icon(Icons.star),
                label: Text(AppLocalizations.of(context)!.settingsPage),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: _homePageShow(),
          ),
        ],
      ),
    );
  }

  @override
  void onTrayIconMouseDown() {
    windowManager.show();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }
}
