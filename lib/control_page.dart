import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:winui_n2n/edge_state.dart';
import 'package:winui_n2n/saved_connection.dart';
import 'package:winui_n2n/shared_pref_singleton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

TextEditingController _supernodeController = TextEditingController();
TextEditingController _communityController = TextEditingController();
TextEditingController _keyController = TextEditingController();
TextEditingController _selfAddressController = TextEditingController();

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  bool _edgeConnecting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            child: TextField(
              controller: _supernodeController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.n2nSuperNode,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            child: TextField(
              controller: _communityController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.n2nCommunity,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            child: TextField(
              controller: _keyController,
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.n2nCommunityKey,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            child: TextField(
              controller: _selfAddressController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.n2nSelfAddress,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  TextEditingController configNameController =
                      TextEditingController();
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 350,
                              child: TextField(
                                controller: configNameController,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: AppLocalizations.of(context)!
                                      .configNameComment,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      List<dynamic> nodeList = jsonDecode(
                                          SharedPrefSingleton()
                                              .savedConnection);
                                      List<SavedConnection> nodes = nodeList
                                          .cast<Map<String, dynamic>>()
                                          .map((nodeData) =>
                                              SavedConnection.fromJson(
                                                  nodeData))
                                          .toList();
                                      nodes.add(SavedConnection(
                                        configNameController.text,
                                        _supernodeController.text,
                                        _communityController.text,
                                        _keyController.text,
                                        _selfAddressController.text,
                                      ));

                                      List<Map<String, dynamic>> nodeMaps =
                                          nodes
                                              .map((node) => node.toJson())
                                              .toList();
                                      String jsonString = jsonEncode(nodeMaps);
                                      SharedPrefSingleton()
                                          .setSavedConnection(jsonString);

                                      Navigator.pop(context);
                                      return;
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.save)),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    return;
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.cancel),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Text(AppLocalizations.of(context)!.saveConfig),
              ),
              ElevatedButton(
                onPressed: _edgeConnecting
                    ? null
                    : () async {
                        if (EdgeState.instance.isRunning) {
                          // Turn on firewall
                          if (SharedPrefSingleton().autoFirewall) {
                            await Process.run(
                              'netsh.exe',
                              [
                                'advfirewall',
                                'set',
                                'allprofiles',
                                'state',
                                'on',
                              ],
                            );
                          }

                          // Kill the edge process
                          if (EdgeState.instance.process != null) {
                            if (EdgeState.instance.process!.kill()) {
                              EdgeState.instance.isRunning = false;
                              EdgeState.instance.process = null;
                              setState(() {});
                            }
                          }
                        } else if (!EdgeState.instance.isRunning) {
                          // Block user click
                          setState(() {
                            _edgeConnecting = true;
                          });

                          // Check for tap device
                          final findTapResult = await Process.run(
                            './tools/driver/devcon.exe',
                            ['hwids', 'tap0901'],
                          );
                          if (findTapResult.stdout
                              .toString()
                              .contains('No matching devices found.')) {
                            // Install tap device
                            EdgeState.instance.logger
                                .addLog('Tap device not found, installing tap');
                            debugPrint('Tap device not found, installing tap');
                            final installTapResult = await Process.run(
                              './tools/driver/devcon.exe',
                              [
                                'install',
                                './tools/driver/OemVista.inf',
                                'tap0901',
                              ],
                            );
                            if (installTapResult.stdout.toString().contains(
                                    'Tap driver installed successfully.') ||
                                installTapResult.stdout.toString().contains(
                                    'Drivers installed successfully.')) {
                              EdgeState.instance.logger
                                  .addLog('Tap driver installed successfully.');
                              debugPrint('Tap driver installed successfully.');
                            } else {
                              EdgeState.instance.logger
                                  .addLog('Tap driver install failed.');
                              debugPrint('Tap driver install failed.');
                            }
                          } else {
                            // Ignore.
                            EdgeState.instance.logger
                                .addLog('Tap device already installed');
                            debugPrint('Tap device already installed');
                          }

                          // Close firewall
                          if (SharedPrefSingleton().autoFirewall) {
                            await Process.run(
                              'netsh.exe',
                              [
                                'advfirewall',
                                'set',
                                'allprofiles',
                                'state',
                                'off',
                              ],
                            );
                          }

                          // Start the edge
                          // edge -c <community> -k <communityKey> -a <selfAddress> -r  -l <remoteSuperNodeAddress>
                          Process.start(
                            './tools/edge/edge.exe',
                            [
                              '-l',
                              _supernodeController.text,
                              '-c',
                              _communityController.text,
                              '-k',
                              _keyController.text,
                              '-a',
                              _selfAddressController.text,
                              '-r',
                            ],
                          ).then((process) async {
                            EdgeState.instance.isRunning = true;
                            EdgeState.instance.process = process;
                            EdgeState.instance.logger
                                .addLog('edge.exe starting');
                            debugPrint('edge.exe starting');
                            setState(() {
                              _edgeConnecting = false;
                            });
                            process.stdout
                                .transform(const SystemEncoding().decoder)
                                .listen((data) {
                              debugPrint('stdout: $data');
                              EdgeState.instance.logger.addLog(data);
                            });

                            await process.exitCode;
                            EdgeState.instance.isRunning = false;
                            EdgeState.instance.process = null;
                            EdgeState.instance.logger
                                .addLog('edge.exe closing');
                            debugPrint('edge.exe closing');
                            if (!mounted) return;
                            setState(() {});
                          });
                        }
                      },
                child: EdgeState.instance.isRunning
                    ? Text(AppLocalizations.of(context)!.disconnect)
                    : Text(AppLocalizations.of(context)!.connect),
              ),
              TextButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                        SavedConnection? selectedSavedConnection;
                        return Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Builder(builder: (context) {
                                  String jsonString =
                                      SharedPrefSingleton().savedConnection;
                                  List<dynamic> nodeList =
                                      jsonDecode(jsonString);
                                  List<SavedConnection> nodes = nodeList
                                      .cast<Map<String, dynamic>>()
                                      .map((nodeData) =>
                                          SavedConnection.fromJson(nodeData))
                                      .toList();

                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return DropdownButton(
                                        value: selectedSavedConnection,
                                        items: nodes.map<
                                                DropdownMenuItem<
                                                    SavedConnection>>(
                                            (SavedConnection value) {
                                          return DropdownMenuItem<
                                              SavedConnection>(
                                            value: value,
                                            child: Text(value.name),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              selectedSavedConnection = value!;
                                            },
                                          );
                                        });
                                  });
                                }),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        if (selectedSavedConnection != null) {
                                          _supernodeController.text =
                                              selectedSavedConnection!
                                                  .supernode;
                                          _communityController.text =
                                              selectedSavedConnection!
                                                  .community;
                                          _keyController.text =
                                              selectedSavedConnection!
                                                  .communityKey;
                                          _selfAddressController.text =
                                              selectedSavedConnection!
                                                  .selfAddress;
                                        }

                                        Navigator.pop(context);
                                        return;
                                      },
                                      child: Text(
                                          AppLocalizations.of(context)!.use),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (selectedSavedConnection == null) {
                                          Navigator.pop(context);
                                          return;
                                        }

                                        String jsonString =
                                            SharedPrefSingleton()
                                                .savedConnection;
                                        List<dynamic> nodeList =
                                            jsonDecode(jsonString);
                                        List<SavedConnection> nodes = nodeList
                                            .cast<Map<String, dynamic>>()
                                            .map((nodeData) =>
                                                SavedConnection.fromJson(
                                                    nodeData))
                                            .toList();

                                        nodes.removeWhere(
                                          (element) {
                                            return element.name ==
                                                selectedSavedConnection!.name;
                                          },
                                        );

                                        List<Map<String, dynamic>> nodeMaps =
                                            nodes
                                                .map((node) => node.toJson())
                                                .toList();
                                        SharedPrefSingleton()
                                            .setSavedConnection(
                                                jsonEncode(nodeMaps))
                                            .then((onValue) {
                                          setState(() {});
                                          // Navigator.pop(context);
                                          return;
                                        });
                                      },
                                      child: Text(
                                          AppLocalizations.of(context)!.delete),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        return;
                                      },
                                      child: Text(
                                          AppLocalizations.of(context)!.cancel),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.useConfig)),
            ],
          ),
        ),
      ],
    );
  }
}
