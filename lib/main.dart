import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'constants.dart';
import 'pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('money');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Manager',
        theme: ThemeData(
          scaffoldBackgroundColor: kScaffoldColor,
          appBarTheme: AppBarTheme(
            backgroundColor: kPrimaryColor,
            iconTheme: IconThemeData(
              size: 23.sp,
              color: kSecondaryColor,
            ),
          ),
          iconTheme: IconThemeData(
            size: 23.sp,
            color: kSecondaryColor,
          ),
        ),
        home: const HomePage(),
      );
    });
  }
}
