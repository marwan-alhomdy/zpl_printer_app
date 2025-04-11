import 'package:flutter/material.dart';
import 'package:zpl_printer_app/core/color_app.dart';

import 'features/home/presentation/pages/home.view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: AppColors.primaryMaterialColor),
      home: const HomeView(),
    );
  }
}
