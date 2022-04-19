import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoapp/services/theme_services.dart';
import 'package:todoapp/ui/HomePage.dart';
import 'package:todoapp/ui/theme.dart';

import 'models/database.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await DB.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,

      home: HomePage()
    );
  }
}

