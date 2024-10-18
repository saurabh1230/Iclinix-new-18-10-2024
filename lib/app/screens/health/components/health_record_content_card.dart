
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iclinix/app/widget/custom_image_widget.dart';
import 'package:iclinix/app/widget/empty_data_widget.dart';
import 'package:iclinix/controller/appointment_controller.dart';
import 'package:iclinix/controller/profile_controller.dart';
import 'package:iclinix/helper/date_converter.dart';
import 'package:iclinix/utils/app_constants.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/images.dart';
import 'package:iclinix/utils/sizeboxes.dart';
import 'package:iclinix/utils/styles.dart';
import 'package:get/get.dart';


class HealthRecordContentCard extends StatelessWidget {
  const HealthRecordContentCard({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AppointmentController>().getAppointmentHistory();
    });

    return GetBuilder<AppointmentController>(builder: (appointmentControl) {
      final dataList = appointmentControl.appointmentHistoryList;
      final isListEmpty = dataList == null || dataList.isEmpty;
      final isLoading = appointmentControl.isAppointmentHistoryLoading;
      return isListEmpty && !isLoading
          ? Padding(
        padding: const EdgeInsets.only(top: Dimensions.paddingSize100),
        child: Center(
            child: EmptyDataWidget(
              text: 'Nothing Available',
              image: Images.icEmptyDataHolder,
              fontColor: Theme.of(context).disabledColor,
            )),
      )
          : isLoading
          ? const Center(child: CircularProgressIndicator())
          :
         ListView.builder(
           shrinkWrap: true,
           itemCount: dataList!.length,
             itemBuilder: (_,i) {
             print('${dataList[i].patientAppointments[0].branchImage.toString()}');
           return Padding(
             padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
             child: Column(crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('${AppointmentDateTimeConverter.formatDate(dataList[i].regDate.toString())} - ${dataList[i].regTime.toString()}',style: openSansBold.copyWith(
                     fontSize: Dimensions.fontSize13,color: Theme.of(context).primaryColor
                 ),),
                 sizedBox10(),
                 Row(
                   children: [
                     CustomNetworkImageWidget(
                       height: 80,width: 80,
                       image: dataList[i].patientAppointments[0].branchImage.toString(),),
                     sizedBoxW10(),
                     Expanded(
                       child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           RichText(
                             maxLines: 3,
                             overflow: TextOverflow.ellipsis,
                             text: TextSpan(
                               children: [
                                 TextSpan(
                                   text: "Branch Name: ",
                                   style: openSansRegular.copyWith(
                                       fontSize: Dimensions.fontSize12,
                                       color: Theme.of(context).primaryColor), // Different color for "resend"
                                 ),
                                 TextSpan(
                                   text: dataList[i].patientAppointments[0].branchName.toString(),
                                   style: openSansBold.copyWith(
                                       fontSize: Dimensions.fontSize13,
                                       color: Theme.of(context).disabledColor.withOpacity(0.70)), // Different color for "resend"
                                 ),
                               ],
                             ),
                           ),
                           RichText(
                             maxLines: 3,
                             overflow: TextOverflow.ellipsis,
                             text: TextSpan(
                               children: [
                                 TextSpan(
                                   text: "Patient: ",
                                   style: openSansRegular.copyWith(
                                       fontSize: Dimensions.fontSize12,
                                       color: Theme.of(context).primaryColor), // Different color for "resend"
                                 ),
                                 TextSpan(
                                   text: '${dataList[i].firstName} ${dataList[i].lastName}',
                                   style: openSansBold.copyWith(
                                       fontSize: Dimensions.fontSize13,
                                       color: Theme.of(context).disabledColor.withOpacity(0.70)), // Different color for "resend"
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     )
                   ],
                 ),
               ],
             ),
           );

        });
    });


  }
}
