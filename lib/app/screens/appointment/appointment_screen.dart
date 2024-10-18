import 'package:flutter/material.dart';
import 'package:iclinix/app/screens/appointment/components/clinic_content_card.dart';
import 'package:iclinix/app/widget/common_widgets.dart';
import 'package:iclinix/app/widget/custom_app_bar.dart';
import 'package:flutter_slide_drawer/flutter_slide_widget.dart';
import 'package:iclinix/utils/sizeboxes.dart';

import '../../widget/custom_drawer_widget.dart';

class AppointmentScreen extends StatelessWidget {
  final bool? isBackButton;

  AppointmentScreen({super.key, this.isBackButton});

  final GlobalKey<SliderDrawerWidgetState> drawerKey = GlobalKey<SliderDrawerWidgetState>();

  @override
  Widget build(BuildContext context) {
    return SliderDrawerWidget(
      key: drawerKey,
      drawer: const CustomDrawer(),
      option: SliderDrawerOption(
        backgroundColor: Theme.of(context).primaryColor,
        sliderEffectType: SliderEffectType.Rounded,
        upDownScaleAmount: 30,
        radiusAmount: 30,
        direction: SliderDrawerDirection.LTR,
      ),
      body: Scaffold(
        appBar: CustomAppBar(
          title: isBackButton! ? 'Select Clinic' : 'Schedule Appointment',
          isBackButtonExist: isBackButton!,
          menuWidget: const Row(
            children: [
              NotificationButton(),
            ],
          ),
          drawerButton: CustomMenuButton(tap: () {
            drawerKey.currentState!.toggleDrawer();
          }),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const ClinicContentCard(),
                    sizedBox100(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

