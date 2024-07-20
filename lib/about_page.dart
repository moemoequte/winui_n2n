import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = const TextStyle(fontSize: 16.0);
    TextStyle linkStyle = const TextStyle(color: Colors.blue);
    return Center(
      child: SelectableText.rich(
        TextSpan(
          style: defaultStyle,
          children: <TextSpan>[
            const TextSpan(
              text: '项目基于 n2n , 一款优秀的跨平台开源p2p VPN软件\n',
            ),
            const TextSpan(
              text: 'winui_n2n软件开源地址 ',
            ),
            TextSpan(
              text: 'https://github.com/moemoequte/winui_n2n\n',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrl(
                      Uri.parse('https://github.com/moemoequte/winui_n2n'));
                },
            ),
            const TextSpan(
              text: '分发和使用请遵循 GPL-3.0 license 开源协议\n\n',
            ),
            const TextSpan(
              text: '作者信息\n',
            ),
            const TextSpan(text: '网站 '),
            TextSpan(
              text: 'https://www.cialloo.com\n',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrl(Uri.parse('https://www.cialloo.com'));
                },
            ),
            const TextSpan(text: '邮箱 '),
            TextSpan(
              text: 'admin@cialloo.com',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrl(Uri(
                    scheme: 'mailto',
                    path: 'admin@cialloo.com',
                  ));
                },
            ),
          ],
        ),
      ),
    );
  }
}
