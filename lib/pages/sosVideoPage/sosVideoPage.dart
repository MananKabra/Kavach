import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../components/routing.dart';
import '../homePage/homePage.dart';
import 'package:whatsapp/whatsapp.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:shake/shake.dart';
import 'package:telephony/telephony.dart';



int volumeCounter = 0;

void _callNumber() async{
  if(volumeCounter!=0){
    const number = '9167039622'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    volumeCounter=0;
  }
}

void _sendMessageToContact({required String number,required String message}){

  final Telephony telephony = Telephony.instance;

  telephony.sendSms(
    to: number,
    message: message,
  );
  print("Message Sent");
}

var uuid = Uuid();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final cameras = await availableCameras();
//   final firstCamera = cameras.first;
//   runApp(SosVideoPage(camera: firstCamera));
// }

class SosVideoPage extends StatelessWidget {
  final CameraDescription camera;

  SosVideoPage({required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Women Safety App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SosVideoPageApp(camera: camera),
    );
  }
}

class SosVideoPageApp extends StatefulWidget {
  final CameraDescription camera;

  const SosVideoPageApp({Key? key, required this.camera}) : super(key: key);

  @override
  _SosVideoPageAppState createState() => _SosVideoPageAppState();
}

class _SosVideoPageAppState extends State<SosVideoPageApp> with WidgetsBindingObserver{
  late CameraController _controller;
  // late VideoPlayerController _videoPlayerController;
  Timer? _timer;
  bool _isMoving = false;
  late FToast fToast;
  late StreamSubscription<double> _subscription;
  double _volumeListenerValue = 0;
  double lastVolume = 0;


  @override
  void initState() {
    super.initState();

    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        print("3 Shakes Detected");
        _recordingToDatabase();

      },
      minimumShakeCount: 2,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 2000,
      shakeThresholdGravity: 2.7,
    );





    VolumeController().showSystemUI = false;

    //
    // PerfectVolumeControl.stream.listen((value) {
    //   volumeCounter++;
    //   print(volumeCounter);
    // });
    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
      if(volumeCounter%3==0 && volumeCounter!=0){
        print(volumeCounter);
        _callNumber();
        volumeCounter=0;
      }
      volumeCounter++;
    });


    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    fToast = FToast();
    fToast.init(context);
    accelerometerEvents.listen((AccelerometerEvent event) {
      if(event.x.abs()>80.0 ||event.y.abs() > 80.0 || event.z.abs() > 80.0){
        //sendSms();
        Fluttertoast.showToast(
            msg: "Crash Detected",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red[50],
            textColor: Colors.black54,
            fontSize: 16.0
        );
      }
      //print(event.y.abs());
      //print(event.z);
      if (event.x.abs() > 2.0 ||
          event.y.abs() > 2.0 ||
          event.z.abs() > 2.0) {
        _isMoving = true;
        _timer?.cancel();
        _timer = Timer(const Duration(minutes: 1), () {
          stopRecording();
        });
      }
      else {
        _isMoving = false;
      }
    });
  }

  Future<void> stopRecording() async {
    if (!_isMoving) {
      if (_controller.value.isRecordingVideo) {
        XFile videoFile = await _controller.stopVideoRecording();
        Fluttertoast.showToast(
            msg: "Stopped Recording, Saving...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red[50],
            textColor: Colors.black54,
            fontSize: 16.0
        );
        print(videoFile.path);
      }
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      await FlutterBackground.enableBackgroundExecution();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    accelerometerEvents.drain();
    _timer?.cancel();
    super.dispose();
  }

  void _toggleRecording() async {
    await FlutterBackground.initialize();
    if (!_controller.value.isRecordingVideo) {
      _controller.startVideoRecording();
      Fluttertoast.showToast(
          msg: "Started Recording",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[50],
          textColor: Colors.black54,
          fontSize: 16.0
      );
    }
    else if (_controller.value.isRecordingVideo) {
      XFile videoFile = await _controller.stopVideoRecording();
      Fluttertoast.showToast(
          msg: "Stopped Recording, Saving...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[50],
          textColor: Colors.black54,
          fontSize: 16.0
      );
      print(videoFile.path);
      //print(videoFile);

      var videoUrl;
      var videoFileFile = File(videoFile.path);
      var fileName = uuid.v1();
      try {
        // Create a reference to the video file location in Firebase Storage
        final Reference videoRef = FirebaseStorage.instance.ref().child('videos/$fileName');

        // Upload the file to Firebase Storage
        await videoRef.putFile(videoFileFile);

        // Get the download URL of the uploaded video
        videoUrl = await videoRef.getDownloadURL();

      } catch (error) {
        print(error);
      }
      print(videoUrl);


    }
  }

  void _recordingToDatabase() async{
    await FlutterBackground.initialize();

    _controller.startVideoRecording();
    Fluttertoast.showToast(
        msg: "Started Recording",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red[50],
        textColor: Colors.black54,
        fontSize: 16.0
    );

    await Future.delayed(Duration(seconds: 20));

    XFile videoFile = await _controller.stopVideoRecording();
    Fluttertoast.showToast(
        msg: "Stopped Recording, Saving...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red[50],
        textColor: Colors.black54,
        fontSize: 16.0
    );



    var videoUrl;
    var videoFileFile = File(videoFile.path);
    var fileName = uuid.v1();
    try {
      // Create a reference to the video file location in Firebase Storage
      final Reference videoRef = FirebaseStorage.instance.ref().child('videos/$fileName');

      // Upload the file to Firebase Storage
      await videoRef.putFile(videoFileFile);

      // Get the download URL of the uploaded video
      videoUrl = await videoRef.getDownloadURL();

    } catch (error) {
      print(error);
    }
    print(videoUrl);
    _sendMessageToContact(number: "9167039622", message: "Sos Alert(All details will be sent)");


  }


  void sendSms() async {

  }


  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  RoutingPage.goToNext(context: context, navigateTo: HomePage());
                },
                icon: Icon(Icons.arrow_forward_outlined)
            ),
          ],
          title: Text('Women Safety App'),
        ),
        body: Center(
            child: FloatingActionButton(
                onPressed: ()async{
                  _callNumber();
                },
                child: Text('SOS')
            )
        )
    );
    // To Watch Video Preview: Add to body
    // body: Center(
    //   child: AspectRatio(
    //     aspectRatio: _controller.value.aspectRatio,
    //     child: CameraPreview(_controller),
    //   ),
    // ),
  }
}



