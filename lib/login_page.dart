import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_attendance/auth_service.dart';
import 'package:face_attendance/camera_page.dart';
import 'package:face_attendance/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'database_service.dart';
import 'helper_function.dart';
import 'home_page.dart';


class LoginPage extends StatefulWidget {
  List<CameraDescription> cameras;
   LoginPage({Key? key,  required this.cameras}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  int sel=0;
  final registerKey=GlobalKey<FormState>();
  final loginKey=GlobalKey<FormState>();
  Authservice authservice=Authservice();
  String entryNo="";
  String password="";
  String name="";
  bool isloading=false;
  bool obscure=true;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:isloading?Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),): Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/bg.jpg"),fit: BoxFit.fill)
            ),

          ),
    Center(
      child:  ClipRect(
      child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
      height: 500,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff2E4237).withOpacity(0.2),
          border: Border.all(color: Colors.white,
          width: 0.8),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      width: 350,
        child: Column(
          children: [
            Text("Welcome Back",style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold),),
            Container(
              margin: const EdgeInsets.only(top: 20),
              height: 40,
              width: 230,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30),),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        sel=0;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 105,
                      decoration:  BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(30),),color:sel==0? const Color(0xff2E4237):Colors.white
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10,),
                          Text("Sign In",style: GoogleFonts.poppins(color:sel==0? Colors.white:const Color(0xff2E4237)),),
                          const SizedBox(width: 5,),
                          Icon(Icons.login,color:sel==0? Colors.white:const Color(0xff2E4237)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),

                  GestureDetector(
                    onTap: (){
                      setState(() {
                        sel=1;
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 105,
                      decoration:  BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(30),),color:sel==1? const Color(0xff2E4237):Colors.white
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            const SizedBox(width: 10,),
                            Text("Sign Up",style: GoogleFonts.poppins(color:sel==1? Colors.white:const Color(0xff2E4237))),
                            const SizedBox(width: 5,),
                            Icon(Icons.app_registration,color:sel==1? Colors.white:const Color(0xff2E4237)),
                          ],
                        ),
                      ),
                    ),
                  ) ,

                ],
              ),

            ),
            <Widget>[
              FadeInLeft(
                duration: const Duration(milliseconds: 500),
                child: Form(
                  key: loginKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:<Widget> [
                      const SizedBox(height: 70,),
                      TextFormField(
                        decoration: textInputdec.copyWith(
                            labelText: "Entry Number",
                            labelStyle: GoogleFonts.poppins(color: Colors.white),
                            prefixIcon: const Icon(Icons.email,
                              color:Color(0xff2E4237),
                            )
                        ),
                        onChanged:(val){
                          setState(() {
                            entryNo=val;
                          });
                        },
                        validator: (val){

                        },
                      ),
                      const SizedBox(height: 15,),
                      TextFormField(
                        obscureText: obscure,
                        decoration: textInputdec.copyWith(
                          labelText: "Kerberos Password",
                          labelStyle: GoogleFonts.poppins(color: Colors.white),
                          prefixIcon: const Icon(Icons.lock,
                            color:Color(0xff2E4237) ,
                          ),
                          suffixIcon: InkWell(
                            onTap: (){
                              setState(() {
                                obscure=!obscure;
                              });
                            },
                            child: obscure?const Icon(Icons.visibility,
                              color:Colors.white ,
                            ):const Icon(Icons.visibility_off,
                              color:Colors.white ,
                            ),
                          ),
                        ),
                        validator: (val){
                          if(val!.isEmpty){
                            return "enter password";
                          }else{
                            return null;
                          }
                        },
                        onChanged:(val){
                          setState(() {
                            password=val;
                          });
                        },
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style:ElevatedButton.styleFrom(
                              primary:const Color(0xff2E4237),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)
                              )
                          ) ,
                          child: const Text("Sign In",style: TextStyle(color:Colors.white,fontSize: 16),
                          ),onPressed: (){
                            login();
                        },
                        ),
                      ),



                    ],
                  ),
                ),
              ),
              FadeInRight(
                duration: const Duration(milliseconds: 400),
                child: Form(
                  key: registerKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:<Widget> [
                      const SizedBox(height: 70,),
                      TextFormField(
                        decoration: textInputdec.copyWith(
                            labelText: "Name",
                            labelStyle: GoogleFonts.poppins(color: Colors.white),
                            prefixIcon: const Icon(Icons.person,
                              color:Color(0xff2E4237),
                            )
                        ),
                        onChanged:(val){
                          setState(() {
                            name=val;
                          });
                        },
                        validator: (val){
                          if(val!.isEmpty){
                            return "name is mandatory";
                          }else{
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 15,),
                      TextFormField(
                        decoration: textInputdec.copyWith(
                            labelText: "Entry Number",
                            labelStyle: GoogleFonts.poppins(color: Colors.white),
                            prefixIcon: const Icon(Icons.email,
                              color:Color(0xff2E4237),
                            )
                        ),
                        onChanged:(val){
                          setState(() {
                            entryNo=val;
                          });
                        },
                        validator: (val){

                        },
                      ),
                      const SizedBox(height: 15,),
                      TextFormField(
                        obscureText: obscure,
                        decoration: textInputdec.copyWith(
                          labelText: "Kerberos Password",
                          labelStyle: GoogleFonts.poppins(color: Colors.white),
                          prefixIcon: const Icon(Icons.lock,
                            color:Color(0xff2E4237) ,
                          ),
                          suffixIcon: InkWell(
                            onTap: (){
                              setState(() {
                                obscure=!obscure;
                              });
                            },
                            child: obscure?const Icon(Icons.visibility,
                              color:Colors.white ,
                            ):const Icon(Icons.visibility_off,
                              color:Colors.white ,
                            ),
                          ),
                        ),
                        validator: (val){
                          if(val!.isEmpty){
                            return "enter password";
                          }else{
                            return null;
                          }
                        },
                        onChanged:(val){
                          setState(() {
                            password=val;
                          });
                        },
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style:ElevatedButton.styleFrom(
                              primary:const Color(0xff2E4237),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)
                              )
                          ) ,
                          child: const Text("Sign Up",style: TextStyle(color:Colors.white,fontSize: 16),
                          ),onPressed: (){

                            register();
                        },
                        ),
                      ),



                    ],
                  ),
                ),
              ),
            ][sel],


          ],
        ),
      ),
      ),),
    )

    ],
      )
    );
  }
  register() async{
    String email=entryNo.substring(4,7).toLowerCase()+"22"+entryNo.substring(7,11)+"@iitd.ac.in";
    if(registerKey.currentState!.validate()){
      setState(() {
        isloading=true;
      });
      await authservice.registeruser(name, email, password,entryNo).then((value) async{
        if(value==true){
          await Helper.saveUserStatus(true);
          await Helper.saveUserEmail(email);
          await Helper.saveUserName(name);
          await Helper.saveUserProfile("");
          nextScreenReplace(context,  FaceScanScreen(register: true,cameras: widget.cameras,));
        }else{
          showSnakbar(context, Colors.red, value);
          setState(() {
            isloading=false;
          });
        }
      });
    }

  }
  login() async{
    String email="${entryNo.substring(4,7).toLowerCase()}22${entryNo.substring(7,11)}@iitd.ac.in";
    if(loginKey.currentState!.validate()){
      setState(() {
        isloading=true;
      });
      await authservice.login(email, password).then((value) async{
        if(value==true){
          QuerySnapshot snapshot= await Database(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(entryNo);
           Helper.saveUserStatus(true);
           Helper.saveUserEmail(email);
          await Helper.saveUserName(snapshot.docs[0]['Name']);
          await Helper.saveUserProfile(snapshot.docs[0]['profilePic']);
          nextScreen(context, FaceScanScreen(register: true,cameras: widget.cameras,));
        }else{
          showSnakbar(context, Colors.red, value);
          setState(() {
            isloading=false;
          });
        }
      });
    }
  }
}
