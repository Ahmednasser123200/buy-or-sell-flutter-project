import 'package:buysell/Screens/product_list.dart';
import 'package:buysell/Screens/product_list_home.dart';
import 'package:buysell/widgets/banner_widget.dart';
import 'package:buysell/widgets/custom_appBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../provider/cat_provider.dart';
import '../widgets/category_widget.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "Home_Screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String? address;

  // getAdderss() async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       widget.locationData!.latitude!,
  //       widget.locationData!.longitude!,
  //     );
  //
  //     // Update the UI with the result
  //     setState(() {
  //       address = placemarks.isNotEmpty ? placemarks[0].country : "Unknown";
  //     });
  //
  //     print(placemarks[0].country);
  //   } catch (e) {
  //     // Handle the error gracefully
  //     print("Error during geocoding: $e");
  //
  //     // Update the UI with an error message
  //     setState(() {
  //       address = "Error during geocoding";
  //     });
  //   }
  // }
  // @override
  // void initState() {
  //   getAdderss();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);
    _catProvider.clearSelectedCat();

    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(56.h),
            child: SafeArea(child: CustomAppBar())),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Column(
                    children: [BannerWidget(), Categorywidget()],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ProductListhome(),
            ],
          ),
        ));
  }
}
