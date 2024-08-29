import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:properties/properties.dart';
import 'package:zapping_flutter/di/di.dart';
import 'package:zapping_flutter/ui/screen/zapping_screen.dart';

late final String zappingUrl;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // todo change to DefaultAssetBundle.of(context)
  final appPropertiesString =
      await rootBundle.loadString("properties/app.properties");

  zappingUrl = Properties.fromString(appPropertiesString).get("zapping.url")!;

  await AndroidAlarmManager.initialize();

  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zapping Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ZappingScreen(),
    );
  }
}
