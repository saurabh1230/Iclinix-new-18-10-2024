import 'package:flutter/material.dart';
import 'package:iclinix/app/widget/blood_sugar_input_field.dart';
import 'package:iclinix/app/widget/custom_button_widget.dart';
import 'package:iclinix/app/widget/custom_textfield.dart';
import 'package:iclinix/controller/diabetic_controller.dart';
import 'package:iclinix/helper/date_converter.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/sizeboxes.dart';
import 'package:get/get.dart';
import 'package:iclinix/utils/styles.dart';

import '../../../widget/custom_dropdown_field.dart';

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
        _dateController.text = diabeticControl.formattedDate!;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(diabeticControl.showHistory == true ? 'Sugar History' : 'Add Sugar',
                    style: openSansSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).primaryColor),),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await diabeticControl.getSugarCheckUpHistory();
                                diabeticControl.toggleShowHistory(true);
                            },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: diabeticControl.showHistory ?
                                Theme.of(context).primaryColor.withOpacity(0.10) :
                                    Colors.transparent,
                              borderRadius: BorderRadius.circular(Dimensions.radius10)
                            ),

                            child: Icon(Icons.history,
                              size: Dimensions.fontSize30,
                              color: Theme.of(context).primaryColor,),
                          ),
                        ),

                        GestureDetector(
                          onTap: () async {
                                diabeticControl.toggleShowHistory(false);
                          },
                          child: Container(padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: diabeticControl.showHistory == false ?
                                Theme.of(context).primaryColor.withOpacity(0.10) :
                                Colors.transparent,
                                borderRadius: BorderRadius.circular(Dimensions.radius10)
                            ),
                            child: Icon(Icons.add,
                              size: Dimensions.fontSize30,
                              color: Theme.of(context).primaryColor,),
                          ),
                        ),
                      ],
                    ),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     await diabeticControl.getSugarCheckUpHistory();
                    //     diabeticControl.toggleShowHistory(true);
                    //   },
                    //   child: const Text('Sugar History'),
                    // ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     diabeticControl.toggleShowHistory(false);
                    //   },
                    //   child: const Text('Add Sugar Data'),
                    // ),
                  ],
                ),
                // sizedBoxDefault(),

                diabeticControl.showHistory
                    ? diabeticControl.isDailySugarCheckupLoading
                    ? const Center(child: CircularProgressIndicator())
                    : diabeticControl.sugarCheckUpList!.isNotEmpty
                    ? SizedBox(height: 500,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                        diabeticControl.sugarCheckUpList!.length,
                        itemBuilder: (context, index) {
                      final checkup =
                      diabeticControl.sugarCheckUpList![index];
                      String heading;
                      switch (checkup.checkingTime) {
                        case 1:
                          heading = "Before Meal";
                          break;
                        case 2:
                          heading = "After Breakfast";
                          break;
                        case 3:
                          heading = "After Lunch";
                          break;
                        case 4:
                          heading = "After Dinner";
                          break;
                        case 5:
                          heading = "Random Entry";
                          break;
                        default:
                          heading = "Unknown";
                      }
                      return ListTile(
                        title: Text("Date: ${AppointmentDateTimeConverter.formatDate(checkup.testDate.toString())}"),
                        subtitle: Text(
                            "$heading: ${checkup.measuredValue ?? 'N/A'}"),
                      );
                                        },
                                      ),
                    )
                    : const Center(
                    child: Text("No sugar history available"))
                    : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedBox20(),
                      Text(
                        'Test Date',
                        style: openSansRegular.copyWith(fontSize: Dimensions.fontSize12),
                      ),
                      sizedBox5(),
                      CustomTextField(
                        controller: _dateController,
                        readOnly: true,
                        onChanged: (val) {
                          _dateController.text = diabeticControl.formattedDate.toString();
                        },

                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2010),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            diabeticControl.updateDate(pickedDate);

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
                      sizedBox10(),
                      Text(
                        'Fasting Blood Sugar',
                        style:   openSansRegular.copyWith(
                            fontSize: Dimensions.fontSize12
                        ), //,
                      ),
                      BloodSugarInput(
                        title: 'Fasting Blood Sugar',
                        hintText: 'Fasting Blood Sugar',
                        controller: beforeMealController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select Fasting Blood Sugar ';
                          }
                          return null;
                        },
                      ),
                      sizedBox10(),
                      CustomDropdownField(
                        hintText: 'Postprandial Sugars',
                        selectedValue: diabeticControl.selectedSugarCheck.isEmpty ? null : diabeticControl.selectedSugarCheck,
                        options: diabeticControl.uniqueSugarCheckOptions,  // Use the unique options list here
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            diabeticControl.updateSugarCheck(newValue);
                            print(diabeticControl.selectedSugarCheck);
                          }
                        },

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select Postprandial Sugar ';
                          }
                          return null;
                        },

                        showTitle: true, // Set to true to show title
                      ),
                      sizedBox10(),
                      diabeticControl.selectedSugarCheck.isEmpty ? const SizedBox() :
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            diabeticControl.selectedSugarCheck,
                            style:   openSansRegular.copyWith(
                                fontSize: Dimensions.fontSize12
                            ), //,
                          ),
                          BloodSugarInput(
                            title:  diabeticControl.selectedSugarCheck,
                            hintText:  diabeticControl.selectedSugarCheck,
                            controller: beforeMealController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select Blood Sugar ';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      sizedBox10(),
                    Text(
                      'HbA1c %',
                      style: openSansRegular.copyWith(
                          fontSize: Dimensions.fontSize12
                      ),
                    ),
                      Obx(() {
                        return Slider(
                          value: diabeticControl.hbA1cPercentage.value,
                          min: 5.0,  // Minimum HbA1c level
                          max: 7.0,  // Maximum HbA1c level
                          divisions: 20, // Allow 1 decimal precision by dividing into 20 steps
                          label: diabeticControl.hbA1cPercentage.value.toStringAsFixed(1), // Show 1 decimal
                          onChanged: (double newValue) {
                            diabeticControl.hbA1cPercentage.value = newValue;  // Update the HbA1c percentage
                          },
                        );
                      }),
                      Obx(() {
                        return Text(
                          'Selected Percentage: ${diabeticControl.hbA1cPercentage.value} %',
                          style: openSansRegular.copyWith(
                              fontSize: Dimensions.fontSize12
                          ),
                        );
                      }),




                      // BloodSugarInput(
                      //   title: 'Blood Sugar After Breakfast',
                      //   hintText: 'Blood Sugar After Meal',
                      //   controller: afterBreakfastController,
                      // ),
                      // sizedBox10(),
                      // BloodSugarInput(
                      //   title: 'Blood Sugar After Lunch',
                      //   hintText: 'Blood Sugar After Meal',
                      //   controller: afterLunchController,
                      // ),
                      // sizedBox10(),
                      // BloodSugarInput(
                      //   title: 'Blood Sugar After Dinner',
                      //   hintText: 'Blood Sugar After Meal',
                      //   controller: afterDinnerController,
                      // ),
                      // sizedBox10(),
                      // BloodSugarInput(
                      //   title: 'Blood Sugar Random Entry',
                      //   hintText: 'Blood Sugar Random Entry',
                      //   controller: randomEntryController,
                      // ),

                      sizedBoxDefault(),
                      sizedBoxDefault(),
                      diabeticControl.isDailySugarCheckupLoading
                          ? const Center(
                          child: CircularProgressIndicator())
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
                                  diabeticControl.addSugarApi(
                                    beforeMealController.text,
                                    afterBreakfastController.text,
                                    afterLunchController.text,
                                    afterDinnerController.text,
                                    randomEntryController.text,
                                    _dateController.text,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      sizedBoxDefault(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
