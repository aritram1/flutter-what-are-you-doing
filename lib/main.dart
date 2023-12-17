// main.dart
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'circle_selector_section.dart';
import './data_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedValue1 = '';
  String selectedValue2 = '';
  String selectedValue3 = '';
  String appName = 'What are you doing now?';
  String saveBtnName = 'Save to Salesforce';
  Logger log = Logger();

  bool isSaveButtonVisible = false;
  bool isSaving = false; // New state variable for loading spinner

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FutureBuilder(
                future: DataGenerator.getAllValues(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Column(
                      children: [
                        CircleSelectorSection(
                          section: 1,
                          circles: DataGenerator.getSection1Values(),
                          selectedValue: selectedValue1,
                          onChanged: (String? value) {
                            setState(() {
                              selectedValue1 = value ?? '';
                              selectedValue2 = '';
                              selectedValue3 = '';
                              isSaveButtonVisible = false; // Reset button visibility
                            });
                          },
                        ),
                        if (selectedValue1.isNotEmpty)
                          CircleSelectorSection(
                            section: 2,
                            circles: DataGenerator.getSection2Values(selectedValue1),
                            selectedValue: selectedValue2,
                            onChanged: (String? value) {
                              setState(() {
                                selectedValue2 = value ?? '';
                                selectedValue3 = '';
                                isSaveButtonVisible = false; // Reset button visibility
                              });
                            },
                          ),
                        if (selectedValue2.isNotEmpty)
                          CircleSelectorSection(
                            section: 3,
                            circles: DataGenerator.getSection3Values(selectedValue1, selectedValue2),
                            selectedValue: selectedValue3,
                            onChanged: (String? value) {
                              setState(() {
                                selectedValue3 = value ?? '';
                                isSaveButtonVisible = true; // Show the button when section 3 is selected
                              });
                            },
                          ),
                        if (isSaveButtonVisible)
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isSaving = true; // Show loading spinner when save is clicked
                              });

                              Map<String, dynamic> responseHandleSaveButtonclick = await handleSaveButtonclick(selectedValue1, selectedValue2, selectedValue3);
                              log.d('responseHandleSaveButtonclick => $responseHandleSaveButtonclick');
                              setState(() {
                                isSaving = false; // Hide loading spinner when save response is received
                              });
                            },
                            child: isSaving
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                  )
                                : Text(saveBtnName),
                          ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> handleSaveButtonclick(String val1, String val2, String val3) async {
    log.d('Inside handleSaveButtonclick : $val1 || $val2 || $val3');
    Map<String, dynamic> response = await DataGenerator.saveToSalesforce(val1, val2, val3);
    setState(() {
      selectedValue1 = '';
      selectedValue2 = '';
      selectedValue3 = '';
      isSaveButtonVisible = false; // Reset button visibility
    });
    return response;
  }
}
