import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './routes/routing_constants.dart';
import './routes/routing.dart';
import 'global/global_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: MyRouter.generateRoute,
        onGenerateInitialRoutes: (initialRoute) => [
          MyRouter.generateRoute(
            RouteSettings(name: initialRoute),
          ),
        ],
        initialRoute: launchingRoute,
        scaffoldMessengerKey: snackKey,
        navigatorKey: navigatorKey,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
