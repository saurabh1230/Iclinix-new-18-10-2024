import 'package:flutter/material.dart';
import 'package:iclinix/app/screens/appointment/components/select_slot_card.dart';
import 'package:iclinix/app/widget/common_widgets.dart';
import 'package:iclinix/app/widget/custom_app_bar.dart';
import 'package:iclinix/app/widget/custom_button_widget.dart';
import 'package:iclinix/app/widget/custom_snackbar.dart';
import 'package:iclinix/app/widget/custom_textfield.dart';
import 'package:iclinix/controller/appointment_controller.dart';
import 'package:iclinix/controller/profile_controller.dart';
import 'package:iclinix/helper/route_helper.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/sizeboxes.dart';
import 'package:get/get.dart';
import '../../../data/models/response/clinic_model.dart';
import 'components/select_slot_time_component.dart';

class SelectSlotScreen extends StatelessWidget {
  final ClinicModel? clinicModel;
   SelectSlotScreen({super.key, this.clinicModel});
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBar(title: 'Select Slot',isBackButtonExist: true,
      ),
      body: GetBuilder<ProfileController>(builder: (profileControl) {
        return SingleChildScrollView(
            child: GetBuilder<AppointmentController>(builder: (appointmentControl) {
              return  Column(
                children: [
                   SelectSlotCard(clinicModel: clinicModel,),
                  Padding( padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        sizedBoxDefault(),
                        const Text('APPOINTMENT DATE',),
                        const SizedBox(height: 5),
                        CustomTextField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: appointmentControl.selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              appointmentControl.updateDate(pickedDate);
                              _dateController.text = appointmentControl.formattedDate.toString();
                            }
                          },
                          hintText: 'Select',
                          isCalenderIcon: true,
                          editText: true,
                        ),
                        sizedBox20(),
                        SelectSlotTimeComponent(),
                        sizedBox30(),
                        CustomButtonWidget(buttonText: 'Continue',
                          onPressed: () {
                          if(_dateController.text.isNotEmpty && appointmentControl.selectedTime!.isNotEmpty) {
                            Get.toNamed(RouteHelper.getAddPatientDetailsRoute(_dateController.text,
                                appointmentControl.selectedTime,clinicModel!.id.toString()));
                          } else {
                            showCustomSnackBar('Please Add Appointment Date and Time');
                          }

                          },),
                        sizedBox40(),



                      ],
                    ),
                  ),


                ],
              );
            })




        );
      }),




    );
  }
}
