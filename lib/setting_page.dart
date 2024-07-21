import 'package:flutter/material.dart';
import 'package:winui_n2n/shared_pref_singleton.dart';

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
            const Text('自动设置防火墙'),
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
                const SnackBar(
                  content: Text('功能暂未开发, 敬请期待~'),
                  duration: Duration(seconds: 2),
                ),
              );
          },
          child: const Text('检查更新'),
        ),
      ],
    );
  }
}
