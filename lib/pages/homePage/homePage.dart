import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hack7/components/routing.dart';
import 'package:hack7/pages/profilePage/profilePage.dart';
import '../signupPage/signupPage.dart';
import '../sosVideoPage/sosVideoPage.dart';

//final db = FirebaseFirestore.instance;
// List<QueryDocumentSnapshot> usersList = [];
//
// void GetUserSFromDatabase()async{
//   await db.collection("sellerOrder").get().then((event) {
//     usersList = event.docs;
//     print(usersList);
//   });
// }

var currentUser = FirebaseAuth.instance.currentUser;
// WidgetsFlutterBinding.ensureInitialized();
// final cameras = await availableCameras();
// final firstCamera = cameras.first;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePageApp(),
    );
  }
}


class HomePageApp extends StatefulWidget {
  const HomePageApp({Key? key}) : super(key: key);

  @override
  State<HomePageApp> createState() => _HomePageAppState();
}

class _HomePageAppState extends State<HomePageApp> {
  @override
  void initState(){
    super.initState();

    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
    print(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 235, 64, 52),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) =>
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignUpPage())));
              },
              icon: Icon(Icons.exit_to_app)
          ),
        ],
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${currentUser?.displayName}"),
              Text("${currentUser?.email}"),
              SizedBox(height: 10),
              Container(height: 1,color: Colors.red),
              SizedBox(height: 15),
              GestureDetector(
                onTap: (){
                  RoutingPage.goToNext(context: context, navigateTo: ProfilePage());
                },
                child: Row(
                  children: [
                    Icon(CupertinoIcons.profile_circled),
                    SizedBox(width: 10),
                    Text("Profile"),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(height: 1,color: Colors.red),
              SizedBox(height: 15),
              GestureDetector(
                onTap: ()async{
                  final cameras = await availableCameras();
                  final firstCamera = cameras.first;
                  RoutingPage.goToNext(context: context, navigateTo: SosVideoPage(camera: firstCamera));
                },
                child: Row(
                  children: [
                    Icon(CupertinoIcons.hand_point_left),
                    SizedBox(width: 10),
                    Text("Sos Video"),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
      body: Center(
        child: Text("Home"),
      ),
    );
  }
}
