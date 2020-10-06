import 'package:flutter/material.dart';
import './routes/routing_constants.dart';
import './routes/routing.dart';

import './screens/filters.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Filters(),
      // onGenerateRoute: Router.generateRoute,
      // initialRoute: launchingRoute,
    );
  }
}
