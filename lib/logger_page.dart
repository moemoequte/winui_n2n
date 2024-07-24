import 'package:flutter/material.dart';
import 'package:winui_n2n/edge_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoggerPage extends StatelessWidget {
  const LoggerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: EdgeState.instance.logger,
      builder: (context, child) {
        return Stack(
          children: [
            ListView(
              children: EdgeState.instance.logger.logList.map<SelectableText>(
                (e) {
                  return SelectableText(e);
                },
              ).toList(),
            ),
            Positioned(
                right: 10,
                bottom: 10,
                child: FloatingActionButton(
                  tooltip: AppLocalizations.of(context)!.clearLog,
                  onPressed: () {
                    EdgeState.instance.logger.clearLog();
                  },
                  child: const Icon(Icons.clear),
                )),
          ],
        );
      },
    );
  }
}
