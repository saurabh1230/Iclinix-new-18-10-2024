import 'package:flutter/material.dart';
import 'package:iclinix/app/widget/common_widgets.dart';
import 'package:iclinix/app/widget/custom_app_bar.dart';
import 'package:iclinix/app/widget/custom_button_widget.dart';
import 'package:iclinix/app/widget/custom_dropdown_field.dart';
import 'package:iclinix/app/widget/custom_textfield.dart';
import 'package:iclinix/controller/appointment_controller.dart';
import 'package:iclinix/data/models/body/appointment_model.dart';
import 'package:iclinix/helper/route_helper.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/sizeboxes.dart';
import 'package:get/get.dart';
import 'package:iclinix/utils/styles.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

import '../../widget/group_radio_button.dart';

class PatientDetailsScreen extends StatelessWidget {
  final String? appointmentDate;
  final String? appointmentTime;
  final String? clinicId;

  PatientDetailsScreen(
      {super.key,
      required this.appointmentDate,
      required this.appointmentTime,
      required this.clinicId});

  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();
  final _otherProblemController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AppointmentController>().getPatientList();
    });
    return GetBuilder<AppointmentController>(builder: (appointmentControl) {
      return Form(
        key: _formKey,
        child: Scaffold(
          appBar: const CustomAppBar(
            title: 'Patient Details',
            isBackButtonExist: true,
            /*menuWidget: Row(
                children: [
                  NotificationButton(
                    tap: () {},
                  ),
                ],
              )*/
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doctor Consultation Appointment',
                    style: openSansRegular.copyWith(
                        color:
                            Theme.of(context).disabledColor.withOpacity(0.70),
                        fontSize: Dimensions.fontSize14),
                  ),
                  sizedBox10(),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButtonWidget(
                          height: 40,
                          isBold: false,radius: Dimensions.radius5,
                          fontSize: Dimensions.fontSize14,
                          buttonText: 'New Patient',
                          textColor: appointmentControl.isNewPatientEnabled
                              ? Theme.of(context).cardColor
                              : Theme.of(context).primaryColor,
                          onPressed: () {
                            appointmentControl.toggleNewPatientSelection(true);
                          },
                          color: appointmentControl.isNewPatientEnabled
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).cardColor, // Set color based on state
                        ),
                      ),
                      sizedBoxW10(),
                      Expanded(
                        child: CustomButtonWidget(
                          height: 40,
                          isBold: false,radius: Dimensions.radius5,
                          fontSize: Dimensions.fontSize14,
                          textColor: appointmentControl.isNewPatientEnabled
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).cardColor,
                          buttonText: 'Follow Up Patient',
                          onPressed: () {
                            appointmentControl.toggleNewPatientSelection(false);
                          },
                          color: appointmentControl.isNewPatientEnabled
                              ? Theme.of(context).cardColor
                              : Theme.of(context).primaryColor, // Set color based on state
                        ),
                      ),

                      // Expanded(
                      //   child: CustomRadioButton(
                      //     items: appointmentControl.patientList
                      //             ?.map((patient) =>
                      //                 '${patient.firstName} ${patient.lastName}')
                      //             .toList() ??
                      //         [],
                      //     selectedValue:
                      //         appointmentControl.selectedPatient.value,
                      //     onChanged: (value) {
                      //       appointmentControl.togglePatientSelection(value);
                      //       // Handle the radio button change if needed
                      //     },
                      //   ),
                      // ),
                      // Expanded(
                      //   child: CustomDropdown<String>(
                      //     hintText: 'Follow Up Patient',
                      //     items: appointmentControl.patientList?.map((patient) =>
                      //     '${patient.firstName} ${patient.lastName}').toList(),
                      //     onChanged: (value) {
                      //       appointmentControl.togglePatientSelection(value);
                      //       // Handle the dropdown change
                      //     },
                      //   ),
                      // ),
                    ]
                  ),
                  !appointmentControl.isNewPatientEnabled ?
                  Obx(() {
                    final patients = appointmentControl.patientList ?? [];

                    // Set the default selected patient to the first one if no patient is selected yet
                    if (patients.isNotEmpty && appointmentControl.selectedPatient.value.isEmpty) {
                      final firstPatient = patients.first;
                      appointmentControl.selectPatient(firstPatient.id!, '${firstPatient.firstName} ${firstPatient.lastName}');
                    }

                    return CustomRadioButton(
                      items: patients.map((patient) {
                        return '${patient.firstName} ${patient.lastName}';
                      }).toList(),
                      selectedValue: appointmentControl.selectedPatient.value, // Unwrap RxString
                      onChanged: (value) {
                        // Find the selected patient based on the selected name
                        final selectedPatient = patients.firstWhere(
                              (patient) => '${patient.firstName} ${patient.lastName}' == value!,
                        );

                        // Update the selected patient in the controller
                        appointmentControl.selectPatient(selectedPatient.id!, value!);

                        // Print the selected patient ID
                        print('Selected Patient ID: ${appointmentControl.selectedPatientId.value}');
                      },
                    );
                  })


                      : Column( crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sizedBox10(),
                            CustomTextField(
                              showTitle: true,
                              capitalization: TextCapitalization.words,
                              validation: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your First Name';
                                } else if (RegExp(r'[^\p{L}\s]', unicode: true)
                                    .hasMatch(value)) {
                                  return 'Full name must not contain special characters';
                                }
                                return null;
                              },
                              controller: _firstnameController,
                              hintText: 'FIRST NAME',
                            ),
                            sizedBox10(),
                            CustomTextField(
                              showTitle: true,
                              capitalization: TextCapitalization.words,
                              validation: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Last Name';
                                } else if (RegExp(r'[^\p{L}\s]', unicode: true)
                                    .hasMatch(value)) {
                                  return 'Full name must not contain special characters';
                                }
                                return null;
                              },
                              controller: _lastnameController,
                              hintText: 'LAST NAME',
                            ),
                            sizedBox10(),
                            CustomDropdownField(
                              hintText: 'PATIENT GENDER',
                              selectedValue: appointmentControl.selectedGender.isEmpty
                                      ? null
                                      : appointmentControl.selectedGender,
                              options: appointmentControl.genderOptions,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  appointmentControl.updateGender(
                                      newValue); // Update controller
                                }
                              },
                              showTitle: true, // Set to true to show title
                            ),
                            sizedBox10(),
                            const Text(
                              'ENTER PHONE',
                            ),
                            const SizedBox(height: 5),
                            CustomTextField(
                              maxLength: 10,
                              isNumber: true,
                              inputType: TextInputType.number,
                              controller: _phoneController,
                              hintText: "ENTER PHONE",
                              validation: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Phone No';
                                } else if (!RegExp(r'^\d{10}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid 10-digit Phone No';
                                }
                                return null;
                              },
                            ),
                            sizedBox10(),
                            const Text(
                              'PATIENT DOB',
                            ),
                            const SizedBox(height: 5),
                            CustomTextField(
                              controller: _dateController,
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      appointmentControl.selectedDobDate ??
                                          DateTime.now(),
                                  firstDate: DateTime(1900), // Minimum date
                                  lastDate: DateTime
                                      .now(), // Prevents future date selection
                                );

                                if (pickedDate != null &&
                                    pickedDate.isBefore(DateTime.now())) {
                                  appointmentControl.updateDobDate(pickedDate);
                                  _dateController.text = appointmentControl
                                      .formattedDobDate
                                      .toString();
                                } else {
                                  _dateController.clear();
                                }
                              },
                              validation: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a date of birth.';
                                }

                                DateTime selectedDate = DateTime.parse(value);
                                if (selectedDate.isAfter(DateTime.now())) {
                                  return 'Date of birth cannot be in the future.';
                                }
                                return null;
                              },
                              hintText: 'PATIENT DOB',
                              isCalenderIcon: true,
                              editText: true,
                            ),
                            sizedBox10(),
                            CustomDropdownField(
                              hintText: 'Do you have diabetes?',
                              selectedValue:
                                  appointmentControl.selectedDiabetes.isEmpty
                                      ? null
                                      : appointmentControl.selectedDiabetes,
                              options: appointmentControl.diabetesOptions,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  appointmentControl.updateDiabetes(newValue);
                                  print(appointmentControl.selectedDiabetes);
                                }
                              },
                              showTitle: true, // Set to true to show title
                            ),
                            sizedBox10(),
                            CustomDropdownField(
                              hintText: 'Do you wear glasses?',
                              selectedValue:
                                  appointmentControl.selectedGlasses.isEmpty
                                      ? null
                                      : appointmentControl.selectedGlasses,
                              options: appointmentControl.glassesOptions,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  appointmentControl.updateGlasses(newValue);
                                  print(appointmentControl.selectedGlasses);
                                }
                              },
                              showTitle: true,
                            ),
                            sizedBox10(),
                            CustomDropdownField(
                              hintText: 'Any Previous Health Issue',
                              selectedValue:
                                  appointmentControl.selectedBp.isEmpty
                                      ? null
                                      : appointmentControl.selectedBp,
                              options: appointmentControl.bpOptions,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  appointmentControl.updateHealth(newValue);
                                  print(appointmentControl.selectedBp);
                                }
                              },
                              showTitle: true,
                            ),
                          ],
                        ),
                  sizedBox10(),
                  const Text(
                    'WRITE YOUR APPOINTMENT DETAILS (optional)',
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    maxLines: 3,
                    controller: _otherProblemController,
                    hintText: "Other Info",
                    // validation: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter your Phone No';
                    //   } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    //     return 'Please enter a valid 10-digit Phone No';
                    //   }
                    //   return null;
                    // },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: SingleChildScrollView(
              child: appointmentControl.isBookingLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButtonWidget(
                      isBold: false,
                      fontSize: Dimensions.fontSize14,
                      buttonText: 'Confirm Your Appointment',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print('Print clinicId  ${clinicId}');
                          print(
                              'Print _firstnameController  ${_firstnameController.text}');
                          print(
                              'Print _lastnameController  ${_lastnameController.text}');
                          print(
                              'Print _phoneController  ${_phoneController.text}');
                          print(
                              'Print selectedGender  ${appointmentControl.getGenderStatus()}');
                          print(
                              'Print _dateController  ${_dateController.text}');
                          print('Print appointmentDate  ${appointmentDate}');
                          print('Print appointmentTime  ${appointmentTime}');
                          print(
                              'Print getDiabetesStatus  ${appointmentControl.getDiabetesStatus()}');
                          print(
                              'Print selectedBp  ${appointmentControl.getBpStatus()}');
                          print(
                              'Print selectedGlasses  ${appointmentControl.getGlassesStatus()}');
                          print(
                              'Print _otherProblemController  ${_otherProblemController.text}');
                          print(
                              'Print selectedPatientId  ${appointmentControl.selectedPatientId.value.toString()}');

                          print('print bool ${appointmentControl.bookingDiabeticType}');

                          AppointmentModel appointmentModel = AppointmentModel(
                            patientId: appointmentControl.selectedPatientId.value.toString(),
                            firstName: _firstnameController.text,
                            lastName: _lastnameController.text,
                            mobileNo: _phoneController.text,
                            gender: appointmentControl.getGenderStatus(),
                            dob: _dateController.text,
                            appointmentDate: appointmentDate,
                            appointmentTime: appointmentTime,
                            diabetesProblem: appointmentControl.getDiabetesStatus(),
                            bpProblem: appointmentControl.getBpStatus(),
                            eyeProblem: appointmentControl.getGlassesStatus(),
                            otherProblem: _otherProblemController.text,
                            patientType: 'new',
                            branchId: clinicId.toString(),
                            initial: appointmentControl.selectedInitial,
                            includePatientType: appointmentControl.isNewPatientEnabled,
                            type: appointmentControl.bookingDiabeticType == true ? "2" : "1"
                          );

                          Get.toNamed(RouteHelper.getPaymentMethodRoute(), arguments: appointmentModel);



                          // appointmentControl.bookAppointmentApi(
                          //     appointmentModel
                          // );
                        }
                      },
                    ),
            ),
          ),
        ),
      );
    });
  }
}
