import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:infleuncer/view/screens/splash.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';


void main ()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  var dir = await getApplicationDocumentsDirectory();
 Hive.init(dir.path);
 await Hive.openBox("user");
  runApp(const Influence());
}


class Influence extends StatelessWidget {
  const Influence({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return MaterialApp(debugShowCheckedModeBanner: false,
        title: "Influence",
        theme: ThemeData(
          scaffoldBackgroundColor:Colors.black,
          appBarTheme:  const AppBarTheme(color: Colors.black,
          elevation: 0,
          ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),),
          
        home: const Splash(),


      );

    })
      
    );
  }
}



