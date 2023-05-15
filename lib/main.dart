import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_tracker/data.dart';
import 'package:media_tracker/providers/dark_mode_provider.dart';
import 'package:media_tracker/screens/homepage.dart';
import 'package:motion/motion.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Motion.instance.initialize();

  Motion.instance.setUpdateInterval(60.fps);
  Data();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var darkmode = ref.watch(darkModeProvider);
    print(darkmode);
    return MaterialApp(
      theme: darkmode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData(useMaterial3: true),
      home: HomePageScreen(),
    );
  }
}
