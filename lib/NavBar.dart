import 'package:face_attendance/helper_function.dart';
import 'package:face_attendance/utils/Controller.dart';
import 'package:face_attendance/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NavBar extends StatefulWidget {

   NavBar({Key? key,required this.list}) : super(key: key);
   List<IconData> list;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  var controller=Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: const Color(0xff2f3b42),
      child: Obx(()=>
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            GestureDetector(
              onTap: (){
                HapticFeedback.heavyImpact();
                setState(() {
                  controller.selected(0);
                });
              },
              child: Column(
                children: [
                Container(
                  height: 4,
                  width: 20,
                  decoration:  BoxDecoration(
                      color:controller.selected.value==0? Colors.white:Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(10))),),
                  const SizedBox(height: 8,),
                   Icon(widget.list[0],color: Colors.white,size: 30,),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                HapticFeedback.heavyImpact();
                setState(() {
                  controller.selected(1);
                });
              },
              child: Column(
                children: [
                  Container(
                    height: 4,
                    width: 20,
                    decoration:  BoxDecoration(
                        color:controller.selected.value==1? Colors.white:Colors.transparent,
                        borderRadius: const BorderRadius.all(Radius.circular(10))),),
                  const SizedBox(height: 8,),
                  CircleAvatar(
                    radius:controller.selected.value==1? 22:20,
                    child: ClipOval(
                      child: Image.asset("assets/photo.jpg",height: 40,width: 40,fit: BoxFit.cover,),
                    ),
                  ),

                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                HapticFeedback.heavyImpact();
                setState(() {
                  controller.selected(2);
                });
              },
              child: Column(
                children: [
                  Container(
                    height: 4,
                    width: 20,
                    decoration:  BoxDecoration(
                        color:controller.selected.value==2? Colors.white:Colors.transparent,
                        borderRadius: const BorderRadius.all(Radius.circular(10))),),
                  const SizedBox(height: 8,),
                   Icon(widget.list[2],color: Colors.white,size: 30,),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                HapticFeedback.heavyImpact();
                setState(() {
                  controller.selected(3);
                });
              },
              child: Column(
                children: [

                  Container(
                    height: 6,
                    width: 20,
                    decoration:  BoxDecoration(
                        color:controller.selected.value==3? Colors.white:Colors.transparent,
                        borderRadius: const BorderRadius.all(Radius.circular(10))),),
                  const SizedBox(height: 8,),
                   Icon(widget.list[3],color: Colors.white,size: 30,),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

}