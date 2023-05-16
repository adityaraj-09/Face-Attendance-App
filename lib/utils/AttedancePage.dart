
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:face_attendance/camera_page.dart';
import 'package:face_attendance/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AttendancePage extends StatefulWidget {
  String course;
  String id;
  int attendance;
  List<CameraDescription> cameras;
  String lastMarked;
  String lh;
  double distance;

   AttendancePage({Key? key,required this.course,required this.attendance,required this.id,required this.cameras,required this.lastMarked,required this.lh,required this.distance}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {

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
      showSnakbar(context, Colors.red, e.toString());
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
      showSnakbar(context, Colors.red, e.toString());
    });
  }
  @override
  void initState() {
  _getCurrentPosition();
    super.initState();

  }




  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body:SafeArea(child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              children: [
                Text(widget.course,style: GoogleFonts.poppins(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                Expanded(child: Container()),
                InkWell(
                  onTap: (){

                  },
                    child: const Icon(Icons.calendar_today_outlined,color: Colors.black,)),
                SizedBox(width: 10,),
                Text( DateFormat.yMMMMd().format(DateTime.now()),style: GoogleFonts.roboto(fontSize: 18,color: Colors.black),)
              ],
            ),
            SizedBox(height: 50,),

            Row(
              children: [
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                      color:const Color(0xff2E4237).withOpacity(0.3) ,
                      borderRadius: const BorderRadius.all(Radius.circular(8))
                  ),
                  child: const Icon(Icons.book_outlined,color:Color(0xff2E4237) ,),),
                const SizedBox(width: 15,),
                Text("Course : ${widget.course}",style: GoogleFonts.roboto(color: Colors.black,fontSize:20),),


              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                      color:const Color(0xff2E4237).withOpacity(0.3) ,
                      borderRadius: const BorderRadius.all(Radius.circular(8))
                  ),
                  child: const Icon(Icons.book_outlined,color:Color(0xff2E4237) ,),),
                const SizedBox(width: 15,),
                Text("Total Attendance : ${widget.attendance}",style: GoogleFonts.roboto(color: Colors.black,fontSize:20),),


              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                      color:const Color(0xff2E4237).withOpacity(0.3) ,
                      borderRadius: const BorderRadius.all(Radius.circular(8))
                  ),
                  child: const Icon(Icons.room,color:Color(0xff2E4237) ,),),
                const SizedBox(width: 15,),
                Text("Lecture Hall : ${widget.lh}",style: GoogleFonts.roboto(color: Colors.black,fontSize:20),),


              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                      color:const Color(0xff2E4237).withOpacity(0.3) ,
                      borderRadius: const BorderRadius.all(Radius.circular(8))
                  ),
                  child: const Icon(Icons.timer_outlined,color:Color(0xff2E4237) ,),),
                const SizedBox(width: 15,),
                Text("Last marked : ${widget.lastMarked}",style: GoogleFonts.roboto(color: Colors.black,fontSize:20),),


              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                      color:const Color(0xff2E4237).withOpacity(0.3) ,
                      borderRadius: const BorderRadius.all(Radius.circular(8))
                  ),
                  child: const Icon(Icons.timelapse_outlined,color:Color(0xff2E4237) ,),),
                const SizedBox(width: 15,),
                Text("Duration : 60 min",style: GoogleFonts.roboto(color: Colors.black,fontSize:20),),


              ],
            ),
            SizedBox(height: 30,),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style:ElevatedButton.styleFrom(
                    primary:const Color(0xff2E4237),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    )
                ) ,
                child: const Text("Mark Attendance",style: TextStyle(color:Colors.white,fontSize: 16),
                ),onPressed: () async {
                  _getCurrentPosition();
                  if(_currentPosition!=null){
                    if(distance(	28.54245, 77.191, _currentPosition==null?0:_currentPosition!.latitude, _currentPosition==null?0:_currentPosition!.longitude)<0.2){
                      nextScreen(context, FaceScanScreen(register: false, cameras: widget.cameras, login: false, attendance: widget.attendance));
                    }else{
                      showSnakbar(context,Colors.red , "location seems not to be correct");
                    }
                  }else{
                    _getCurrentPosition();
                  }

              },
              ),
            ),
          ],
        ),
      )) ,
    );
  }
}
