import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport_controller_app/dialogs/edit_dialog.dart';
import 'package:sport_controller_app/providers/socket_provider.dart';

class MatchDetailsScreen extends StatelessWidget {
  const MatchDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final socketProvider = context.watch<SocketProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'Score: ${socketProvider.matchScore}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Information: ${socketProvider.information}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  showDialog<void>(
                    context: context,
                    builder: (_) => const EditDialog(),
                  );
                },
                child: const Text('Edit data'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  socketProvider.sendData();
                },
                child: const Text('Send data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
