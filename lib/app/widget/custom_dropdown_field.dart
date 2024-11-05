import 'package:flutter/material.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/styles.dart';

class CustomDropdownField extends StatelessWidget {
  final String hintText; // Placeholder text for the dropdown
  final String? selectedValue; // Currently selected value
  final List<String> options; // List of options for the dropdown
  final Function(String?) onChanged; // Callback when the value changes
  final bool showBorder; // Whether to show border
  final bool showTitle; // Whether to show title

  const CustomDropdownField({
    Key? key,
    required this.hintText,
    this.selectedValue,
    required this.options,
    required this.onChanged,
    this.showBorder = true,
    this.showTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          Text(
            hintText,
            style:   openSansRegular.copyWith(
              fontSize: Dimensions.fontSize12
          ), //,
          ),
        SizedBox(height: showTitle ? 5 : 0),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                style: showBorder ? BorderStyle.solid : BorderStyle.none,
                width: 0.3,
                color: Theme.of(context).primaryColorDark.withOpacity(0.80),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                style: showBorder ? BorderStyle.solid : BorderStyle.none,
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                style: showBorder ? BorderStyle.solid : BorderStyle.none,
                width: 0.3,
                color: Theme.of(context).primaryColorDark.withOpacity(0.80),
              ),
            ),
            isDense: true,
            hintText: hintText,
            hintStyle: openSansRegular.copyWith(fontSize: Dimensions.fontSize14, color: Theme.of(context).hintColor),
            filled: true,
            fillColor: Theme.of(context).cardColor,
          ),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: true, // Makes the dropdown full width
        ),
      ],
    );
  }
}
