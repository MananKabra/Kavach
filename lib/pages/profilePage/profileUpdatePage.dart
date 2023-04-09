import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hack7/pages/profilePage/profilePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../components/routing.dart';

var uuid = Uuid();

//FirebaseFirestore firestore = FirebaseFirestore.instance;
final db = FirebaseFirestore.instance;
var currentUser = FirebaseAuth.instance.currentUser;

var originalUserInfo;

void GetUserDataFromDatabase()async{
  currentUser = FirebaseAuth.instance.currentUser;
  originalUserInfo = await db.collection("users").doc(currentUser?.uid).get();
  print(originalUserInfo.data());
}



TextEditingController emc1 = TextEditingController();
TextEditingController emc2 = TextEditingController();
TextEditingController emc3 = TextEditingController();
TextEditingController bloodGroup = TextEditingController();
TextEditingController currentMedicines = TextEditingController();
TextEditingController pastRecords = TextEditingController();
TextEditingController medicalConditions = TextEditingController();
String userImageLink = "";
bool imageClicked = false;

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({Key? key}) : super(key: key);

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileUpdatePageApp(),
    );
  }
}


class ProfileUpdatePageApp extends StatefulWidget {
  const ProfileUpdatePageApp({Key? key}) : super(key: key);

  @override
  State<ProfileUpdatePageApp> createState() => _ProfileUpdatePageAppState();
}

class _ProfileUpdatePageAppState extends State<ProfileUpdatePageApp> {

  @override
  void initState(){
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    GetUserDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 235, 64, 52),
        actions: [
          IconButton(
              onPressed: () {
                RoutingPage.goToNext(context: context, navigateTo: ProfilePage());
              },
              icon: Icon(Icons.arrow_forward_outlined)
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                Text("EMERGENCY CONTACTS"),
                SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  controller: emc1,
                  decoration: InputDecoration(
                    hintText: 'Enter 1st Emergency Contact',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 235, 64, 52),
                      // align the text to the left instead of centered
                    ),
                    labelText: 'Contact 1',
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
                  controller: emc2,
                  decoration: InputDecoration(
                    hintText: 'Enter 2nd Emergency Contact',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 235, 64, 52),
                      // align the text to the left instead of centered
                    ),
                    labelText: 'Contact 2',
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
                  controller: emc3,
                  decoration: InputDecoration(
                    hintText: 'Enter 3rd Emergency Contact',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 235, 64, 52),
                      // align the text to the left instead of centered
                    ),
                    labelText: 'Contact 3',
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

                SizedBox(height: 30),
                Text("MEDICAL INFORMATION"),
                SizedBox(height: 20),

                TextFormField(
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  controller: bloodGroup,
                  decoration: InputDecoration(
                    hintText: 'Enter your blood group',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 235, 64, 52),
                      // align the text to the left instead of centered
                    ),
                    labelText: 'Blood Group',
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
                  controller: currentMedicines,
                  decoration: InputDecoration(
                    hintText: 'Enter medicines undertaking',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 235, 64, 52),
                      // align the text to the left instead of centered
                    ),
                    labelText: 'Current Medicines',
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
                  controller: medicalConditions,
                  decoration: InputDecoration(
                    hintText: 'Enter any disease/alleargy',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 235, 64, 52),
                      // align the text to the left instead of centered
                    ),
                    labelText: 'Medical Conditions',
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
                  controller: pastRecords,
                  decoration: InputDecoration(
                    hintText: 'Enter last medical checkup details',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 235, 64, 52),
                      // align the text to the left instead of centered
                    ),
                    labelText: 'Past Medical Record',
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

                SizedBox(height: 30),

                (imageClicked==false)?
                MaterialButton(
                  onPressed: ()async{

                    ImagePicker imagePicker = ImagePicker();
                    XFile? userImage = await imagePicker.pickImage(source: ImageSource.gallery);
                    print(userImage?.path);

                    if(userImage==null) return;

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceImageDir = referenceRoot.child('foodImage');
                    Reference referenceImageToUpload = referenceImageDir.child(uuid.v1());


                    try{
                      await referenceImageToUpload.putFile(File(userImage!.path) as File).then((value){
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Image Noted"),));
                      });
                      userImageLink = await referenceImageToUpload.getDownloadURL();
                    }catch(error){

                    }
                    setState(() {
                      imageClicked = true;
                    });

                  },
                  child: Text("Image"),
                  color: Color.fromARGB(255, 235, 64, 52),
                ):MaterialButton(
                  onPressed: ()async{

                    ImagePicker imagePicker = ImagePicker();
                    XFile? foodimage = await imagePicker.pickImage(source: ImageSource.gallery);
                    print(foodimage?.path);

                    if(foodimage==null) return;

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceImageDir = referenceRoot.child('foodImage');
                    Reference referenceImageToUpload = referenceImageDir.child(uuid.v1());


                    try{
                      await referenceImageToUpload.putFile(File(foodimage!.path) as File).then((value){
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Image Noted"),));
                      });
                      userImageLink = await referenceImageToUpload.getDownloadURL();
                    }catch(error){

                    }


                  },
                  child: Icon(Icons.check),
                  color: Color.fromARGB(255, 235, 64, 52),
                ),

                SizedBox(height: 30),
                MaterialButton(
                    onPressed: ()async{

                      GetUserDataFromDatabase();
                      (emc1.text!="")?emc1=emc1:emc1.text = originalUserInfo.data()["emcNum1"];
                      (emc2.text!="")?emc2=emc2:emc2.text = originalUserInfo.data()["emcNum2"];
                      (emc3.text!="")?emc3=emc3:emc3.text = originalUserInfo.data()["emcNum3"];
                      (pastRecords.text!="")?pastRecords=pastRecords:pastRecords.text = originalUserInfo.data()["pastRecords"];
                      (medicalConditions.text!="")?medicalConditions=medicalConditions:medicalConditions.text = originalUserInfo.data()["medicalConditions"];
                      (bloodGroup.text!="")?bloodGroup=bloodGroup:bloodGroup.text = originalUserInfo.data()["bloodGroup"];
                      (currentMedicines.text!="")?currentMedicines=currentMedicines:currentMedicines.text = originalUserInfo.data()["currentMedicines"];

                       currentUser = FirebaseAuth.instance.currentUser;
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser?.uid)
                            .update({
                          "emcNum1": emc1.text,
                          "emcNum2": emc2.text,
                          "emcNum3": emc3.text,
                          "pastRecords": pastRecords.text,
                          "bloodGroup": bloodGroup.text,
                          "currentMedicines": currentMedicines.text,
                          "medicalConditions": medicalConditions.text,
                          "userImage": userImageLink
                        }).then((result){
                          print("User Information Updated");
                        }).catchError((onError){
                          print("onError");
                        });
                    },
                  child: Text("Update"),
                  color: Color.fromARGB(255, 235, 64, 52),
                  height: 50,
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
