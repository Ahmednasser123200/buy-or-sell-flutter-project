
import 'package:buysell/Screens/authenfiktcation/categories/category_list.dart';
import 'package:buysell/Screens/product_details_screen.dart';
import 'package:buysell/Screens/sellitems/seller_category_list.dart';
import 'package:buysell/Screens/sellitems/seller_subCat.dart';
import 'package:buysell/forms/forms_screen.dart';
import 'package:buysell/forms/seller_car_form.dart';
import 'package:buysell/provider/cat_provider.dart';
import 'package:buysell/provider/product_provider.dart';
import 'package:buysell/services/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/Splash_Screen.dart';
import 'Screens/authenfiktcation/categories/subCat_screen.dart';
import 'Screens/authenfiktcation/email_auth_screen.dart';
import 'Screens/authenfiktcation/phoneauth_screen.dart';
import 'Screens/home_screen.dart';
import 'Screens/location_screen.dart';
import 'Screens/product_by_category_screen.dart';
import 'firebase_options.dart';
import 'forms/user_review_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,
  );
  Provider.debugCheckInvalidValueType = null;

  runApp(
     MultiProvider(providers: [
       Provider(create: (_) =>CategoryProvider()),
       Provider(create: (_) =>ProductProvider()),

     ],child:MaterialApp(
       debugShowCheckedModeBanner: false,
       routes: {
         LoginScreen.id : (context) => LoginScreen(),
         SplashScreen.id : (context) => SplashScreen(),
         PhoneAuthScreen.id:(context)=> PhoneAuthScreen(),
         Locationscreen.id:(context)=> Locationscreen(),
         HomeScreen.id:(context)=> HomeScreen(),
         EMailAuthScreen.id:(context)=> EMailAuthScreen(),
         categoryListScreen.id:(context)=> categoryListScreen(),
         SubCatList.id:(context)=> SubCatList(),
         MainScreen.id:(context)=> MainScreen(),
         SellerSUbCatList.id:(context)=> SellerSUbCatList(),
         SellerCategory.id:(context)=> SellerCategory(),
         SellercarForm.id:(context)=> SellercarForm(),
         UserReviewScreen.id:(context)=> UserReviewScreen(),
         FormsScreen.id:(context)=> FormsScreen(),
         ProductDetailsScreen.id:(context)=> ProductDetailsScreen(),
         productByCategory.id:(context)=> productByCategory(),








         //EmailVerificationScreen.id:(context)=> EmailVerificationScreen(),

       },

       home: ScreenUtilInit(
         designSize: Size(360, 690),
         builder: (context,num) {
           return MyApp(); // Remove the extra comma here
         },
       ),
     ) ,)


  );
}



class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
     Future.delayed(
        const Duration(seconds: 3),
            () => Navigator.push(
          context as BuildContext,
          MaterialPageRoute(builder: (context) =>LoginScreen()),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new  SplashScreen();
  }
}