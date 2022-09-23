import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infleuncer/model/personaldb.dart';
import 'package:infleuncer/view/screens/home.dart';
import 'package:infleuncer/view/screens/login.dart';
import 'package:sizer/sizer.dart';

import '../../model/maindb.dart';


class Splash extends StatefulWidget {
  const Splash({ Key? key }) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {


final PerHelper _perHelper=PerHelper();
 final _mainhelper=MainHelper.instance;


 

  @override 
  void initState(){
    super.initState();
    _perHelper.putdatawithkey("getdata",0);
    _mainhelper.clear();
    _Checklogin();
  //_mainhelper.clear();
   // print(_perHelper.getall());


  }


    _Checklogin(){
    if(_perHelper.checkkey()==true){
      if(_perHelper.checkloginstatus()==true){
         Timer(const Duration(seconds: 1), (){
         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const Login()));
          });
      

      }
      else{
      Timer(const Duration(seconds: 1), (){
         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Home()));

      });
     
     
     
    }
    
    
    }
    else{
      Timer(const Duration(seconds: 1), (){
         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const Login()));
          });

    }

  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      body:SafeArea(minimum: EdgeInsets.only(top: 12.h),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Center(child: Image.asset('assets/img/advertising.png',height: 25.h,width: 60.w,fit:BoxFit.fitHeight)),
          SizedBox(height: 5.h,),
          Text("Find Influencer according\n to You",style: GoogleFonts.poppins(fontSize:18.sp,fontWeight:FontWeight.w700,color: Colors.white,letterSpacing: 0.5),textAlign: TextAlign.center,),
          SizedBox(height: 8.h,),
          Text("some Text here",style: GoogleFonts.poppins(fontSize:14.sp,color:Colors.white),),
          SizedBox(height: 12.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            MaterialButton(onPressed: (){
              _mainhelper.clear();
            },
            color:Colors.white,
            height: 7.h,minWidth: 40.w,
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Text("Register",style: GoogleFonts.poppins(fontSize:14.sp,fontWeight:FontWeight.w600,color:Colors.black),),),

            MaterialButton(onPressed: ()async{
               print("pressed");
                var allrows=await _mainhelper.queryall();
                print(allrows);
    
                allrows.forEach((element) {
                  print("run");
                  print(element);
                  
                });
            },
            color:Colors.white,
            height: 7.h,minWidth: 40.w,
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Text("Sign In",style: GoogleFonts.poppins(fontSize:14.sp,fontWeight:FontWeight.w600,color:Colors.black),),)
          ],)



        ],)
        
        
      )
        
      );
    
  }
}