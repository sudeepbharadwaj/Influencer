import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infleuncer/model/maindb.dart';
import 'package:infleuncer/model/personaldb.dart';
import 'package:sizer/sizer.dart';

import 'nointernet.dart';


// ignore: camel_case_types
class editprofile extends StatefulWidget {
  const editprofile({ Key? key }) : super(key: key);

  @override
  State<editprofile> createState() => _editprofileState();
}

// ignore: camel_case_types
class _editprofileState extends State<editprofile> {

final _name=TextEditingController();
final _businessname=TextEditingController();
final _instagram=TextEditingController();
final _website=TextEditingController();
final _description=TextEditingController();
final _gmail=TextEditingController();

  final PerHelper _perHelper=PerHelper();

  final MainHelper _mainHelper=MainHelper.instance;


 final _categorylst=["Food","Education","Fashion","Gift"];

 var _categorytxt;

 final CollectionReference _user=FirebaseFirestore.instance.collection("data");

  StreamSubscription? connectivitySubscription;

 ConnectivityResult? oldres;

var _data;


void _getlikes()async{
 _data=await _perHelper.getdatawithkey(_perHelper.getdatawithkey('id'))['like'];
 if(await _perHelper.getdatawithkey(_perHelper.getdatawithkey("id"))['category']!='Select Category'){
   if(mounted){
     setState(() {
       _categorytxt=_perHelper.getdatawithkey(_perHelper.getdatawithkey("id"))['category'];
     });
   }
 }
 

 
}


 @override 
 void initState(){
   super.initState();
  _getlikes();
   // _data=_mainHelper.queryspecific(_gmail.text);
    //print(_data);

   connectivitySubscription=Connectivity().onConnectivityChanged.listen((ConnectivityResult resnow) {
      if(resnow==ConnectivityResult.none){
      
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Nointernet()));
        
      

      }else if (oldres==ConnectivityResult.none){

         
        

        
      }

     
     
      oldres=resnow;
   });
 }


