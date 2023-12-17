// main.dart
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'circle_selector_section.dart';
import './data_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedCircle1 = '';
  String selectedCircle2 = '';
  String selectedCircle3 = '';
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
                          selectedValue: selectedCircle1,
                          onChanged: (String? value) {
                            setState(() {
                              selectedCircle1 = value ?? '';
                              selectedCircle2 = '';
                              selectedCircle3 = '';
                              isSaveButtonVisible = false; // Reset button visibility
                            });
                          },
                        ),
                        if (selectedCircle1.isNotEmpty)
                          CircleSelectorSection(
                            section: 2,
                            circles: DataGenerator.getSection2Values(selectedCircle1),
                            selectedValue: selectedCircle2,
                            onChanged: (String? value) {
                              setState(() {
                                selectedCircle2 = value ?? '';
                                selectedCircle3 = '';
                                isSaveButtonVisible = false; // Reset button visibility
                              });
                            },
                          ),
                        if (selectedCircle2.isNotEmpty)
                          CircleSelectorSection(
                            section: 3,
                            circles: DataGenerator.getSection3Values(selectedCircle1, selectedCircle2),
                            selectedValue: selectedCircle3,
                            onChanged: (String? value) {
                              setState(() {
                                selectedCircle3 = value ?? '';
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

                              Map<String, dynamic> responseHandleSaveButtonclick = await handleSaveButtonclick(selectedCircle1, selectedCircle2, selectedCircle3);
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
    Map<String, dynamic> response = await DataGenerator.saveToSalesforce(selectedCircle1, selectedCircle2, selectedCircle3);
    setState(() {
      selectedCircle1 = '';
      selectedCircle2 = '';
      selectedCircle3 = '';
      isSaveButtonVisible = false; // Reset button visibility
    });
    return response;
  }
}
