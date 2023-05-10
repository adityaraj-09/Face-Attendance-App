import 'dart:ui';

import 'package:face_attendance/NavBar.dart';
import 'package:face_attendance/helper_function.dart';
import 'package:face_attendance/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name='';
  String page="Home";



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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: NavBar(list: [Icons.home_outlined,Icons.person,Icons.location_on_rounded,Icons.attach_email],),
        body: SafeArea(
          child: Container(

            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                      Text(page,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black),),
                    Expanded(child: Container()),
                    const Icon(Icons.arrow_back_ios,color: Colors.black,size: 25,),
                    InkWell(
                      onTap: (){
                        HapticFeedback.heavyImpact();
                        showSnakbar(context, Colors.green, name);
                      },
                        child: const Icon(Icons.calendar_today_outlined,color: Colors.black,size: 25,)),
                    const Icon(Icons.arrow_forward_ios,color: Colors.black,size: 25,),

                    
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
