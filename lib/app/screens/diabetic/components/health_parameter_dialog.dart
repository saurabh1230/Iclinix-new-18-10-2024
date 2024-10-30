import 'package:flutter/material.dart';
import 'package:iclinix/app/screens/diabetic/components/add_sugar_levels_dialog.dart';
import 'package:iclinix/app/widget/blood_sugar_input_field.dart';
import 'package:iclinix/app/widget/custom_button_widget.dart';
import 'package:iclinix/controller/diabetic_controller.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/sizeboxes.dart';
import 'package:get/get.dart';

class AddHealthParameterDialog extends StatelessWidget {
  AddHealthParameterDialog({super.key});

  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final waistController = TextEditingController();
  final hipController = TextEditingController();
  final bMIController = TextEditingController();
  final daibetesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _calculateBMI() {
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double heightInMeters = (double.tryParse(heightController.text) ?? 0.0) / 100; // Convert cm to meters

    if (heightInMeters > 0) {
      double bmi = weight / (heightInMeters * heightInMeters);
      bMIController.text = bmi.toStringAsFixed(2); // Show BMI with 2 decimal places
    } else {
      bMIController.clear(); // Clear the BMI field if height is invalid
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
            return Padding(
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
                  sizedBoxDefault(),
                  controller.isDailySugarCheckupLoading ?
                  const Center(child: CircularProgressIndicator()) :
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
                            if (_formKey.currentState!.validate()) {
                              controller.addHealthApi(
                                  heightController.text,
                                weightController.text,
                                waistController.text,
                                hipController.text,
                                  daibetesController.text
                              );


                            }
                          },
                        ),
                      ),
                    ],
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
