import 'package:flutter/material.dart';
import 'package:iclinix/app/widget/blood_sugar_input_field.dart';
import 'package:iclinix/app/widget/custom_button_widget.dart';
import 'package:iclinix/app/widget/custom_textfield.dart';
import 'package:iclinix/controller/appointment_controller.dart';
import 'package:iclinix/controller/diabetic_controller.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/sizeboxes.dart';
import 'package:iclinix/utils/styles.dart';
import 'package:get/get.dart';
class AddSugarLevelsDialog extends StatelessWidget {
   AddSugarLevelsDialog({super.key});

  final beforeMealController = TextEditingController();
   final afterBreakfastController = TextEditingController();
   final afterLunchController = TextEditingController();
   final afterDinnerController = TextEditingController();
   final randomEntryController = TextEditingController();
   final _dateController = TextEditingController();
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize10),
      child: GetBuilder<DiabeticController>(builder: (diabeticControl) {
        return   SingleChildScrollView(
          child: Form(key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BloodSugarInput(title: 'Blood Sugar Before Meal', hintText: 'Blood Sugar Before Meal', controller: beforeMealController,),
                  sizedBox10(),
                  BloodSugarInput(title: 'Blood Sugar After Breakfast', hintText: 'Blood Sugar Before Meal', controller: afterBreakfastController,),
                  sizedBox10(),
                  BloodSugarInput(title: 'Blood Sugar After Lunch', hintText: 'Blood Sugar Before Meal', controller: afterLunchController,),
                  sizedBox10(),
                  BloodSugarInput(title: 'Blood Sugar After Dinner', hintText: 'Blood Sugar Before Meal', controller: afterDinnerController,),
                  sizedBox10(),
                  BloodSugarInput(title: 'Blood Sugar Random Entry', hintText: 'Blood Sugar Before Meal', controller: randomEntryController,),
                  sizedBoxDefault(),
                  CustomTextField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: diabeticControl.selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        diabeticControl.updateDate(pickedDate);
                        _dateController.text = diabeticControl.formattedDate.toString();
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
                      suffixText : ''
                  ),
                  sizedBoxDefault(),
                  Row(
                    children: [
                      Flexible(
                        child: CustomButtonWidget(buttonText: 'Cancel',
                          transparent: true,
                          isBold: false,
                          fontSize: Dimensions.fontSize14,
                          onPressed: () {
                            Get.back();
                          },),
                      ),
                      sizedBoxW10(),
                      Flexible(
                        child: CustomButtonWidget(buttonText: 'Save',
                          isBold: false,
                          fontSize: Dimensions.fontSize14,
                          onPressed: () {
                            if(_formKey.currentState!.validate()) {
                              diabeticControl.addSugarApi(
                                beforeMealController.text,
                                afterBreakfastController.text,
                                afterLunchController.text,
                                afterDinnerController.text,
                                randomEntryController.text,
                                _dateController.text,);
                            }
                          },),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ),
        );
      })



    );
  }


}

