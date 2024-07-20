import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:winui_n2n/edge_state.dart';
import 'package:winui_n2n/home_page.dart';

class ApplicationExitControl extends StatefulWidget {
  const ApplicationExitControl({super.key});

  @override
  State<ApplicationExitControl> createState() => _ApplicationExitControlState();
}

class _ApplicationExitControlState extends State<ApplicationExitControl> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onExitRequested: _handleExitRequest,
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  Future<AppExitResponse> _handleExitRequest() async {
    if (EdgeState.instance.isRunning && EdgeState.instance.process != null) {
      if (EdgeState.instance.process!.kill()) {
        EdgeState.instance.isRunning = false;
        EdgeState.instance.process = null;
      } else {
        // TODO: Handle abnormal close.
        return AppExitResponse.cancel;
      }
    }

    // Uninstall tap device before exit
    final findTapResult = await Process.run(
      "./tools/driver/devcon.exe",
      ["hwids", "tap0901"],
    );
    if (!findTapResult.stdout
        .toString()
        .contains('No matching devices found.')) {
      // Unstall tap device
      await Process.run(
        "./tools/driver/devcon.exe",
        [
          "remove",
          "tap0901",
        ],
      );
    }

    return AppExitResponse.exit;
  }

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
