import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noticeboard/bloc/connectivity_status_bloc.dart';
import 'package:noticeboard/services/notifications/notification_service.dart';
import './routes/routing_constants.dart';
import './routes/routing.dart';
import 'global/global_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: "AIzaSyB5xax2o1N_lW9cCF_7O579oElck2yHbQc",
          appId: "1:215723781757:android:7e147ce4cc21febc264b14",
          messagingSenderId: "215723781757",
          projectId: "channeli-v2-notifications",
          storageBucket: "channeli-v2-notifications.appspot.com",
        ))
      : await Firebase.initializeApp();
  NotificationService notificationService = NotificationService();
  await notificationService.setUpBackgroundNotifs();
  await notificationService.setUpForegroundNotifs();
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
    ConnectivityStatusBloc _connectivityStatusBloc = ConnectivityStatusBloc();
    _connectivityStatusBloc.context = context;
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
