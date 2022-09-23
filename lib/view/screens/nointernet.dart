import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infleuncer/view/screens/home.dart';
import 'package:sizer/sizer.dart';
import 'package:lottie/lottie.dart';


class Nointernet extends StatefulWidget {
  const Nointernet({ Key? key }) : super(key: key);

  @override
  State<Nointernet> createState() => _NointernetState();
}

class _NointernetState extends State<Nointernet> {

   StreamSubscription? connectivitySubscription;

 ConnectivityResult? oldres;


@override 
 void initState(){
   super.initState();
   connectivitySubscription=Connectivity().onConnectivityChanged.listen((ConnectivityResult resnow) {
      if(resnow==ConnectivityResult.none){
      
        
        
      

      }else if (oldres==ConnectivityResult.none){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));

         
        

        
      }

     
     
      oldres=resnow;
   });

   
 }


@override
void dispose(){
  super.dispose();
  connectivitySubscription!.cancel();


}




  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
    appBar: AppBar(
      title: Text("No Internet",style: GoogleFonts.poppins(fontSize:14.sp,fontWeight: FontWeight.w500,color:Colors.white,),
    ),
    ),

    body: SafeArea(minimum: EdgeInsets.only(top:7.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Lottie.asset('assets/lottie/nointernet.json',fit: BoxFit.fitWidth,height: 10.h,width: 80.w),
        SizedBox(height: 45.h,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           SizedBox(height: 2.4.h,width: 5.w,
             child: const CircularProgressIndicator(strokeWidth: 2,color:Color(0xfff9e79f))),

          Padding(
            padding:  EdgeInsets.only(left:3.w),
            child: Text("waiting for Internet Connection",style: GoogleFonts.poppins(fontSize:13.sp,fontWeight: FontWeight.w500,color:Colors.white),),
          )

        ],)
      ],),
    ),
      
    );
  }
}