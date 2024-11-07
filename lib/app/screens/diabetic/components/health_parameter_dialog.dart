import 'package:flutter/material.dart';
import 'package:iclinix/app/screens/diabetic/components/add_sugar_levels_dialog.dart';
import 'package:iclinix/app/widget/blood_sugar_input_field.dart';
import 'package:iclinix/app/widget/custom_button_widget.dart';
import 'package:iclinix/app/widget/custom_textfield.dart';
import 'package:iclinix/controller/diabetic_controller.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/sizeboxes.dart';
import 'package:get/get.dart';

import '../../../../utils/styles.dart';
import '../../../widget/custom_snackbar.dart';

class AddHealthParameterDialog extends StatefulWidget {
  const AddHealthParameterDialog({super.key});

  @override
  _AddHealthParameterDialogState createState() => _AddHealthParameterDialogState();
}

class _AddHealthParameterDialogState extends State<AddHealthParameterDialog> with SingleTickerProviderStateMixin {
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final waistController = TextEditingController();
  final hipController = TextEditingController();
  final bMIController = TextEditingController();
  final daibetesController = TextEditingController();
  final systolicBpController = TextEditingController();
  final diastolicBpController = TextEditingController();
  final bpDateController = TextEditingController();
  final bpTimeController = TextEditingController();
  final otherHealthController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController = TabController(length: 2, vsync: this);
      Get.find<DiabeticController>().getSubscribedPatientDataApi();
    });
  }

  void _calculateBMI() {
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double heightInMeters = (double.tryParse(heightController.text) ?? 0.0) / 100;

    if (heightInMeters > 0) {
      double bmi = weight / (heightInMeters * heightInMeters);
      bMIController.text = bmi.toStringAsFixed(2);
    } else {
      bMIController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize10),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: GetBuilder<DiabeticController>(builder: (controller) {
            bpDateController.text = controller.formattedDate ?? '';
            bpTimeController.text = controller.formattedTime ?? '';
            weightController.text = controller.subscribedPatientData?.weight ?? '';
            heightController.text = controller.subscribedPatientData?.height?.toString() ?? '';
            waistController.text = controller.subscribedPatientData?.waistCircumference?.toString() ?? '';
            hipController.text = controller.subscribedPatientData?.hipCircumference?.toString() ?? '';
            daibetesController.text = controller.subscribedPatientData?.duraDiabetes?.toString() ?? '';
            double weight = double.tryParse(weightController.text) ?? 0;
            double height = double.tryParse(heightController.text) ?? 0;
            String bmi = '';
            if (height > 0) {
              bmi = (weight / ((height / 100) * (height / 100))).toStringAsFixed(2); // height in cm
            }
            bMIController.text = bmi;
            return Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    padding: EdgeInsets.zero,
                    controller: _tabController,
                    tabs: const [
                      Tab(text: "Health Data"),
                      Tab(text: "BP Data"),
                    ],
                    indicatorColor: Colors.blue, // Change the indicator color to blue
                    labelColor: Colors.blue, // Change the label color when selected to blue
                    unselectedLabelColor: Colors.grey, // Optional: Set the color for unselected tabs
                  ),
                  SizedBox(
                    height: Get.size.height * 0.75, // Adjust the height as needed for your content
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BloodSugarInput(
                                  title: 'Weight',
                                  hintText: 'Weight',
                                  controller: weightController,
                                  suffixText: 'Kg',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your weight'; // Validation message
                                    }
                                    final numericValue = double.tryParse(value);
                                    if (numericValue == null || numericValue <= 0) {
                                      return 'Please enter a valid weight'; // Validation message for invalid number
                                    }
                                    return null; // Return null if valid
                                  },
                                  onChanged: (value) => _calculateBMI(), // Update BMI on weight change
                                ),
                                sizedBox10(),
                                BloodSugarInput(
                                  title: 'Height',
                                  hintText: 'Height',
                                  controller: heightController,
                                  suffixText: 'Cm',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your height'; // Validation message
                                    }
                                    final numericValue = double.tryParse(value);
                                    if (numericValue == null || numericValue <= 0) {
                                      return 'Please enter a valid height'; // Validation message for invalid number
                                    }
                                    return null; // Return null if valid
                                  },
                                  onChanged: (value) => _calculateBMI(), // Update BMI on height change
                                ),
                                sizedBox10(),
                                BloodSugarInput(
                                  title: 'Waist Circumference',
                                  hintText: 'Waist Circumference',
                                  controller: waistController,
                                  suffixText: 'Cm',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your waist circumference'; // Validation message
                                    }
                                    final numericValue = double.tryParse(value);
                                    if (numericValue == null || numericValue <= 0) {
                                      return 'Please enter a valid waist circumference'; // Validation message for invalid number
                                    }
                                    return null; // Return null if valid
                                  },
                                ),
                                sizedBox10(),
                                BloodSugarInput(
                                  title: 'Hip Circumference',
                                  hintText: 'Hip Circumference',
                                  suffixText: 'Cm',
                                  controller: hipController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your hip circumference'; // Validation message
                                    }
                                    final numericValue = double.tryParse(value);
                                    if (numericValue == null || numericValue <= 0) {
                                      return 'Please enter a valid hip circumference'; // Validation message for invalid number
                                    }
                                    return null; // Return null if valid
                                  },
                                ),
                                sizedBox10(),
                                BloodSugarInput(
                                  title: 'BMI',
                                  hintText: 'BMI',
                                  controller: bMIController,
                                  suffixText: 'KG/M2',
                                  readOnly: true, // Make BMI field read-only
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your BMI'; // Validation message
                                    }
                                    final numericValue = double.tryParse(value);
                                    if (numericValue == null || numericValue <= 0) {
                                      return 'Please enter a valid BMI'; // Validation message for invalid number
                                    }
                                    return null; // Return null if valid
                                  },
                                ),
                                sizedBox10(),
                                BloodSugarInput(
                                  title: 'Duration of Diabetes',
                                  hintText: 'Duration of Diabetes',
                                  controller: daibetesController,
                                  suffixText: 'Months',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the duration of diabetes'; // Validation message
                                    }
                                    final numericValue = int.tryParse(value);
                                    if (numericValue == null || numericValue < 0) {
                                      return 'Please enter a valid duration'; // Validation message for invalid number
                                    }
                                    return null; // Return null if valid
                                  },
                                ),
                                sizedBox10(),
                                BloodSugarInput(
                                  title: 'Any Other Health Condition / Co-Morbidities',
                                  hintText: 'Any Other Health Condition / Co-Morbidities',
                                  controller: otherHealthController,
                                  suffixText: '',
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please enter your waist circumference'; // Validation message
                                  //   }
                                  //   final numericValue = double.tryParse(value);
                                  //   if (numericValue == null || numericValue <= 0) {
                                  //     return 'Please enter a valid waist circumference'; // Validation message for invalid number
                                  //   }
                                  //   return null; // Return null if valid
                                  // },
                                ),

                                sizedBox30(),
                                controller.isDailySugarCheckupLoading
                                    ? const Center(child: CircularProgressIndicator())
                                    : Row(
                                  children: [
                                    Flexible(
                                      child: CustomButtonWidget(
                                        buttonText: 'Cancel',
                                        transparent: true,
                                        isBold: false,
                                        fontSize: Dimensions.fontSize14,
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    sizedBoxW10(),
                                    Flexible(
                                      child: CustomButtonWidget(
                                        buttonText: 'Save',
                                        isBold: false,
                                        fontSize: Dimensions.fontSize14,
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            controller.addHealthApi(
                                              heightController.text,
                                              weightController.text,
                                              waistController.text,
                                              hipController.text,
                                              daibetesController.text,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // BP Data Tab
                        Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BloodSugarInput(
                                title: 'Systolic BP',
                                hintText: 'Systolic BP',
                                controller: systolicBpController,
                                suffixText: 'mmHg',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Systolic BP'; // Validation message
                                  }
                                  final numericValue = double.tryParse(value);
                                  if (numericValue == null || numericValue <= 0) {
                                    return 'Please enter a valid Systolic BP'; // Validation message for invalid number
                                  }
                                  return null; // Return null if valid
                                },
                              ),
                              sizedBox10(),
                              BloodSugarInput(
                                title: 'Diastolic BP',
                                hintText: 'Diastolic BP',
                                controller: diastolicBpController,
                                suffixText: 'mmHg',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Diastolic BP'; // Validation message
                                  }
                                  final numericValue = double.tryParse(value);
                                  if (numericValue == null || numericValue <= 0) {
                                    return 'Please enter a valid Diastolic BP'; // Validation message for invalid number
                                  }
                                  return null; // Return null if valid
                                },
                              ),
                              sizedBox20(),
                              CustomTextField(
                                controller: bpDateController,
                                readOnly: true,
                                onChanged: (val) {
                                  bpDateController.text = controller.formattedDate.toString();
                                },

                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2010),
                                    lastDate: DateTime(2100),
                                  );
                                  if (pickedDate != null) {
                                    controller.updateDate(pickedDate);

                                  }
                                },
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a test date';
                                  }
                                  return null;
                                },
                                hintText: 'Select Test Date',
                                isCalenderIcon: true,
                                editText: true,
                                suffixText: '',
                              ),
                              sizedBox20(),
                              CustomTextField(
                                controller: bpTimeController,
                                readOnly: true,
                                isClockIcon: true,
                                onChanged: (val) {
                                  bpTimeController.text = controller.formattedTime.toString();
                                },
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(controller.bpSelectedTime),
                                  );
                                  if (pickedTime != null) {
                                    controller.updateTimeOfDay(pickedTime);
                                  }
                                },
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a test time';
                                  }
                                  return null;
                                },
                                hintText: 'Select Test Time',
                                isCalenderIcon: false, // Disable calendar icon, use clock icon instead if needed
                                editText: true,
                                suffixText: '',
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Flexible(
                                    child: CustomButtonWidget(
                                      buttonText: 'Cancel',
                                      transparent: true,
                                      isBold: false,
                                      fontSize: Dimensions.fontSize14,
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ),
                                  sizedBoxW10(),
                                  Flexible(
                                    child: CustomButtonWidget(
                                      buttonText: 'Save',
                                      isBold: false,
                                      fontSize: Dimensions.fontSize14,
                                      onPressed: () {
                                        if (systolicBpController.text.isEmpty && diastolicBpController.text.isEmpty && bpDateController.text.isEmpty) {
                                          showCustomSnackBar('Please Add Bp Details');
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
