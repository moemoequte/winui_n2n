import 'package:flutter/material.dart';
import 'package:winui_n2n/control_page.dart';
import 'package:winui_n2n/about_page.dart';
import 'package:winui_n2n/logger_page.dart';
import 'package:winui_n2n/main.dart';
import 'package:winui_n2n/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
    return const Text("Default");
  }

  @override
  Widget build(BuildContext context) {
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
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite),
                label: Text('主页'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bookmark_border),
                selectedIcon: Icon(Icons.book),
                label: Text('关于'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.pause_circle_filled),
                selectedIcon: Icon(Icons.pause_circle),
                label: Text('日志'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.star_border),
                selectedIcon: Icon(Icons.star),
                label: Text('设置'),
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
}