@override
void dispose(){
  super.dispose();
  connectivitySubscription!.cancel();


}




  Future setData()async{
   await  _user.doc(_perHelper.getdatawithkey("id").toString()).update({
      'name':_name.text,
      "business_name":_businessname.text,
      "gmail":_gmail.text,
      "Category":_categorytxt.toString(),
      'instagram_link':_instagram.text,
      'website_link':_website.text,
      "description":_description.text,
      "last_updated":DateTime.now(),
      

});

  await _perHelper.putdatawithkey(_perHelper.getdatawithkey('id').toString(),{
     'name':_name.text,
      "business_name":_businessname.text,
      "gmail":_gmail.text,
      "category":_categorytxt.toString(),
      'instagram_link':_instagram.text,
      'website_link':_website.text,
      "description":_description.text,
      'like':_data,
      "last_updated":DateTime.now(),
      
    });

}




  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
    appBar:  AppBar(title: Text("Profile",style: GoogleFonts.poppins(fontSize:15.sp,fontWeight:FontWeight.w600,color: Colors.white,letterSpacing: 0.6),),
   
    ),
    body: FutureBuilder(future:_perHelper.getdata('id'),
    builder:  (BuildContext context,AsyncSnapshot snapshot){
      if(snapshot.hasData){
        return SafeArea(minimum: EdgeInsets.only(left:4.w,right: 4.w),
          
          child:SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 2.h,),
                              Center(child:Padding(
                padding:  EdgeInsets.only(bottom: 0.7.h),
                child: CircleAvatar(radius: 29,
                backgroundColor: const Color.fromARGB(255, 87, 155, 141),
                child: Center(child:Text(snapshot.data['name'].toString().substring(0,1),style: GoogleFonts.poppins(fontSize:23.sp,fontWeight: FontWeight.w600,color:Colors.white,)),
      
            ),
            ),
              ),),

              SizedBox(height: 2.h,),

               Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children:[ Container(padding: EdgeInsets.only(top:0.5.h,left: 1.5.w),
                       height: 7.h,width: 40.w,
                       decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(221, 37, 36, 36),style: BorderStyle.solid),
                         borderRadius: BorderRadius.circular(14),
                         color: Colors.white12,
                         
               
                       ),
                       child: TextField(cursorColor:const Color.fromARGB(255, 247, 238, 238),controller: _name..text="${snapshot.data['name']}",textInputAction: TextInputAction.next,
                       decoration: InputDecoration(
                         
                         hintText: "Your name",
                         hintStyle: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),
                         
                         border:InputBorder.none,
                         enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            
                       ),
                       style: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),
               
                       ),
                     ),



                     Container(padding: EdgeInsets.only(top:0.5.h,left: 1.5.w),
        height: 7.h,width: 40.w,
        decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(221, 37, 36, 36),style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(14),
          color: Colors.white12,
          

        ),
        child: TextField(cursorColor:const Color.fromARGB(255, 247, 238, 238),controller:_businessname..text='${snapshot.data['business_name']}'
        ,textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Business name",
          hintStyle: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),
          
          border:InputBorder.none,
          enabledBorder: InputBorder.none,
             disabledBorder: InputBorder.none,
             errorBorder: InputBorder.none,
             focusedBorder: InputBorder.none,
             focusedErrorBorder: InputBorder.none,
            
        ),
        style: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),

        ),
      ),

                 ]),

                       SizedBox(height: 6.h,),

               Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children:[ Container(padding: EdgeInsets.only(top:0.5.h,left: 1.5.w),
                       height: 7.h,width: 40.w,
                       decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(221, 37, 36, 36),style: BorderStyle.solid),
                         borderRadius: BorderRadius.circular(14),
                         color: Colors.white12,
                         
               
                       ),
                       child:DropdownButton(items:_categorylst.map((String dropDownStringItem) {
                         return DropdownMenuItem <String>(
                           value:dropDownStringItem,
                           child: Text(dropDownStringItem),

                         );

                       }).toList(),
                       onChanged: (_value){
                         print(_value);
                         setState(() {
                         _categorytxt=_value;
                           
                         });

                       },
                       underline: Container(),
                       icon:Container(),
                       value: _categorytxt,
                       dropdownColor: Colors.black,
                       style: GoogleFonts.poppins(fontSize:11.sp,fontWeight:FontWeight.w600,color:Colors.white,),
                       
                       hint:Text(_perHelper.getdatawithkey(_perHelper.getdatawithkey('id'))['category'].toString(),style: GoogleFonts.poppins(fontSize:11.sp,fontWeight:FontWeight.w600,color:Colors.white,),
                       )
                       )
                     ),



                     Container(padding: EdgeInsets.only(top:0.5.h,left: 1.5.w),
        height: 7.h,width: 40.w,
        decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(221, 37, 36, 36),style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(14),
          color: Colors.white12,
          

        ),
        child: TextField(cursorColor:const Color.fromARGB(255, 247, 238, 238),controller:_gmail..text='${snapshot.data['gmail']}'
        ,textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Gmail ID",
          hintStyle: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),
          
          border:InputBorder.none,
          enabledBorder: InputBorder.none,
             disabledBorder: InputBorder.none,
             errorBorder: InputBorder.none,
             focusedBorder: InputBorder.none,
             focusedErrorBorder: InputBorder.none,
             
            
        ),
        style: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),
        keyboardType: TextInputType.emailAddress,

        ),
      ),

                 ]),


                 SizedBox(height: 6.h,),


                 
               Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children:[ Container(padding: EdgeInsets.only(top:0.5.h,left: 1.5.w),
                       height: 7.h,width: 40.w,
                       decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(221, 37, 36, 36),style: BorderStyle.solid),
                         borderRadius: BorderRadius.circular(14),
                         color: Colors.white12,
                         
               
                       ),
                       child: TextField(cursorColor:const Color.fromARGB(255, 247, 238, 238),controller: _instagram..text="${snapshot.data['instagram_link']}",textInputAction: TextInputAction.next,
                       decoration: InputDecoration(
                         
                         hintText: "Instagram Link",
                         hintStyle: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),
                         
                         border:InputBorder.none,
                         enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            
                       ),
                       style: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),
                       keyboardType: TextInputType.url,
               
                       ),
                     ),



                     Container(padding: EdgeInsets.only(top:0.5.h,left: 1.5.w),
        height: 7.h,width: 40.w,
        decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(221, 37, 36, 36),style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(14),
          color: Colors.white12,
          

        ),
        child: TextField(cursorColor:const Color.fromARGB(255, 247, 238, 238),controller:_website..text='${snapshot.data['website_link']}'
        ,textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Webiste Link",
          hintStyle: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),
          
          border:InputBorder.none,
          enabledBorder: InputBorder.none,
             disabledBorder: InputBorder.none,
             errorBorder: InputBorder.none,
             focusedBorder: InputBorder.none,
             focusedErrorBorder: InputBorder.none,
            
        ),
        style: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),
        keyboardType: TextInputType.url,

        ),
      ),

                 ]),

                  


      SizedBox(height: 6.h,),

        Container(padding: EdgeInsets.only(top:0.5.h,left: 1.5.w),
        height: 40.h,width: 80.w,
        decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(221, 37, 36, 36),style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(14),
          color: Colors.white12,
          

        ),
        child: TextField(cursorColor:Color.fromRGBO(247, 238, 238, 1),controller:_description..text='${snapshot.data['description']}'
        ,textInputAction: TextInputAction.done,
        maxLength: 200,
        maxLines: 10,
        minLines: 2,

        decoration: InputDecoration(
          hintText: "Tell us about your Business",
          hintStyle: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),
          
          border:InputBorder.none,
          enabledBorder: InputBorder.none,
             disabledBorder: InputBorder.none,
             errorBorder: InputBorder.none,
             focusedBorder: InputBorder.none,
             focusedErrorBorder: InputBorder.none,
            
        ),
        style: GoogleFonts.poppins(fontSize:11.sp,color:const Color.fromARGB(255, 247, 238, 238),fontWeight: FontWeight.w600,letterSpacing: 0.7),
        keyboardType: TextInputType.multiline,

        ),
      ),


      SizedBox(height: 5.h,),

       MaterialButton(onPressed: (){
         if(_name.text.isEmpty || _businessname.text.isEmpty || _gmail.text.isEmpty || _instagram.text.isEmpty || _website.text.isEmpty || _description.text.isEmpty || _categorytxt=='Select Category'){
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fill all the fields",)));

         }
         else if(_name.text.length<4 || !_gmail.text.contains('@') || !_instagram.text.contains('https') || !_website.text.contains("https")){
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Check all the fields")));

         }

         else if(_description.text.length<50){
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tell us about yourself atleast in 50 words",)));


         }

         else{
           setData().whenComplete(() {
             Navigator.pop(context);

           }).onError((error, stackTrace) {

           });
         }
                  
                  
                },
                color: Colors.white,
                height: 7.h,minWidth: 60.w,
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                child: 
                Text("Done",style: GoogleFonts.poppins(fontSize:15.sp,fontWeight: FontWeight.w600,letterSpacing: 0.5,color:Colors.black),)
                ,),
                SizedBox(height: 1.h,)

              ],
            )
            
          )
        );
      
      }


      else {
        return const CircularProgressIndicator(color:Color.fromARGB(255, 147, 233, 150));
      }
    }


    )
    
    
      
    );
  }
}