import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_widgets/back_to_app_btn.dart';
import 'custom_widgets/get_started.dart';
import 'custom_widgets/rapi_colors.dart';
import 'utils/deeplink_navigation.dart'; // <-- Add this import

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  Map<String, dynamic>? pageData;
  List<dynamic> options = [];
  Map<String, int> selectedIndexes = {};
  Map<String, bool> inputError = {};
  Map<String, TextEditingController> inputControllers = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final String response = await rootBundle.loadString(
      'assets/selet_user_type.json',
    );
    final data = json.decode(response);
    setState(() {
      pageData = data['apiResponseData']?['pageData'];
      options = pageData?['data'] ?? [];
      // Set default selections if any
      for (var section in options) {
        final arr = section['array'] as List<dynamic>;
        int defaultIdx = arr.indexWhere((e) => e['default'] == true);
        selectedIndexes[section['tag']] = defaultIdx >= 0 ? defaultIdx : 0;
        for (var item in arr) {
          if (item['userInput'] != null) {
            final tag = item['userInput']['tag'];
            inputControllers[tag] = TextEditingController();
            inputError[tag] = false;
          }
        }
      }
      isLoading = false;
    });
  }

  @override
  void dispose() {
    for (var controller in inputControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // New: Fetch confirmation deeplink and navigate
  Future<void> navigateToConfirmation(BuildContext context) async {
    final String response = await rootBundle.loadString('assets/confirmation.json');
    final data = json.decode(response);
    final pageData = data['apiResponseData']?['pageData'];
    final deeplink = pageData?['deeplink'] ?? '';
    if (deeplink.isNotEmpty) {
      handleDeeplinkNavigation(context, deeplink);
    }
  }

  Future<void> navigateToConsent(BuildContext context) async {
    final String response = await rootBundle.loadString('assets/consent.json');
    final data = json.decode(response);
    final pageData = data['apiResponseData']?['pageData'];
    // You can use either consentFirstCtaDeeplink or consentSecondCtaDeeplink as per your logic
    final deeplink = pageData?['consentFirstCtaDeeplink'] ?? '';
    if (deeplink.isNotEmpty) {
      handleDeeplinkNavigation(context, deeplink);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // This is true by default, but you can set it explicitly
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading || pageData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: 2),
                  BackToAppBtn(),
                  const SizedBox(height: 20),
                  if (pageData?['title'] != null)
                    Text(
                      pageData!['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...options.map((section) => buildSection(section)),
                          const SizedBox(height: 3),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (pageData?['description'] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        pageData!['description'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pageData?['isCtaEnable'] == true)
              GetStartedButton(
                text: pageData?['ctaTxt'] ?? "Continue",
                onPressed: () {
                  // Use deeplink navigation from confirmation.json
                  navigateToConfirmation(context);
                },
              ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Text(
                  "V–1.7.1",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(Map<String, dynamic> section) {
    final arr = section['array'] as List<dynamic>;
    final tag = section['tag'];
    final selectedIdx = selectedIndexes[tag] ?? 0;

    Widget optionsWidget = Column(
      children: arr
          .asMap()
          .entries
          .map(
            (entry) =>
                buildOption(section, entry.key, entry.value, selectedIdx),
          )
          .toList(),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
      child: ExpansionTile(
        initiallyExpanded: true,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        title: Text(
          section['title'] ?? "",
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: optionsWidget,
          ),
        ],
      ),
    );
  }

  Widget buildOption(
    Map<String, dynamic> section,
    int idx,
    dynamic item,
    int selectedIdx,
  ) {
    final tag = section['tag'];
    final isSelected = selectedIdx == idx;

    // For userType (switch + userInput + ctaButton)
    if (tag == "userType") {
      final hasInput = item['userInput'] != null;
      final inputTag = hasInput ? item['userInput']['tag'] : null;
      final showInput = isSelected && hasInput;
      final showSubmit = showInput;
      final isError = inputTag != null && inputError[inputTag] == true;

      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      if ((item['subTitle'] ?? "").isNotEmpty)
                        Text(item['subTitle'], style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
                if (item['imgIcon'] != null && item['imgIcon'] is String)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.network(
                      item['imgIcon'],
                      height: 32,
                      width: 32,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                Switch(
                  value: isSelected,
                  activeColor: rapiDarkPurple,
                  onChanged: (val) {
                    setState(() {
                      selectedIndexes[tag] = val ? idx : -1;
                    });
                  },
                ),
              ],
            ),
            if (showInput)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item['userInput']['title'] ?? '',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(width: 4),
                        // Show red exclamation if error, else show red asterisk for mandatory
                        if (isError)
                          const Icon(Icons.error, color: Colors.red, size: 18),
                        if (!isError)
                          const Text(
                            '*',
                            style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextField(
                          controller: inputControllers[inputTag],
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: item['userInput']['hint'] ?? '',
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isError ? Colors.red : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isError ? Colors.red : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                          onChanged: (_) {
                            if (isError) {
                              setState(() {
                                inputError[inputTag!] = false;
                              });
                            }
                          },
                        ),
                        if (isError)
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.error, color: Colors.red, size: 22),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            if (showSubmit)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: rapiDarkPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          final inputVal = inputControllers[inputTag]?.text.trim() ?? '';
                          if (inputVal.isEmpty) {
                            setState(() {
                              inputError[inputTag!] = true;
                            });
                          } else {
                            setState(() {
                              inputError[inputTag!] = false;
                            });
                            // Handle submit logic here
                          }
                        },
                        child: const Text('submit', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    } else {
      return InkWell(
        onTap: () => setState(() => selectedIndexes[tag] = idx),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Radio<int>(
                value: idx,
                groupValue: selectedIdx,
                activeColor: rapiDarkPurple,
                onChanged: (val) => setState(() => selectedIndexes[tag] = val!),
              ),
              Text(item['title'] ?? "", style: const TextStyle(fontSize: 16)),
              const Spacer(),
              if (item['imgIcon'] != null)
                item['imgIcon'] is String &&
                        (item['imgIcon'] as String).isNotEmpty
                    ? Image.network(
                        item['imgIcon'],
                        height: 32,
                        width: 32,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      )
                    : const SizedBox.shrink(),
            ],
          ),
        ),
      );
    }
  }
}