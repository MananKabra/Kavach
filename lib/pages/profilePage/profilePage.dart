import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hack7/components/routing.dart';
import 'package:hack7/pages/homePage/homePage.dart';
import 'package:hack7/pages/profilePage/profileUpdatePage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';




final db = FirebaseFirestore.instance;
var currentUser = FirebaseAuth.instance.currentUser;
List<QueryDocumentSnapshot> usersList = [];
var userInfo;

void GetUserDataFromDatabase()async{
  // await db.collection("users").get().then((event) {
  //   for(int i =0;i<event.docs.length;i++){
  //     print(event.docs[i].id);
  //     print(event.docs[i].data()["userImage"]);
  //   }
  // });
  currentUser = FirebaseAuth.instance.currentUser;
  userInfo = await db.collection("users").doc(currentUser?.uid).get();
  print(userInfo.data());
}



class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState(){
    super.initState();

    setState(() {
      GetUserDataFromDatabase();
      userInfo = userInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePageApp(),
    );
  }
}

class ProfilePageApp extends StatefulWidget {
  const ProfilePageApp({Key? key}) : super(key: key);

  @override
  State<ProfilePageApp> createState() => _ProfilePageAppState();
}

class _ProfilePageAppState extends State<ProfilePageApp> {

  @override
  void initState(){
    super.initState();

    setState(() {
      GetUserDataFromDatabase();
    });
  }

  @override
  Widget build(BuildContext context) {

    RefreshController _profilepagerefreshController =
    RefreshController(initialRefresh: false);

    print("mkccccc");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 235, 64, 52),
        actions: [
          IconButton(
              onPressed: () {
                RoutingPage.goToNext(context: context, navigateTo: HomePage());
              },
              icon: Icon(Icons.arrow_forward_outlined)
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            RoutingPage.goToNext(context: context, navigateTo: ProfileUpdatePage());
        },
        backgroundColor: Color.fromARGB(255, 235, 64, 52),
        child: Icon(Icons.edit_note_outlined),
      ),
      body: SmartRefresher(
        controller: _profilepagerefreshController,
          onRefresh: ()async{
            await Future.delayed(Duration(milliseconds: 1000));
            setState(() {
              GetUserDataFromDatabase();
            });
            _profilepagerefreshController.refreshCompleted();
          },
        child: (userInfo != null)? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (userInfo.data()['userImage']!="")?CircleAvatar(
              minRadius: 100,
                backgroundImage: NetworkImage(userInfo.data()['userImage'])):
            CircleAvatar(
              backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),),
            SizedBox(height: 30),
            Text("USER INFORMATION"),
            SizedBox(height: 10),
            Text("Full Name - " + userInfo.data()['fullName']),
            SizedBox(height: 30),
            Text("EMERGENCY CONTACTS"),
            SizedBox(height: 10),

            (userInfo.data()['emcNum1']!= "")?
                Text("Number 1 - " + userInfo.data()['emcNum1']):
                Text("Number 1 - " + "Not Updated"),
            (userInfo.data()['emcNum2']!= "")?
                Text("Number 2 - " + userInfo.data()['emcNum2']):
                Text("Number 2 - " + "Not Updated"),
            (userInfo.data()['emcNum3']!= "")?
                Text("Number 3 - " + userInfo.data()['emcNum3']):
                Text("Number 3 - " + "Not Updated"),

            SizedBox(height: 30),

            Text("MEDICAL DETAILS"),
            SizedBox(height: 10),
            (userInfo.data()['currentMedicines']!= "")?
              Text("Current Medicines - " + userInfo.data()['currentMedicines']):
              Text("Current Medicines - " + "Not Updated"),
            (userInfo.data()['pastRecords']!= "")?
              Text("Past Records - " + userInfo.data()['pastRecords']):
              Text("Past Records - " + "Not Updated"),
            (userInfo.data()['medicalConditions']!= "")?
              Text("Medical Conditions - " + userInfo.data()['medicalConditions']):
              Text("Medical Conditions - " + "Not Updated"),
            (userInfo.data()['bloodGroup']!= "")?
              Text("Blood Group - " + userInfo.data()['bloodGroup']):
              Text("Blood Group  - " + "Not Updated"),


          ],
        ):Center(child: Text("No user data"),)
      )
    );
  }
}

