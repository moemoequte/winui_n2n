import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

const _enContent = '''
# winui_n2n

**winui_n2n** is an open-source project based on **n2n**, an excellent cross-platform P2P VPN software.

## Features

- Cross-platform support
- P2P VPN capabilities
- User-friendly GUI built with Flutter

## Usage

Detailed usage instructions will be added here.

## License

This project is licensed under the terms of the GPL-3.0 license. See the [LICENSE](https://github.com/moemoequte/winui_n2n/blob/main/LICENSE) file for details.

## Author

For more information, please visit the author's website: [Cialloo](https://www.cialloo.com)  
For any inquiries, contact: [admin@cialloo.com](mailto:admin@cialloo.com)
''';

const _zhContent = '''
项目基于 n2n , 一款优秀的跨平台开源p2p VPN软件  
winui_n2n软件开源地址 https://github.com/moemoequte/winui_n2n  
分发和使用请遵循 GPL-3.0 license 开源协议  

作者信息  
网站 https://www.cialloo.com  
邮箱 admin@cialloo.com  
''';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    switch (Localizations.localeOf(context).toString()) {
      case 'en':
        return Markdown(
          data: _enContent,
          onTapLink: (text, href, title) {
            launchUrl(Uri.parse(href!));
          },
        );
      case 'zh':
        return Markdown(
          data: _zhContent,
          onTapLink: (text, href, title) {
            launchUrl(Uri.parse(href!));
          },
        );
    }

    return const SizedBox();
  }
}
