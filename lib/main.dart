import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hack7/pages/homePage/homePage.dart';
import 'package:hack7/pages/loginPage/loginAuthorization.dart';
import 'package:hack7/pages/signupPage/signUpAuthorization.dart';
import 'package:hack7/pages/signupPage/signupPage.dart';
import 'package:provider/provider.dart';

//Hellooooooooooooooooooooooooooooooo no kavach :(
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => SignupAuthorization(),
          ),
          ChangeNotifierProvider(
            create: (context) => LoginAuthorization(),
          ),
        ],
      child: MaterialApp(
        debugShowMaterialGrid: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnp) {
            if (userSnp.hasData) {
              return HomePage();
            }
            return SignUpPage();
          },
        ),
      ),
    );
  }
}






