import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iclinix/app/screens/diabetic/components/add_health_goal.dart';
import 'package:iclinix/app/screens/diabetic/components/add_sugar_levels_dialog.dart';
import 'package:iclinix/app/screens/diabetic/components/routine_component.dart';
import 'package:iclinix/app/screens/diabetic/components/sugar_chart.dart';
import 'package:iclinix/app/widget/common_widgets.dart';
import 'package:iclinix/app/widget/custom_app_bar.dart';
import 'package:flutter_slide_drawer/flutter_slide_widget.dart';
import 'package:iclinix/app/widget/custom_button_widget.dart';
import 'package:iclinix/app/widget/custom_containers.dart';
import 'package:iclinix/app/widget/custom_drawer_widget.dart';
import 'package:iclinix/controller/appointment_controller.dart';
import 'package:iclinix/controller/diabetic_controller.dart';
import 'package:iclinix/helper/route_helper.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/images.dart';
import 'package:iclinix/utils/sizeboxes.dart';
import 'package:iclinix/utils/styles.dart';
import 'package:get/get.dart';
import 'package:iclinix/utils/themes/light_theme.dart';
import 'components/health_parameter_dialog.dart';
import 'components/resources_component.dart';


class DiabeticDashboard extends StatelessWidget {
  DiabeticDashboard({super.key});
  final GlobalKey<SliderDrawerWidgetState> drawerKey = GlobalKey<SliderDrawerWidgetState>();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<DiabeticController>().getDiabeticDashboard();

    });
    return SliderDrawerWidget(
      key: drawerKey,
      option: SliderDrawerOption(
        backgroundColor: Theme.of(context).primaryColor,
        sliderEffectType: SliderEffectType.Rounded,
        upDownScaleAmount: 30,
        radiusAmount: 30,
        direction: SliderDrawerDirection.LTR,
      ),
      drawer: const CustomDrawer(),
      body: Scaffold(
          appBar: CustomAppBar(
            title: 'Diabetic',
            iconColor: Theme.of(context).primaryColor,
            drawerButton: CustomMenuButton(tap: () {
              drawerKey.currentState!.toggleDrawer();
            }),
            menuWidget:  Row(
              children: [
                PopupMenuButton<String>(
                  icon: Icon(CupertinoIcons.add,color: Theme.of(context).primaryColor,),
                  onSelected: (String value) {
                    print('Selected: $value');
                  },
                  itemBuilder: (BuildContext context) => [
                     PopupMenuItem<String>(
                      onTap: () {
                        Get.dialog(AddSugarLevelsDialog());
                      },
                      value: 'Add Sugar',
                      child: const Text('Add Sugar'),
                    ),
                     PopupMenuItem<String>(
                       onTap: () {
                         Get.dialog(AddSugarLevelsDialog(isBp: true,));
                       },
                      value: 'Add Bp',
                      child: const Text('Add Bp'),
                    ),
                     PopupMenuItem<String>(
                       onTap: () {
                         Get.dialog(const AddHealthParameterDialog());
                       },
                      value: 'Add Health Data',
                      child: const Text('Add Health Data'),
                    ),
                  ],
                ),
                sizedBoxW15(),

                const NotificationButton()
              ],
            ),
          ),
          body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: GetBuilder<DiabeticController>(builder: (diabeticControl) {
                  final sugarList = diabeticControl.sugarChartList;
                  final isListEmpty = sugarList == null || sugarList.isEmpty;
                  final isSugarLoading = diabeticControl.isDailySugarCheckupLoading;
                  final planDetails = diabeticControl.planDetails;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomButtonWidget(
                        useGradient: true,
                        gradient: const LinearGradient(
                          colors: [Color(0xff67D7C3), Color(0xff19BB94)],
                          stops: [0, 1],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        buttonText: 'Book Appointment',
                        onPressed: () {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text('Diabetic Clinic currently unavailable.'),
                          //   ),
                          // );
                          Get.find<AppointmentController>().selectBookingType(true);
                          Get.toNamed(RouteHelper.getAllClinicRoute(isBackButton: true));
                        },
                      ),
                      sizedBox10(),
                      Container(
                        width: Get.size.width,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage(Images.icDiabeticBg),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(Dimensions.radius10)),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                diabeticControl.planDetails != null
                                    ? diabeticControl.planDetails!.planName.toString()
                                    : "N/A",
                                style: openSansRegular.copyWith(
                                    color: Theme.of(context).cardColor,
                                    fontSize: Dimensions.fontSizeDefault),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Your Plan Expires in ",
                                      style: openSansRegular.copyWith(
                                        fontSize: Dimensions.fontSize12,
                                        color: yellowColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: diabeticControl.planDetails != null
                                          ? "${diabeticControl.planDetails!.duration.toString()} Month"
                                          : "N/A", // Provide a fallback value if planDetails is null
                                      style: openSansSemiBold.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: yellowColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      sizedBoxDefault(),
                      // Row(
                      //   children: [
                      //     Flexible(
                      //       child: CustomButtonWidget(
                      //         buttonText: 'Blood Sugar Level',
                      //         onPressed: () {
                      //           Get.dialog(AddSugarLevelsDialog());
                      //         },
                      //         isBold: false,
                      //         fontSize: Dimensions.fontSize14,
                      //         transparent: true,
                      //       ),
                      //     ),
                      //     sizedBoxW15(),
                      //     Flexible(
                      //       child: CustomButtonWidget(
                      //         buttonText: 'Health Parameters',
                      //         onPressed: () {
                      //           Get.dialog(AddHealthParameterDialog());
                      //         },
                      //         isBold: false,
                      //         fontSize: Dimensions.fontSize14,
                      //         transparent: true,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // sizedBoxDefault(),

                      // Check for null or empty list
                      if (!isListEmpty) ...[
                        const Text('Today’s Blood Sugar Parameters',
                            style: openSansSemiBold),
                        sizedBoxDefault(),
                        SugarChart(),
                      ],
                      sizedBoxDefault(),
                      const AddHealthGoal(),

                      // sizedBoxDefault(),
                      // const RoutineComponent(),
                      sizedBoxDefault(),
                      // const CurrentMedicationComponent(),
                      // sizedBoxDefault(),
                      const ResourcesComponent(),
                      sizedBox100(),
                    ],
                  );
                }),
              ))),
    );
  }
}
