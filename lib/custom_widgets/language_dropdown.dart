import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'rapi_colors.dart';

class LanguageDropdown extends StatelessWidget {
  final String value;
  final List<String> languages;
  final ValueChanged<String?> onChanged;

  const LanguageDropdown({
    Key? key,
    required this.value,
    required this.languages,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: value,
              isExpanded: true,
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.arrow_drop_down, color: rapiDarkPurple),
              ),
              buttonStyleData: ButtonStyleData(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: onChanged,
              items: languages.map((lang) {
                return DropdownMenuItem<String>(
                  value: lang,
                  child: Center(
                    child: Text(
                      lang,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            height: 3,
            width: double.infinity,
            color: rapiDarkPurple,
          ),
        ],
      ),
    );
  }
}