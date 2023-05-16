
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool obscure=true;
  ImagePicker picker =ImagePicker();
  String photo="";
  File? _image;
  late XFile pickedimage;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                Text("Edit Profile",style: GoogleFonts.poppins(color: Colors.black,fontSize: 25),),
                Expanded(child: Container()),
                const Icon(Icons.sort,color: Colors.black,size: 25,)
              ],
            ),
            const SizedBox(height: 15,),
            Stack(
              children: [
            CircleAvatar(
              radius: 58,
              backgroundColor:const Color(0xff2E4237) ,
              child: ClipOval(
              child: Image.asset("assets/photo.jpg",height: 110,width: 110,fit: BoxFit.cover,),),
            ),
                Positioned(
                  left: 75,
                  top: 70,
                  child: GestureDetector(
                    onTap: (){
                      showModalBottomSheet<void>(context: context,
                          isScrollControlled: true,
                          isDismissible: true,
                          enableDrag: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)
                              )
                          ),
                          builder:(BuildContext context){
                            return Container(
                              height: 180,
                              child: Column(
                                  children:[
                                    Text("Choose an option ):",style: TextStyle(color:Color(0xff2E4237),fontSize: 25,fontWeight: FontWeight.bold),),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap:()async{
                                            Navigator.pop(context);
                                            pickedimage = (await picker.pickImage(source: ImageSource.gallery))!;
                                            setState(() {
                                              if(pickedimage!=null){
                                                _image=File(pickedimage!.path);
                                              }
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 25,top: 20,bottom: 10,right: 20),
                                            padding: const EdgeInsets.only(bottom: 5),
                                            height: 120,
                                            width: 120,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                              color: Color(0xff488381),
                                            ),
                                            child: Stack(
                                                children: const [
                                                  Center(child: Icon(Icons.browse_gallery,size: 50,color: Colors.white,)),
                                                  Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text("Gallery",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
                                                ]),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap:()async{
                                            Navigator.pop(context);
                                            pickedimage = (await picker.pickImage(source: ImageSource.camera))!;
                                            setState(() {
                                              if(pickedimage!=null){
                                                _image=File(pickedimage.path);
                                              }
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 15,top: 20,bottom: 10,right: 20),
                                            padding: const EdgeInsets.only(bottom: 5),
                                            height: 120,
                                            width: 120,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                              color: Color(0xff488381),
                                            ),
                                            child: Stack(
                                                children: const [
                                                  Center(child: Icon(Icons.camera,size: 50,color: Colors.white,)),
                                                  Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text("Camera",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
                                                ]),
                                          ),
                                        ),

                                      ],
                                    ),

                                  ]
                              ),
                            );
                          });

                    },

                    child:   CircleAvatar(
                      backgroundColor: const Color(0xff2E4237).withOpacity(0.5),
                      child: const Center(
                        child: Icon(Icons.edit,color: Colors.white,),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name",textAlign:TextAlign.start,style: GoogleFonts.poppins(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff2E4237).withOpacity(0.2),
                      borderRadius: const BorderRadius.all(Radius.circular(20))
                  ),
                  child: TextFormField(
                    style: TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person,color:Color(0xff2E4237) ,),

                    ),
                    initialValue: "Aditya",
                  ),
                ),
                SizedBox(height: 15,),
                Text("Entry No",textAlign:TextAlign.start,style: GoogleFonts.poppins(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff2E4237).withOpacity(0.2),
                      borderRadius: const BorderRadius.all(Radius.circular(20))
                  ),
                  child: TextFormField(
                    style: TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.confirmation_num,color:Color(0xff2E4237) ,),

                    ),
                    initialValue: "2022EE31760",
                  ),
                ),
                SizedBox(height: 15,),
                Text("Password",textAlign:TextAlign.start,style: GoogleFonts.poppins(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff2E4237).withOpacity(0.2),
                      borderRadius: const BorderRadius.all(Radius.circular(20))
                  ),
                  child: TextFormField(
                    obscureText: obscure,
                    style: TextStyle(fontSize: 20),
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.lock,color:Color(0xff2E4237) ,),
                      suffixIcon: InkWell(
                        onTap: (){
                          setState(() {
                            obscure=!obscure;
                          });
                        },
                          child: Icon(obscure?Icons.visibility:Icons.visibility_off,color:Color(0xff2E4237) ,))

                    ),
                    initialValue: "783298cb",
                  ),
                ),
              ],
            )


          ],
        ),
      )),
    );
  }
}
