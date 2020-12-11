import 'package:agendador_comunitario/controller/dialog_controller.dart';
import 'package:agendador_comunitario/controller/dialog_manager.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:agendador_comunitario/controller/notification_controller.dart';
import 'package:agendador_comunitario/controller/route_controller.dart';
import 'package:agendador_comunitario/view/login.dart';
import 'package:agendador_comunitario/view/offline_home.dart';
import 'package:agendador_comunitario/view/online_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  // final NotificationController _notificationController= locator<NotificationController>();
  // await _notificationController.initialise();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'agCom',
        debugShowCheckedModeBanner: false,
        builder: (context, child) => Navigator (
          key: locator<DialogController>().dialogNavigationKey,
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)
          ),
        ),
        navigatorKey: locator<NavigationController>().navigationKey,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: new HomePage(),
        onGenerateRoute: generateRoute,
    );
  }
}
