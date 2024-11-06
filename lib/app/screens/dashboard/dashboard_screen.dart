import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:iclinix/app/screens/appointment/appointment_screen.dart';
import 'package:iclinix/app/screens/dashboard/widgets/nav_bar_item.dart';
import 'package:iclinix/app/screens/diabetic/diabetic_dashboard.dart';
import 'package:iclinix/app/screens/health/health_records_screen.dart';
import 'package:iclinix/app/screens/home/home_screen.dart';
import 'package:iclinix/controller/appointment_controller.dart';
import 'package:iclinix/controller/auth_controller.dart';
import 'package:iclinix/controller/profile_controller.dart';
import 'package:iclinix/helper/route_helper.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/images.dart';

import '../diabetic/diabetic_screen.dart';
import '../profile/profile_screen.dart';


class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  const DashboardScreen({Key? key, required this.pageIndex}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().userDataApi();
    });
    _pageIndex = widget.pageIndex;
    _pageController = PageController(initialPage: widget.pageIndex);
    _initializeScreens();
  }


  Future<void> _initializeScreens() async {
    bool isSubscriptionActive = await Get.find<AuthController>().getSubscriptionStatus();
    _screens = [
      const HomeScreen(),
      isSubscriptionActive ? DiabeticDashboard() : DiabeticScreen(),
      AppointmentScreen(isBackButton: false),
      HealthRecordsScreen(),
      ProfileScreen(),
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: WillPopScope(
        onWillPop: Get.find<AuthController>().handleOnWillPop,
        child: SafeArea(
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getChatRoute());
              },
              child: Image.asset(Images.icChat,
              height: 28,width: 28,),
            ),
            extendBody: true,
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: Container(
              margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSize8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Dimensions.radius20),
              ),
              child: Row(children: [
                BottomNavItem(img: Images.icHome, isSelected: _pageIndex == 0, tap: () => _setPage(0), title: 'Home'),
                BottomNavItem(img: Images.icDiabetic, isSelected: _pageIndex == 1, tap: () => _setPage(1), title: 'Diabetic'),
                BottomNavItem(img: Images.icAppointment, isSelected: _pageIndex == 2, tap: () {
                  Get.find<AppointmentController>().selectBookingType(false);
                  _setPage(2);
                }, title: 'Appointment'),
                BottomNavItem(img: Images.icRecords, isSelected: _pageIndex == 3, tap: () => _setPage(3), title: 'Records'),
                BottomNavItem(img: Images.icProfile, isSelected: _pageIndex == 4, tap: () => _setPage(4), title: 'Profile'),
              ]),
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value  : SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Theme.of(context).primaryColor,
              ),
              child: _screens.isNotEmpty // Check if screens have been initialized
                  ? PageView.builder(
                controller: _pageController,
                itemCount: _screens.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _screens[index];
                },
              )
                  : const Center(child: CircularProgressIndicator()),
            ), // Show loading indicator while initializing
          ),
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}


