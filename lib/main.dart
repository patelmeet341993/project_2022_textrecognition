import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/controllers/navigation_controller.dart';
import 'package:flutter_app/controllers/providers/connection_provider.dart';
import 'package:flutter_app/controllers/providers/user_provider.dart';
import 'package:provider/provider.dart';
List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConnectionProvider>(create: (_) => ConnectionProvider(),),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider(),),
      ],
      child: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: NavigationController().onGeneratedRoutes,
    );
  }
}

