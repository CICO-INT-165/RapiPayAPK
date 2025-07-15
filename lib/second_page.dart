import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_widgets/back_to_app_btn.dart';
import 'custom_widgets/get_started.dart';
import 'third_page.dart'; // Add this import at the top
import 'main.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  Map<String, dynamic>? pageData;
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _panController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final String response = await rootBundle.loadString('assets/response.json');
    final data = json.decode(response);
    setState(() {
      pageData = data['apiResponseData']?['pageData'];
      if (pageData?['valueFirst']?['text'] != null) {
        _mobileController.text = pageData!['valueFirst']['text'];
      }
      if (pageData?['valueSecond']?['text'] != null) {
        _panController.text = pageData!['valueSecond']['text'];
      }
    });
  }

  void _showConsentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
                  const Expanded(
                    child: Text(
                      "Consent",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
              const Text(
                "By clicking on Agree – you are hereby: Acknowledge the request made by Digio to provide personal details. –Provide my unconditional access, store and copy all information therein by sharing the information.",
                style: TextStyle(fontSize: 15, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF60269E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ThirdPage()),
                    );
                  },
                  child: const Text("Agree", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 0, 179),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const RapiPayHomePage()),
                      (route) => false,
                    );
                  },
                  child: const Text("Disagree", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (pageData == null)
              const Center(child: CircularProgressIndicator())
            else if (pageData?['isctaEnable'] == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 2),
                  BackToAppBtn(),
                  const SizedBox(height: 80),
                  if (pageData?['title'] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        pageData!['title'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (pageData?['titleHintFirst'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        pageData!['titleHintFirst'],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (pageData?['valueFirst'] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 60),
                      child: Column(
                        children: [
                          pageData!['valueFirst']['editable'] == true
                              ? TextField(
                                  controller: _mobileController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    counterText: "",
                                  ),
                                )
                              : Column(
                                  children: [
                                    Text(
                                      pageData!['valueFirst']['text'] ?? "",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        letterSpacing: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Divider(thickness: 1, color: Colors.black38),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  if (pageData?['titleHintSecond'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        pageData!['titleHintSecond'],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (pageData?['valueSecond'] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 60),
                      child: Column(
                        children: [
                          pageData!['valueSecond']['editable'] == true
                              ? TextField(
                                  controller: _panController,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Text(
                                      pageData!['valueSecond']['text'] ?? "",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        letterSpacing: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Divider(thickness: 1, color: Colors.black38),
                                  ],
                                ),
                        ],
                      ),
                    ),
                ],
              )
            else
              Column(
                children: [
                  const SizedBox(height: 2),
                  BackToAppBtn(),
                  const SizedBox(height: 80),
                  // Optionally show a message if disabled
                  const Center(
                    child: Text(
                      "This section is currently disabled.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            // Place Get Started button at the bottom
            if (pageData?['isctaEnable'] == true)
              Positioned(
                left: 0,
                right: 0,
                bottom: 22,
                child: Center(
                  child: GetStartedButton(
                    onPressed: () {
                      _showConsentSheet(context);
                    },
                  ),
                ),
              ),
            // Version text at bottom left
            const Positioned(
              left: 16,
              bottom: 5,
              child: Text(
                "V–1.7.1",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}