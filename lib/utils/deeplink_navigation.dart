import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../popups/confirmation_sheet.dart';
import '../popups/consent_sheet.dart';

// Parses the deeplink and returns a map of parameters
Map<String, String> parseDeeplink(String deeplink) {
  final uri = Uri.parse(deeplink);
  final params = <String, String>{};
  uri.queryParameters.forEach((key, value) {
    params[key] = value;
  });
  return params;
}

// Handles navigation based on deeplink parameters
void handleDeeplinkNavigation(BuildContext context, String deeplink) {
  final params = parseDeeplink(deeplink);
  final page = params['p'];
  final tdId = params['td_id'];

  Widget? pageWidget;
  Widget? sheetWidget;

  switch (page) {
    case 'aadharConfirmation':
      sheetWidget = ConfirmationSheet(onContinue: () {});
      pageWidget = ConfirmationSheet(onContinue: () {});
      break;
    case 'consent':
      sheetWidget = const ConsentSheet();
      pageWidget = const ConsentSheet();
      break;
    // Add more cases for other pages/sheets as needed
    default:
      return;
  }

  if (tdId == '0') {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => sheetWidget!,
    );
  } else if (tdId == '1') {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Scaffold(body: SafeArea(child: pageWidget!))),
    );
  }
}

Future<void> loadJsonData() async {
  final String response = await rootBundle.loadString('assets/your_file.json');
  final data = json.decode(response);
  final pageData = data['apiResponseData']?['pageData'];
  final deeplink = pageData?['deeplink'] ?? '';
  // You can now use the deeplink variable as needed
}
