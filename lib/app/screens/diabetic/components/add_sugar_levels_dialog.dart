import 'package:flutter/material.dart';
import 'package:iclinix/app/widget/blood_sugar_input_field.dart';
import 'package:iclinix/app/widget/custom_button_widget.dart';
import 'package:iclinix/app/widget/custom_textfield.dart';
import 'package:iclinix/controller/diabetic_controller.dart';
import 'package:iclinix/helper/date_converter.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/sizeboxes.dart';
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
      insetPadding:
      const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize10),
      child: GetBuilder<DiabeticController>(builder: (diabeticControl) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await diabeticControl.getSugarCheckUpHistory();
                        diabeticControl.toggleShowHistory(true);
                      },
                      child: const Text('Sugar History'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        diabeticControl.toggleShowHistory(false);
                      },
                      child: const Text('Add Sugar Data'),
                    ),
                  ],
                ),
                sizedBoxDefault(),

                diabeticControl.showHistory
                    ? diabeticControl.isDailySugarCheckupLoading
                    ? const Center(child: CircularProgressIndicator())
                    : diabeticControl.sugarCheckUpList!.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                )
                    : const Center(
                    child: Text("No sugar history available"))
                    : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BloodSugarInput(
                        title: 'Blood Sugar Before Meal',
                        hintText: 'Blood Sugar Before Meal',
                        controller: beforeMealController,
                      ),
                      sizedBox10(),
                      BloodSugarInput(
                        title: 'Blood Sugar After Breakfast',
                        hintText: 'Blood Sugar After Meal',
                        controller: afterBreakfastController,
                      ),
                      sizedBox10(),
                      BloodSugarInput(
                        title: 'Blood Sugar After Lunch',
                        hintText: 'Blood Sugar After Meal',
                        controller: afterLunchController,
                      ),
                      sizedBox10(),
                      BloodSugarInput(
                        title: 'Blood Sugar After Dinner',
                        hintText: 'Blood Sugar After Meal',
                        controller: afterDinnerController,
                      ),
                      sizedBox10(),
                      BloodSugarInput(
                        title: 'Blood Sugar Random Entry',
                        hintText: 'Blood Sugar Random Entry',
                        controller: randomEntryController,
                      ),
                      sizedBoxDefault(),
                      CustomTextField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: diabeticControl.selectedDate ??
                                DateTime.now(),
                            firstDate: DateTime(2010),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            diabeticControl.updateDate(pickedDate);
                            _dateController.text =
                                diabeticControl.formattedDate.toString();
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
                                if (_formKey.currentState!
                                    .validate()) {
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
