import 'package:logger/logger.dart';
import './salesforce_util.dart';

class DataGenerator {
  static Logger log = Logger();

  static Map<String, Map<String, List<String>>> allValues = {};

  static Future<Map<String, Map<String, List<String>>>> getAllValues() async {
    // Call Salesforce asynchronously
    Map<String, Map<String, List<String>>> rawDataFromSalesforce =
        await _getFromSalesforce();

    // Get the value and process further
    allValues = _processSFResponse(rawDataFromSalesforce);

    // Return the processed response
    return allValues;
  }

  // Process method
  static Map<String, Map<String, List<String>>> _processSFResponse(
      Map<String, Map<String, List<String>>> sfData) {
    Map<String, Map<String, List<String>>> response = {};
    response = sfData;
    return response;
  }

  // The asynchronous callout to get data from Salesforce (mocked for testing)
  static Future<Map<String, Map<String, List<String>>>> _getFromSalesforce() async {
    // Simulate an asynchronous operation (e.g., fetching data from a server)
    await Future.delayed(const Duration(milliseconds: 100));

    Map<String, Map<String, List<String>>> response = {
      'Eating': {
        'breakfast': ['corn-flakes', 'milk', 'bread', 'egg'],
        'lunch': ['Rice', 'Curry'],
        'snacks': ['Chop', 'Pakoda', 'Tea'],
        'dinner': ['Rice', 'Bread', 'Curry'],
      },
      'Sleeping': {
        'Start': ['Yes', 'No'],
        'End': ['Yes', 'No'],
      },
      'Working': {
        'Office': ['Yes', 'No'],
        'Personal': ['Yes', 'No'],
      },
      'Doing': {
        'Gaming': ['Yes', 'No'],
        'Nothing': ['Yes', 'No'],
      },
    };

    return response;
  }

  static Future<Map<String, dynamic>> saveToSalesforce(String val1, String val2, String val3) async {
    log.d('Selected Values: $val1, $val2, $val3');
    var response = await SalesforceUtil.insertToSalesforce('Account', generatefieldNameValuePairs(val1, val2, val3));
    return response;
    // Save to Salesforce
  }

  static List<String> getSection1Values() {
    List<String> section1Values = allValues.keys.toList();
    return section1Values;
  }

  static List<String>? getSection2Values(String selectedValueSection1) {
    List<String>? section2Values =
        allValues[selectedValueSection1]?.keys.toList(); // as List<String>;
    return section2Values;
  }

  static List<String> getSection3Values(
      String selectedValueSection1, String selectedValueSection2) {
    Map<String, List<String>> allValuesInSection2 =
        allValues[selectedValueSection1]!;
    List<String> section3Values =
        allValuesInSection2[selectedValueSection2]!.toList();
    return section3Values;
  }

  static List<Map<String, dynamic>> generatefieldNameValuePairs(
      String val1, String val2, String val3) {
    List<Map<String, dynamic>> nameValuePairsList = [];
    Map<String, dynamic> nameValuePair = {};
    nameValuePair['Name'] = val1;
    nameValuePair['phone'] = val2;
    nameValuePair['fax'] = val3;
    nameValuePairsList.add(nameValuePair);
    return nameValuePairsList;
    // aritram1@gmail.com.whatdoing
  }
}
