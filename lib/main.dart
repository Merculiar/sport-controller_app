import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport_controller_app/providers/socket_provider.dart';
import 'package:sport_controller_app/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SocketProvider>(
          create: (_) => SocketProvider(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.indigo),
      ),
    );
  }
}
