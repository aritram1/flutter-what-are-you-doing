// circle_selector_section.dart
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CircleSelectorSection extends StatelessWidget {
  final int section;
  final List<String>? circles;
  final String selectedValue;
  final void Function(String?)? onChanged;

  final Logger log = Logger();

  CircleSelectorSection({super.key, 
    required this.section,
    required this.circles,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String sectionName = getSectionName(section); // Get the section name

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Section $section - $sectionName', // Display the section name
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Column(
            children: circles!
                .map(
                  (circle) => RadioListTile<String>(
                    title: Text(circle),
                    value: circle,
                    groupValue: selectedValue,
                    onChanged: onChanged,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  String getSectionName(int section) {
    // Map section numbers to corresponding names
    switch (section) {
      case 1:
        return 'Action';
      case 2:
        return 'Details';
      case 3:
        return 'More Details';
      // Add more cases for other sections if needed
      default:
        return 'Section $section';
    }
  }
}
