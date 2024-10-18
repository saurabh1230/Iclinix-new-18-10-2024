import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final List<String> items; // List of patient names
  final String selectedValue; // Currently selected value
  final Function(String?) onChanged; // Function to call when selection changes

  const CustomRadioButton({
    Key? key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        bool isSelected = selectedValue == item;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            color:  Theme.of(context).cardColor, // Background color based on selection
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: isSelected ? Colors.blueAccent : Colors.grey, // Border color for selected/unselected
              width: 2.0,
            ),
          ),
          child: RadioListTile<String>(
            title: Text(item),
            value: item,
            groupValue: selectedValue,
            onChanged: onChanged,
            activeColor: Colors.blueAccent, // Color of selected radio button
            tileColor: isSelected ? Colors.blue[50] : Colors.white, // Background color inside tile
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
      }).toList(),
    );
  }
}
