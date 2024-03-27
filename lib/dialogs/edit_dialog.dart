import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sport_controller_app/providers/socket_provider.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({super.key});

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  TextEditingController _score1Controller = TextEditingController();
  TextEditingController _score2Controller = TextEditingController();
  TextEditingController _informationController = TextEditingController();

  @override
  void initState() {
    final socketProvider = context.read<SocketProvider>();
    _score1Controller =
        TextEditingController(text: socketProvider.scoreA.toString());
    _score2Controller =
        TextEditingController(text: socketProvider.scoreB.toString());
    _informationController =
        TextEditingController(text: socketProvider.information.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final socketProvider = context.watch<SocketProvider>();
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: const Center(child: Text('Edit values')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('TEAM 1:'),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    controller: _score1Controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (value) {
                      socketProvider.scoreA = int.tryParse(value) ?? 0;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('TEAM 2:'),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    controller: _score2Controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (value) {
                      socketProvider.scoreB = int.tryParse(value) ?? 0;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Info:'),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    maxLength: 100,
                    controller: _informationController,
                    onChanged: (value) {
                      socketProvider.information = value.trim();
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
