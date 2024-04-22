import 'package:background_service_demo/background_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundService.initializeService(autostart: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Background Service Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Background Service Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                BackgroundService.startService();
              },
              child: const Text("start"),
            ),
            ElevatedButton(
              onPressed: () {
                BackgroundService.service.invoke("setAsBackground");
              },
              child: const Text("set as background"),
            ),
            ElevatedButton(
              onPressed: () {
                BackgroundService.service.invoke("setAsForeground");
              },
              child: const Text("set as foregroud"),
            ),
            ElevatedButton(
              onPressed: () {
                BackgroundService.stopBackgroundService();
              },
              child: Text("stop"),
            ),
          ],
        ),
      ),
    );
  }
}
