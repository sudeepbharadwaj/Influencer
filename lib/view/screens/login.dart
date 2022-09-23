import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infleuncer/view/screens/home.dart';
import 'package:infleuncer/view/screens/otp.dart';
import 'package:sizer/sizer.dart';

import '../../model/maindb.dart';
import '../../model/personaldb.dart';


class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final  _name=TextEditingController();
  final _number=TextEditingController();
  final FirebaseAuth _auth= FirebaseAuth.instance;

  final PerHelper _perHelper=PerHelper();
final CollectionReference _user=FirebaseFirestore.instance.collection("data");

final _mainhelper=MainHelper.instance;


  String? verificationID;
  var resendtoken;


  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      backgroundColor: Colors.white,
      content:  Row(
        children: [
          const CircularProgressIndicator(color:Colors.black),
          Container(margin: const EdgeInsets.only(left: 4.5),child:Text("Waiting for OTP",style: GoogleFonts.poppins(fontSize:10.sp,fontWeight:FontWeight.w400,color:Colors.black), )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

var _lst;

  Future <void> _checkuserexists()async{
  try{
    final res=await InternetAddress.lookup('google.com');
    if(res.isNotEmpty && res[0].rawAddress.isNotEmpty){
      await _user.where(FieldPath.documentId,isEqualTo: _number.text).get().then((value){
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
          _user.doc(_number.text).set({
            "name":_name.text,
              "phone_number":_number.text,
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



   _verify ()async{
     try{
     final res=await InternetAddress.lookup('google.com');
     if(res.isNotEmpty && res[0].rawAddress.isNotEmpty){
     await _auth.verifyPhoneNumber(phoneNumber:"+91${_number.text}", 
     verificationCompleted: (PhoneAuthCredential){
       _auth.signInWithCredential(PhoneAuthCredential).then((user){
         


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
        _checkuserexists().whenComplete((){
           Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (context)=>OTP(verificationId:verificationId, number:_number.text,name:_name.text)));

        }).onError((error, stackTrace) => null);

          verificationID=verificationId;
          resendtoken=forceResendingToken;


      },

      codeAutoRetrievalTimeout: (String verificationId){
        //Navigator.pop(context);

        verificationID=verificationId;

},
timeout: const Duration(seconds: 60)
     );
     }
     }on SocketException catch(_){
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("check your Internet Connection")));

     }
  }



  @override
  void dispose (){
    super.dispose();
    _name.dispose();
    _number.dispose();

  }
  



  


  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
    body:SafeArea(minimum: EdgeInsets.only(top:12.h,left:8.w,right:8.w),
      child: 
    Column(
     crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text("Let's sign you in.",style: GoogleFonts.poppins(fontSize:24.sp,fontWeight: FontWeight.bold,color:Colors.white),),
      SizedBox(height: 1.3.h,),
      Text("Welcome Back.\n you've been missed!",style: GoogleFonts.poppins(fontSize:17.sp,fontWeight: FontWeight.w600,color:const Color.fromARGB(255, 247, 238, 238)),textAlign: TextAlign.start,),
      SizedBox(height: 14.h,),
      Container(padding: EdgeInsets.only(top:0.5.h),
        height: 7.h,width: 85.w,
        decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(221, 37, 36, 36),style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(14),
          color: Colors.white12,
          

        ),
        child: TextField(cursorColor:const Color.fromARGB(255, 247, 238, 238),controller: _name,textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          
          hintText: "Your name",
          hintStyle: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),
          
          border:InputBorder.none,
          enabledBorder: InputBorder.none,
             disabledBorder: InputBorder.none,
             errorBorder: InputBorder.none,
             focusedBorder: InputBorder.none,
             focusedErrorBorder: InputBorder.none,
             prefixIcon: Icon(Icons.person,size:23.sp,color:const Color.fromARGB(255, 247, 238, 238)),
        ),
        style: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),

        ),
      ),

      SizedBox(height:6.h),
       Container(padding: EdgeInsets.only(top:0.5.h),
        height: 7.h,width: 85.w,
        decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(221, 37, 36, 36),style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(14),
          color: Colors.white12,
          

        ),
        child: TextField(cursorColor:const Color.fromARGB(255, 247, 238, 238),controller: _number,textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        maxLength: 10,
        decoration: InputDecoration(
          counterText: "",
          hintText: "Phone number",
          hintStyle: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),
          
          border:InputBorder.none,
          enabledBorder: InputBorder.none,
             disabledBorder: InputBorder.none,
             errorBorder: InputBorder.none,
             focusedBorder: InputBorder.none,
             focusedErrorBorder: InputBorder.none,
             prefixIcon: Icon(Icons.phone,size:23.sp,color:const Color.fromARGB(255, 247, 238, 238)),
        ),
        style: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),

        ),
      ),
      SizedBox(height: 22.h,),
      
      Center(
        child: MaterialButton(onPressed: (){
          if(_name.text.isEmpty || _number.text.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fill all the fields",)));
          }
          else if (_number.text.length<10 ||_number.text.startsWith("+91")){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Check your phone number",)));
          }
          else if(_name.text.length<4){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Name must be greater than 3 characters ",)));
          }
          else{
            showLoaderDialog(context);

            _verify();


          }
          
          
        },
        height: 6.h,minWidth: 70.w,
        child: Text("Request OTP",style:GoogleFonts.poppins(fontSize:14.sp,fontWeight: FontWeight.w700,color:Colors.black)),
        color:Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      )
      
      
     
    ],)

    )
      
    );

    
  }


}