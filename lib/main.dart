import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wounts/constants.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
  await Hive.openBox('tracklist');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wounts',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(appBarTheme: AppBarTheme(backgroundColor: darkBlue)),
    );
  }
}
