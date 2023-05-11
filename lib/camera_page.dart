

import 'package:camera/camera.dart';
import 'package:face_attendance/home_page.dart';
import 'package:face_attendance/user.dart';
import 'package:face_attendance/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:lottie/lottie.dart';
import 'ml_service.dart';


class FaceScanScreen extends StatefulWidget {
  bool register;
  List<CameraDescription> cameras;
   FaceScanScreen({Key? key, required this.register,required this.cameras}) : super(key: key);

  @override
  _FaceScanScreenState createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends State<FaceScanScreen> {
  TextEditingController controller = TextEditingController();

  late CameraController _cameraController;
  bool flash = false;
  bool visible=false;
  bool isControllerInitialized = false;
  int value=0;
  late FaceDetector _faceDetector;
  final MLService _mlService = MLService();
  List<Face> facesDetected = [];

  Future initializeCamera() async {
    await _cameraController.initialize();
    isControllerInitialized = true;
    _cameraController.setFlashMode(FlashMode.off);
    setState(() {});
  }

  InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.Rotation_90deg;
      case 180:
        return InputImageRotation.Rotation_180deg;
      case 270:
        return InputImageRotation.Rotation_270deg;
      default:
        return InputImageRotation.Rotation_0deg;
    }
  }

  Future<void> detectFacesFromImage(CameraImage image) async {
    InputImageData _firebaseImageMetadata = InputImageData(
      imageRotation: rotationIntToImageRotation(
          _cameraController.description.sensorOrientation),
      inputImageFormat: InputImageFormat.BGRA8888,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      planeData: image.planes.map(
        (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );

    InputImage _firebaseVisionImage = InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      inputImageData: _firebaseImageMetadata,
    );
    var result = await _faceDetector.processImage(_firebaseVisionImage);
    if (result.isNotEmpty) {
      facesDetected = result;
    }
  }

  Future<void> _predictFacesFromImage({required CameraImage image}) async {
    await detectFacesFromImage(image);
    if (facesDetected.isNotEmpty) {
      bool user = await _mlService.predict(
          image,
          facesDetected[0],
          !widget.register);
      if (widget.register) {
        showSnakbar(context, Colors.blueGrey, "Face registered");// register case
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (context) => const HomePage()), (Route route) => false);
      } else {
        if (user == false) {
          showSnakbar(context, Colors.blueGrey, "Face not matched");//
          Navigator.pop(context);
        } else {
          nextScreenReplace(context, const HomePage());
        }
      }
    }
    if (mounted) setState(() {});
    await takePicture();
  }

  Future<void> takePicture() async {
    if (facesDetected.isNotEmpty) {
      await _cameraController.stopImageStream();
      XFile file = await _cameraController.takePicture();
      file = XFile(file.path);
      _cameraController.setFlashMode(FlashMode.off);
    } else {
      showSnakbar(context, Colors.red, "No face detected..try again");
      Navigator.pop(context);
    }
  }
  final Map<int,Widget> map=  <int,Widget>{
    0:Container(
      width: 78,
      child: const Center(child: Text("1:1"),),),
    1:const Text("4:9"),
    2:const Text("16:9"),
    3:const Text("Full")
  };



  @override
  void initState() {

    _cameraController = CameraController(widget.cameras[1], ResolutionPreset.max);
    initializeCamera();

    _faceDetector = GoogleMlKit.vision.faceDetector(
      const FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
        enableLandmarks: true
      ),
    );
    super.initState();
  }

 @override
  void dispose() {
   _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SizedBox(
                width:double.infinity,
                height: double.infinity,
                child: isControllerInitialized
                    ? CameraPreview(_cameraController)
                    : null),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 10
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    visible?Row(
                      children: [
                        CupertinoSegmentedControl<int>(children: map,
                            groupValue: value,
                            onValueChanged: (int val){
                              setState(() {
                                value=val;
                              });
                            }),
                        InkWell(
                          onTap: (){
                            setState(() {
                              visible=!visible;
                            });
                          },
                            child: Icon(Icons.cancel,color: Colors.white,size: 28,))
                      ],
                    ):Row(
                      children: [
                         Expanded(child: Container()),
                        InkWell(
                          onTap: (){
                            setState(() {
                              visible=!visible;
                            });
                          },
                          child: Icon(
                            Icons.menu,color: Colors.white,size: 28,),
                        )
                      ],
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Lottie.asset("assets/loading.json",
                            width: MediaQuery.of(context).size.width * 0.7),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            icon: const Icon(
                               Icons.analytics_outlined ,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                            }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: GestureDetector(
                            onTap: (){
                              bool canProcess = false;
                              _cameraController.startImageStream((CameraImage image) async {
                                if (canProcess) return;
                                canProcess = true;
                                _predictFacesFromImage(image: image).then((value) {
                                  canProcess = false;
                                });
                                return null;
                              });
                            },
                            child:  CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.blueGrey,
                              child: ClipOval(
                                child: Container(height: 52,width: 52,color: Colors.white,),
                              ),

                            )
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              flash ? Icons.flash_on : Icons.flash_off,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              setState(() {
                                flash = !flash;
                              });
                              flash
                                  ? _cameraController
                                      .setFlashMode(FlashMode.torch)
                                  : _cameraController.setFlashMode(FlashMode.off);
                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
