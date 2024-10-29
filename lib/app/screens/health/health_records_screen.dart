import 'package:flutter/material.dart';
import 'package:iclinix/app/screens/appointment/appointment_details_screen.dart';
import 'package:iclinix/app/widget/custom_app_bar.dart';
import 'package:flutter_slide_drawer/flutter_slide_widget.dart';
import 'package:iclinix/app/widget/custom_button_widget.dart';
import 'package:iclinix/app/widget/custom_drawer_widget.dart';
import 'package:iclinix/app/widget/custom_image_widget.dart';
import 'package:iclinix/app/widget/empty_data_widget.dart';
import 'package:iclinix/app/widget/loading_widget.dart';
import 'package:iclinix/controller/appointment_controller.dart';
import 'package:iclinix/helper/date_converter.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/images.dart';
import 'package:iclinix/utils/sizeboxes.dart';
import 'package:iclinix/utils/styles.dart';
import 'package:get/get.dart';
import 'package:iclinix/utils/themes/light_theme.dart';

class HealthRecordsScreen extends StatelessWidget {
  HealthRecordsScreen({super.key});
  final GlobalKey<SliderDrawerWidgetState> drawerKey = GlobalKey<SliderDrawerWidgetState>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AppointmentController>().getAppointmentHistory();
    });

    return GetBuilder<AppointmentController>(builder: (appointmentControl) {
      final appointmentHistoryList = appointmentControl.appointmentHistoryList;
      final isListEmpty = appointmentHistoryList == null || appointmentHistoryList.isEmpty;
      final isLoading = appointmentControl.isAppointmentHistoryLoading;

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
        body: isLoading
            ? const LoadingWidget()
            : Stack(
          children: [
            Scaffold(
              appBar: CustomAppBar(
                title: 'Recent Appointments',
                drawerButton: CustomMenuButton(tap: () {
                  drawerKey.currentState!.toggleDrawer();
                }),
              ),
              body: isListEmpty
                  ? Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSize100),
                child: Center(
                  child: EmptyDataWidget(
                    text: 'Nothing Available', // Change this text if needed
                    image: Images.icEmptyDataHolder,
                    fontColor: Theme.of(context).disabledColor,
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: appointmentHistoryList.length,
                itemBuilder: (_, i) {
                  final appointment = appointmentHistoryList[i];
                  final patientAppointments = appointment.patientAppointments;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        patientAppointments.isNotEmpty ?
                        ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: patientAppointments.length,
                          itemBuilder: (_, j) {
                            final patientAppointment = patientAppointments[j];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppointmentDateTimeConverter.formatDate(patientAppointment.opdDate.toString())} - ${patientAppointment.opdTime.toString()}',
                                  style: openSansBold.copyWith(
                                    fontSize: Dimensions.fontSize13,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                sizedBox20(),
                                GestureDetector(onTap: () {
                                  Get.to(AppointmentDetailsScreen(appointmentHistoryModel: appointmentHistoryList[i],));

                                },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomNetworkImageWidget(
                                        height: 80,
                                        width: 80,
                                        image: patientAppointment.branchImage,
                                      ),
                                      sizedBoxW10(),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Branch: ",
                                                    style: openSansRegular.copyWith(
                                                      fontSize: Dimensions.fontSize12,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: patientAppointment.branchName,
                                                    style: openSansBold.copyWith(
                                                      fontSize: Dimensions.fontSize13,
                                                      color: Theme.of(context).disabledColor.withOpacity(0.70),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            sizedBox10(),
                                            RichText(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Patient: ",
                                                    style: openSansRegular.copyWith(
                                                      fontSize: Dimensions.fontSize12,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '${appointment.firstName} ${appointment.lastName}',
                                                    style: openSansBold.copyWith(
                                                      fontSize: Dimensions.fontSize13,
                                                      color: Theme.of(context).disabledColor.withOpacity(0.70),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            sizedBox10(),
                                            RichText(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Patient Id: ",
                                                    style: openSansRegular.copyWith(
                                                      fontSize: Dimensions.fontSize12,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: patientAppointment.patientId.toString(),
                                                    style: openSansBold.copyWith(
                                                      fontSize: Dimensions.fontSize13,
                                                      color: Theme.of(context).disabledColor.withOpacity(0.70),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            sizedBox10(),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.to(AppointmentDetailsScreen(appointmentHistoryModel: appointmentHistoryList[i],));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).primaryColor ,
                                                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'View Details',
                                                      style: openSansSemiBold.copyWith(
                                                        fontSize: Dimensions.fontSize14,
                                                        color: Theme.of(context).cardColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }, separatorBuilder: (BuildContext context, int index) => sizedBox10(),
                        )
                            : const Padding(
                          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                          child: Center(child: Text('')),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
