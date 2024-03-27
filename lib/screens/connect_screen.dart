import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_controller_app/router/routes.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sport Controller'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            context.pushNamed(Routes.scanQR.name);
          },
          child: const Text('Connect'),
        ),
      ),
    );
  }
}
