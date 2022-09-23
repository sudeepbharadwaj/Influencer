import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infleuncer/model/maindb.dart';
import 'package:infleuncer/model/personaldb.dart';
import 'package:sizer/sizer.dart';

import 'home.dart';

// ignore: must_be_immutable
class OTP extends StatefulWidget {
  var verificationId;
  String number;
  String name;
 OTP({ Key? key, required this.verificationId,required this.number,required this.name}) : super(key: key);
  

  @override
  // ignore: no_logic_in_create_state
  State<OTP> createState() => _OTPState(verificationId,number,name);
}

class _OTPState extends State<OTP> {
  var verificationId;
  String number;
  String name;
  _OTPState(this.verificationId,this.number,this.name);

late Timer _timer;
 var _start = 60;

 bool showresend=false;

 bool otpfilled=false;
 String? _otp;


 
 

  // ignore: non_constant_identifier_names
  void Counter(){
     
  const oneSec =  Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if(_start==0){
          _timer.cancel();
          setState(() {
            showresend=true;
          });

        }
        else{
          setState(() {
            _start --;
            
          });
        }
        
        
      },
    );
  
}

String? verificationID;
var resendtoken;


final PerHelper _perHelper=PerHelper();
final CollectionReference _user=FirebaseFirestore.instance.collection("data");

final _mainhelper=MainHelper.instance;


@override
void initState(){
  Counter();
}

@override
void dispose(){
  super.dispose();
  _timer.cancel();
}


var _lst;/*
Future <void> _checkuserexists()async{
  try{
    final res=await InternetAddress.lookup('google.com');
    if(res.isNotEmpty && res[0].rawAddress.isNotEmpty){
      await _user.where(FieldPath.documentId,isEqualTo: number).get().then((value){
        if(value.docs.isNotEmpty){
          value.docs.forEach((data) async{
            _perHelper.putdatawithkey('id',data.id);
             await _perHelper.putdatawithkey(data.id,{
              "name":data.get("name"),
              "phone_number":data.get('phone_number'),
              'business_name':data.get("business_name"),
              'category':data.get('Category'),
              'like':data.get('like'),
              'description':data.get('description'),
              'gmail':data.get('gmail'),
              'instagram_link':data.get('instagram_link'),
              'website_link':data.get('website_link'),
              'last_updated':data.get("last_updated").toDate(),

            });
            _lst=await data.get("like_arr");
           
            for (int i=0;i<_lst.length;i++){
              await _mainhelper.Likeinsert({
                MainHelper.columnLikearr:_lst[i]
              });
              
            
           
            }
            
            
          });
        }
        else{
          _user.doc(number).set({
            "name":name,
              "phone_number":number,
              'business_name':'Business Name',
              'Category':'Select Category',
              'like':0,
              'description':"description",
              'gmail':'gmail ID',
              'instagram_link':'Instagram Link',
              'website_link':'Website Link',
              'like_arr':'',
              'last_updated':DateTime.now(),
            
          });
        }

      });
    }
  }on SocketException catch(_){
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Check Your Internet Connection")));
  }
 
}

*/

final FirebaseAuth _auth = FirebaseAuth.instance;


_resendotp ()async{
  
   await _auth.verifyPhoneNumber(phoneNumber:"+91${number}", 
     verificationCompleted: (PhoneAuthCredential){
       _auth.signInWithCredential(PhoneAuthCredential).then((user){
         if(user!=null){
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> Home()), (route) => false);
             
           
           
         }


       });
       
     },
      verificationFailed: (FirebaseAuthException e){
        if(e.code=='invalid-phone-number'){
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Please Enter valid phone number")));
        }
        else{
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Something went wrong . Try Again later...")));
        }
      }, 
      codeSent: (verificationId ,[forceResendingToken]){
        Timer(const Duration(seconds: 10), (){
          
          

        });
        setState(() {
          verificationID=verificationId;
          resendtoken=forceResendingToken;
        });
      }, 
      codeAutoRetrievalTimeout: (String verificationId){
        verificationID=verificationId;

},
timeout: const Duration(seconds: 60)
     );
    

  }


_checkOTP()async{

  try{
    final res=await InternetAddress.lookup('google.com');
    if(res.isNotEmpty && res[0].rawAddress.isNotEmpty){
  await _auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId, smsCode:_otp.toString()
  
  )).then((user) async{

    if(user!=null){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> Home()), (route) => false);
      
      
    }


  }).onError((error, stackTrace) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong...")));
  });
    }
  }on TypeError catch(e){
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please check Your OTP')));
  }
  on SocketException catch(_){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Check your Internet Connection')));

  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
    appBar: AppBar(title:Text("verify phone",style: GoogleFonts.poppins(fontSize:14.sp,fontWeight:FontWeight.w500,color:Colors.white),),),
    body:SafeArea(
      minimum: EdgeInsets.only(top:5.h,left:8.w,right:8.w),
      child: 
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      Text("Enter your\n verification code",style: GoogleFonts.poppins(fontSize:20.sp,fontWeight:FontWeight.w600,color:Colors.white,letterSpacing: 1),textAlign: TextAlign.center,),
      SizedBox(height:3.h),
      Text("we sent a verification code \n to +91${number}",style: GoogleFonts.poppins(fontSize:11.sp,fontWeight:FontWeight.w600,color:const Color.fromARGB(255, 247, 238, 238)),textAlign: TextAlign.center,),
      SizedBox(height:8.h),
      VerificationCode(onCompleted: (String otp){
        setState(() {
          _otp=otp;
          otpfilled=true;
        });
      }
      , onEditing:(_){},
      length: 6,
      underlineColor: Colors.white,
      cursorColor: Colors.white,
      fillColor: Colors.white,
      textStyle: GoogleFonts.poppins(fontSize:12.sp,fontWeight: FontWeight.w600,color:Colors.white),

      ),
      SizedBox(height: 3.h,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("Didn't recieve code?",style: GoogleFonts.poppins(fontSize:10.sp,fontWeight:FontWeight.w500,color:const Color.fromARGB(255, 240, 228, 228)),),
        Visibility(visible:showresend,replacement: Text("$_start",style: GoogleFonts.poppins(fontSize:11.sp,fontWeight: FontWeight.w500,color:Colors.white),),
          child: TextButton(onPressed: (){
            if(showresend=true){
              _resendotp();

              setState(() {
                _start=60;
                showresend=false;

              });
              if(_timer!=null){
                _timer.cancel();
                 Counter();
              }


             

            }


          }, child:Text("Request again",style: GoogleFonts.poppins(fontSize:11.sp,fontWeight:FontWeight.w500,color:Colors.white),),
          style: TextButton.styleFrom(
          primary: Colors.transparent,
              ),
          ),
        )

      ],),

      SizedBox(height: 27.h,),
      MaterialButton(onPressed: (){
        
        if(otpfilled=false){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fill correct OTP")));
        }
        else{
          
          _checkOTP();
          }


      },
      height: 7.h,minWidth: 70.w,
      color: Colors.white,
      child: Text("verify",style: GoogleFonts.poppins(fontSize:16.sp,fontWeight:FontWeight.w600,color: Colors.black),),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      )
      
    ],)
    )
      
    );
  }
}