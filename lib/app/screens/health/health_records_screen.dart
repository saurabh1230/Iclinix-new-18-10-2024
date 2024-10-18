import 'package:flutter/material.dart';
import 'package:iclinix/app/widget/custom_app_bar.dart';
import 'package:flutter_slide_drawer/flutter_slide_widget.dart';
import 'package:iclinix/app/widget/custom_drawer_widget.dart';
import 'components/health_record_content_card.dart';

class HealthRecordsScreen extends StatelessWidget {
   HealthRecordsScreen({super.key});
   final GlobalKey<SliderDrawerWidgetState> drawerKey = GlobalKey<SliderDrawerWidgetState>();
  @override
  Widget build(BuildContext context) {
    return SliderDrawerWidget(
      key: drawerKey,
      option: SliderDrawerOption(
        backgroundColor: Theme.of(context).primaryColor,
        sliderEffectType: SliderEffectType.Rounded,
        upDownScaleAmount: 30,
        radiusAmount: 30,
        direction: SliderDrawerDirection.LTR,
      ),
      drawer:   CustomDrawer(),
      body: Scaffold(
        appBar: CustomAppBar(title: 'Health Records',
            drawerButton : CustomMenuButton(tap: () {
              drawerKey.currentState!.toggleDrawer();

            })),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HealthRecordContentCard()

            ],
          ),
        ),
      ),
    );
  }
}
