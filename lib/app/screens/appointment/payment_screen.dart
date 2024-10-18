import 'package:flutter/material.dart';
import 'package:iclinix/app/screens/appointment/components/booking_summary_widget.dart';
import 'package:iclinix/app/widget/common_widgets.dart';
import 'package:iclinix/app/widget/custom_app_bar.dart';
import 'package:iclinix/app/widget/custom_button_widget.dart';
import 'package:iclinix/app/widget/custom_textfield.dart';
import 'package:iclinix/controller/appointment_controller.dart';
import 'package:iclinix/controller/auth_controller.dart';
import 'package:iclinix/data/models/body/appointment_model.dart';
import 'package:iclinix/helper/route_helper.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/sizeboxes.dart';
import 'package:iclinix/utils/styles.dart';
import 'package:get/get.dart';

import '../../widget/group_radio_button.dart';

class PaymentScreen extends StatelessWidget {
  final AppointmentModel appointmentModel;

  PaymentScreen({super.key, required this.appointmentModel});

  final _referralController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentController>(builder: (appointmentControl) {
      return Scaffold(
        appBar: const CustomAppBar(
            isBackButtonExist: true,
            title: 'Payment Method',
            menuWidget: Row(
              children: [
                NotificationButton(),
              ],
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Referral Code (Optional)',
                  style: openSansRegular.copyWith(
                      color: Theme.of(context).hintColor,
                      fontSize: Dimensions.fontSize14),
                ),
                sizedBox5(),
                CustomTextField(
                  controller: _referralController,
                  hintText: 'Apply Referral Code',
                ),
                sizedBoxDefault(),
                BookingSummaryWidget(
                  patientName:
                      '${appointmentModel.firstName}${appointmentModel.lastName}',
                  appointmentDate: '${appointmentModel.appointmentDate}',
                  appointmentTime: '${appointmentModel.appointmentTime}',
                  bookingFee: '500',
                ),
                sizedBoxDefault(),

                Obx(() {
                  return CustomRadioButton(
                    items: appointmentControl.paymentMethods,
                    selectedValue: appointmentControl
                        .selectedPaymentMethod.value, // Unwrap RxString
                    onChanged: (value) {
                      appointmentControl.selectPaymentMethod(
                          value!); // Update the selected payment method
                      // Print the selected payment method
                      print(
                          'Selected Payment Method: ${appointmentControl.selectedPaymentMethod.value}');
                    },
                  );
                }),

                // sizedBoxDefault(),
                // Text('PAY NOW',style: openSansRegular.copyWith(color: Theme.of(context).hintColor,
                //     fontSize: Dimensions.fontSize14),),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: SingleChildScrollView(
            child: CustomButtonWidget(
              buttonText: 'Confirm Booking',
              onPressed: () {
                appointmentControl.bookAppointmentApi(appointmentModel);
              },
              fontSize: Dimensions.fontSize14,
              isBold: false,
            ),
          ),
        ),
      );
    });
  }
}
