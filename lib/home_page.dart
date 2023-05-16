import 'dart:math';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_attendance/camera_page.dart';
import 'package:face_attendance/database_service.dart';
import 'package:face_attendance/utils/AttedancePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:face_attendance/Edit_profile.dart';
import 'package:face_attendance/NavBar.dart';
import 'package:face_attendance/auth_service.dart';
import 'package:face_attendance/helper_function.dart';
import 'package:face_attendance/utils/Controller.dart';
import 'package:face_attendance/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  List<CameraDescription> cameras;
   HomePage({Key? key,required this.cameras}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name='';
  String page="Home";
  Stream<QuerySnapshot>? courses;
  loc.Location location = loc.Location();
  double font=20;
  Authservice authservice=Authservice();
  var controller=Get.put(Controller());

  String? _currentAddress;
  Position? _currentPosition;
  double distance(double lat1, double lon1, double lat2, double lon2) {
    const r = 6372.8; // Earth radius in kilometers

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final lat1Radians = _toRadians(lat1);
    final lat2Radians = _toRadians(lat2);

    final a = _haversin(dLat) + cos(lat1Radians) * cos(lat2Radians) * _haversin(dLon);
    final c = 2 * asin(sqrt(a));

    return r * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  num _haversin(double radians) => pow(sin(radians / 2), 2);

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: const Text(
              'Location services are disabled. Please enable the services'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(label: "OK", onPressed: (){
          AppSettings.openLocationSettings();
        },textColor: Colors.white,),
      )
      );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }


  @override
  void initState() {
    super.initState();
    Helper.getUserName().then((value) => {
       setState((){
        name=value!;
      })
    });
    getGroups();

    _getCurrentPosition();
  }
  getGroups() {
   setState(() {
     courses=Database(uid: FirebaseAuth.instance.currentUser!.uid).getCourses();
   });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff88b49c), Color(0xff29353C)],)
      ),
      child: Obx(()=>
         Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: NavBar(list: const [Icons.home_outlined,Icons.person,Icons.location_on_rounded,Icons.attach_email],),
          body: <Widget>[
            SafeArea (
              child: Container(

                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(page,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black),),
                        Expanded(child: Container()),
                        const Icon(Icons.arrow_back_ios,color: Colors.black,size: 25,),
                        InkWell(
                            onTap: (){
                              HapticFeedback.heavyImpact();
                            },
                            child: const Icon(Icons.calendar_today_outlined,color: Colors.black,size: 25,)),
                        const Icon(Icons.arrow_forward_ios,color: Colors.black,size: 25,),


                      ],

                    ),

                    const SizedBox(height: 30,),
                    Expanded(child: courselist(), )




                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 190,
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 140,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xff88b49c), Color(0xff29353C)],),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  const SizedBox(width: 10,),
                                  Text("Profile",textAlign: TextAlign.center,style: GoogleFonts.poppins(color: Colors.white,fontSize: 25),),
                                  Expanded(child: Container()),
                                  IconButton(onPressed: (){
                                    HapticFeedback.heavyImpact();
                                  }, icon:const Icon( Icons.sort,color: Colors.white,size: 25,),),
                                  const SizedBox(width: 10,),
                                ],
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CircleAvatar(
                              radius: 54,
                              backgroundColor:const Color(0xff2E4237) ,
                              child: ClipOval(
                                child: Image.asset("assets/photo.jpg",height: 100,width: 100,fit: BoxFit.cover,),

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(name,style: GoogleFonts.aBeeZee(color: Colors.black,fontSize: 25),),
                    const SizedBox(height: 20,),
                    GestureDetector(
                      onTap: (){
                        HapticFeedback.heavyImpact();
                        nextScreen(context, const EditProfile());
                      },
                      child: Container(
                        width: 150,
                        height: 40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xff88b49c), Color(0xff29353C)],),
                        ),
                        child: const Center(child: Text("Edit Profile",textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20,),)),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          const Divider(height: 2,color: Colors.grey,),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    color:const Color(0xff2E4237).withOpacity(0.3) ,
                                    borderRadius: const BorderRadius.all(Radius.circular(8))
                                ),
                                child: const Icon(Icons.settings,color:Color(0xff2E4237) ,),),
                              const SizedBox(width: 15,),
                              Text("Settings",style: GoogleFonts.roboto(color: Colors.black,fontSize: font),),

                              Expanded(child: Container()),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xff2E4237).withOpacity(0.3),
                                child: Center(
                                  child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios,color: Colors.black,)),
                                ),
                              )

                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    color:const Color(0xff2E4237).withOpacity(0.3) ,
                                    borderRadius: const BorderRadius.all(Radius.circular(8))
                                ),
                                child: const Icon(Icons.details,color:Color(0xff2E4237) ,),),
                              const SizedBox(width: 15,),
                              Text("Attendance Details",style: GoogleFonts.roboto(color: Colors.black,fontSize: font),),

                              Expanded(child: Container()),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xff2E4237).withOpacity(0.3),
                                child: Center(
                                  child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios,color: Colors.black,)),
                                ),
                              )

                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    color:const Color(0xff2E4237).withOpacity(0.3) ,
                                    borderRadius: const BorderRadius.all(Radius.circular(8))
                                ),
                                child: const Icon(Icons.schedule,color:Color(0xff2E4237) ,),),
                              const SizedBox(width: 15,),
                              Text("Schedule",style: GoogleFonts.roboto(color: Colors.black,fontSize: font),),

                              Expanded(child: Container()),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xff2E4237).withOpacity(0.3),
                                child: Center(
                                  child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios,color: Colors.black,)),
                                ),
                              )

                            ],
                          ),
                          const SizedBox(height: 10,),
                          const Divider(height: 2,color: Colors.grey,),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    color:const Color(0xff2E4237).withOpacity(0.3) ,
                                    borderRadius: const BorderRadius.all(Radius.circular(8))
                                ),
                                child: const Icon(Icons.info_outline_rounded,color:Color(0xff2E4237) ,),),
                              const SizedBox(width: 15,),
                              Text("Information",style: GoogleFonts.roboto(color: Colors.black,fontSize: font),),

                              Expanded(child: Container()),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xff2E4237).withOpacity(0.3),
                                child: Center(
                                  child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios,color: Colors.black,)),
                                ),
                              )

                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    color:const Color(0xff2E4237).withOpacity(0.3) ,
                                    borderRadius: const BorderRadius.all(Radius.circular(8))
                                ),
                                child: const Icon(Icons.logout,color:Color(0xff2E4237) ,),),
                              const SizedBox(width: 15,),
                              Text("Log out",style: GoogleFonts.roboto(color: Colors.black,fontSize: font),),

                              Expanded(child: Container()),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xff2E4237).withOpacity(0.3),
                                child: Center(
                                  child: IconButton(onPressed: (){
                                    HapticFeedback.heavyImpact();
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) => CupertinoAlertDialog(
                                        content:  Text("Are you sure you want to logout?",style: GoogleFonts.poppins(fontSize: 17),),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            child:  Text("Log out",style: GoogleFonts.poppins(fontSize: 15),),
                                            onPressed: () {
                                              HapticFeedback.heavyImpact();
                                              authservice.signOut();
                                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                                  builder: (context) =>  LoginPage(cameras: const [],)), (Route route) => false);
                                            },
                                          ),
                                          CupertinoDialogAction(
                                            child:  Text('Cancel',style: GoogleFonts.poppins(fontSize: 15),),
                                            onPressed: () {
                                              HapticFeedback.heavyImpact();
                                              // Dismiss the dialog but don't
                                              // dismiss the swiped item
                                              return Navigator.of(context).pop(false);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }, icon: const Icon(Icons.arrow_forward_ios,color: Colors.black,)),
                                ),
                              )

                            ],
                          ),
                        ],
                      ),
                    ),],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Location",style: GoogleFonts.poppins(color: Colors.black,fontSize: 25),),
                        Expanded(child: Container()),
                        const InkWell(
                            child: Icon(Icons.location_on_rounded,color: Colors.black,size: 25,))
                      ],
                    ),
                    Container(
                      width: 200,
                        child: Text(_currentAddress==null?"":_currentAddress!)),
                    Container(
                        width: 200,
                        child: Text(distance(	28.54245, 77.191, _currentPosition==null?0:_currentPosition!.latitude, _currentPosition==null?0:_currentPosition!.longitude).toString())),
                    const SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(

                          onPressed: (){
                        _getCurrentPosition();
                        setState(() {
                        });
                      }, icon:const Icon( Icons.location_on), label:const Text("Update Location")),
                    )
                  ],
                ),
              ),
            )
          ][controller.selected.value]
        ),
      ),
    );
  }
  courselist(){
    return StreamBuilder(
      stream: courses,
        builder: (context,AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data.docs.length!=0){
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount:snapshot.data.docs.length ,
                itemBuilder: (context,index){
                return  GestureDetector(
                  onTap: (){
                    nextScreen(context, AttendancePage(course: snapshot.data.docs[index]["course"]
                      , attendance: snapshot.data.docs[index]['attnd']
                      , id: snapshot.data.docs[index].id,
                      cameras: widget.cameras,lastMarked: DateFormat.yMMMMd().format(new DateTime.fromMicrosecondsSinceEpoch(snapshot.data.docs[index]["Lastmarked"])) ,
                      lh:snapshot.data.docs[index]["lh"] ,
                      distance: distance(	28.54245, 77.191, _currentPosition==null?0:_currentPosition!.latitude, _currentPosition==null?0:_currentPosition!.longitude),
                    ));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10,right: 20),
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: const BoxDecoration(
                        color: Color(0xff88b49c),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    height: 70,
                    child: Column(
                      children: [
                        Row(
                          children:  [
                            const Icon(Icons.class_outlined,size: 28,),
                            const SizedBox(width: 20,),
                            Text("${snapshot.data.docs[index]["course"]}    ${snapshot.data.docs[index]["lh"]}",style: GoogleFonts.poppins(fontSize: 20,))
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children:  [
                            const Icon(Icons.calendar_today_outlined,size: 24),
                            SizedBox(width: 10,),
                            Text( DateFormat.yMMMMd().format( DateTime.fromMicrosecondsSinceEpoch(snapshot.data.docs[index]["Lastmarked"])).toString(),style: GoogleFonts.poppins(fontSize: 18,)),
                            Expanded(child: Container()),
                            const Icon(Icons.location_on,size: 28),
                            Text(snapshot.data.docs[index]["lh"],style: GoogleFonts.poppins(fontSize: 20,),)
                          ],
                        ),
                      ],
                    ),
                  ),
                );

            });
          }else{
            return Column(
              children: [
                GestureDetector(
                  onTap: (){
                    nextScreen(context, FaceScanScreen(register: false, cameras: widget.cameras,login: false,attendance: 0,));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10,right: 20),
                    decoration: const BoxDecoration(
                        color: Color(0xff88b49c),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    height: 70,
                    child: Column(
                      children: [
                        Row(
                          children:  [
                            const Icon(Icons.class_outlined,size: 28,),
                            const SizedBox(width: 20,),
                            Text("APL100    LH114",style: GoogleFonts.poppins(fontSize: 20,))
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children:  [
                            const Icon(Icons.account_circle,size: 28),
                            Expanded(child: Container()),
                            const Icon(Icons.location_on,size: 28),
                            Text("LH114",style: GoogleFonts.poppins(fontSize: 20,),)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                GestureDetector(
                  onTap: (){
                    nextScreen(context, FaceScanScreen(register: false, cameras: widget.cameras,login: false,attendance: 0,));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10,right: 20),
                    decoration: const BoxDecoration(
                        color: Color(0xff88b49c),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    height: 70,
                    child: Column(
                      children: [
                        Row(
                          children:  [
                            const Icon(Icons.class_outlined,size: 28,),
                            const SizedBox(width: 20,),
                            Text("CML101    LH108",style: GoogleFonts.poppins(fontSize: 20,))
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children:  [
                            const Icon(Icons.account_circle,size: 28),
                            Expanded(child: Container()),
                            const Icon(Icons.location_on,size: 28),
                            Text("LH108",style: GoogleFonts.poppins(fontSize: 20,),)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                GestureDetector(
                  onTap: (){
                    nextScreen(context, FaceScanScreen(register: false, cameras: widget.cameras,login: false,attendance: 0,));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10,right: 20),
                    decoration: const BoxDecoration(
                        color: Color(0xff88b49c),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    height: 70,
                    child: Column(
                      children: [
                        Row(
                          children:  [
                            const Icon(Icons.class_outlined,size: 28,),
                            const SizedBox(width: 20,),
                            Text("MTL101    LH316",style: GoogleFonts.poppins(fontSize: 20,))
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children:  [
                            const Icon(Icons.account_circle,size: 28),
                            Expanded(child: Container()),
                            const Icon(Icons.location_on,size: 28),
                            Text("LH316",style: GoogleFonts.poppins(fontSize: 20,),)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
              ],
            );
          }

        }else{
           return Center(child: CircularProgressIndicator(
            color:Theme.of(context).primaryColor,
          ),);
        }
    });
  }
}
