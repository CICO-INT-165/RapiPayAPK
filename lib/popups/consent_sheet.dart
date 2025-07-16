import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConsentSheet extends StatefulWidget {
  const ConsentSheet({super.key});

  @override
  State<ConsentSheet> createState() => _ConsentSheetState();
}

class _ConsentSheetState extends State<ConsentSheet> {
  String consentHeaderTitle = "Consent";
  String consentTitle = "";
  String consentFirstCtaTxt = "Agree";
  String consentSecondCtaTxt = "Disagree";
  bool isConsentFirstCtaEnable = false;
  bool isConsentSecondCtaEnable = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final String response = await rootBundle.loadString('assets/consent.json');
    final data = json.decode(response);
    final pageData = data['apiResponseData']?['pageData'];
    setState(() {
      consentHeaderTitle = pageData?['consentHeaderTitle'] ?? "Consent";
      consentTitle = pageData?['consentTitle'] ?? "";
      consentFirstCtaTxt = pageData?['consentFirstCtaTxt'] ?? "Agree";
      consentSecondCtaTxt = pageData?['consentSecondCtaTxt'] ?? "Disagree";
      isConsentFirstCtaEnable = pageData?['isConsentFirstCtaEnable'] ?? false;
      isConsentSecondCtaEnable = pageData?['isConsentSecondCtaEnable'] ?? false;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Text(
                  consentHeaderTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            consentTitle,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (isConsentFirstCtaEnable)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF60269E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Add navigation or logic for Agree here
                },
                child: Text(consentFirstCtaTxt, style: const TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          if (isConsentFirstCtaEnable) const SizedBox(height: 16),
          if (isConsentSecondCtaEnable)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 240, 25, 211),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Add navigation or logic for Disagree here
                },
                child: Text(consentSecondCtaTxt, style: const TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          if (isConsentSecondCtaEnable) const SizedBox(height: 16),
        ],
      ),
    );
  }
}