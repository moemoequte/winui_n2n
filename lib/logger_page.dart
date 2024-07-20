import 'package:flutter/material.dart';
import 'package:winui_n2n/edge_state.dart';

class LoggerPage extends StatelessWidget {
  const LoggerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: EdgeState.instance.logger,
      builder: (context, child) {
        return ListView(
          children: EdgeState.instance.logger.logList.map<SelectableText>(
            (e) {
              return SelectableText(e);
            },
          ).toList(),
        );
      },
    );
  }
}
