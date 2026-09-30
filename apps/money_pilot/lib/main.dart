import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/screens/auth/splash_screen.dart';
import 'src/data/finance_data.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await FinanceData.load();

  runApp(
    const MyApp(),
  );

}

class MyApp extends StatelessWidget {

  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      localizationsDelegates: const [

        GlobalMaterialLocalizations.delegate,

        GlobalWidgetsLocalizations.delegate,

        GlobalCupertinoLocalizations.delegate,

      ],

      supportedLocales: const [

        Locale('fr'),

        Locale('en'),

      ],

      home: const SplashScreen(),

    );

  }

}