import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:face_attendance/NavBar.dart';
import 'package:face_attendance/helper_function.dart';
import 'package:face_attendance/utils/Controller.dart';
import 'package:face_attendance/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name='';
  String page="Home";
  var controller=Get.put(Controller());



  @override
  void initState() {
    super.initState();
    Helper.getUserName().then((value) {
      setState(() {
        name=value!;
      });
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
          bottomNavigationBar: NavBar(list: [Icons.home_outlined,Icons.person,Icons.location_on_rounded,Icons.attach_email],),
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

                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: SafeArea(child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 160,
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 120,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xff88b49c), Color(0xff29353C)],)

                          ),
                          child: FadeInUp(
                              duration: const Duration(milliseconds: 500),
                              child: Text("Face Attendance System",textAlign: TextAlign.center,style: GoogleFonts.poppins(color: Colors.white,fontSize:25,fontWeight: FontWeight.w500),)),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 400),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: CircleAvatar(
                              radius: 52,
                              child: ClipOval(
                                child: Image.asset("assets/photo.jpg",height: 100,width: 100,fit: BoxFit.cover,),

                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
            )
          ][controller.selected.value]
        ),
      ),
    );
  }
}
