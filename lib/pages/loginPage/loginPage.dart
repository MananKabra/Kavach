import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hack7/components/routing.dart';
import 'package:hack7/pages/signupPage/signupPage.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import 'loginAuthorization.dart';


TextEditingController password = TextEditingController();
TextEditingController email = TextEditingController();



class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState(){
    super.initState();
    rootBundle.load('assets/heart.riv').then(
            (data) async{

        }
    );
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginApp()
    );
  }
}


class LoginApp extends StatefulWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  @override
  Widget build(BuildContext context) {

    LoginAuthorization loginAuth = Provider.of<LoginAuthorization>(context);

    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Center(child: Text(
                    "Emergency Buddy",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 60, 60, 60),
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),),

                  Container(
                    height: 250,
                    child: RiveAnimation.asset('assets/heart.riv'),
                  ),

                  Center(child: Text(
                    "Login",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 60, 60, 60),
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),),

                  SizedBox(height: 15),

                  TextFormField(
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    controller: email,
                    decoration: InputDecoration(
                      hintText: 'Enter Email',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 235, 64, 52),
                        // align the text to the left instead of centered
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color.fromARGB(255, 235, 64, 52),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 235, 64, 52),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 235, 64, 52)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 235, 64, 52),
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  TextFormField(
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 235, 64, 52),
                        // align the text to the left instead of centered
                      ),
                      prefixIcon: Icon(
                        Icons.remove_red_eye,
                        color: Color.fromARGB(255, 235, 64, 52),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 235, 64, 52),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 235, 64, 52)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 235, 64, 52),
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  SizedBox(height: 50),

                  MaterialButton(
                    onPressed: () {
                      loginAuth.loginValidation(
                          emailAddress: email,
                          password: password,
                          context: context
                      );
                    },

                    hoverColor: Color.fromARGB(255, 195, 66, 30),
                    height: 50,
                    child: Text("Login"),
                    color: Color.fromARGB(200, 235, 64, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 60, 60, 60),
                          fontSize: 12,
                          // align the text to the left instead of centered
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                            RoutingPage.goToNext(context: context, navigateTo: SignUpPage());
                        },
                        child: Text(
                          'Signup',
                          style: TextStyle(
                            color: Color.fromARGB(200, 235, 64, 52),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            // align the text to the left instead of centered
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        )
    );
  }
}
