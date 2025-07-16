import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_widgets/back_to_app_btn.dart';
import 'custom_widgets/get_started.dart';
import 'custom_widgets/rapi_colors.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  Map<String, dynamic>? pageData;
  List<dynamic> options = [];
  Map<String, int> selectedIndexes = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final String response = await rootBundle.loadString('assets/selet_user_type.json');
    final data = json.decode(response);
    print("Loaded JSON: $data"); 
    setState(() {
      pageData = data['apiResponseData']?['pageData'];
      options = pageData?['data'] ?? [];
      print("pageData: $pageData"); 
      print("options: $options");   
      // Set default selections if any
      for (var section in options) {
        final arr = section['array'] as List<dynamic>;
        int defaultIdx = arr.indexWhere((e) => e['default'] == true);
        selectedIndexes[section['tag']] = defaultIdx >= 0 ? defaultIdx : 0;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  // Make the main content scrollable if needed
                  Expanded(
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          ...options.map((section) => buildSection(section)),
                          const SizedBox(height: 80), // Add space for bottom bar
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pageData?['isCtaEnable'] == true)
              GetStartedButton(
                text: pageData?['ctaTxt'] ?? "Continue",
                onPressed: () {
                  _showConfirmationSheet(context);
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

    // Set a reasonable max height for the scrollable area inside each tile

    Widget optionsWidget;
    if (arr.length > 3) {
      optionsWidget = SizedBox(
        height: 180,
        child: Scrollbar(
          thumbVisibility: false,
          child: SingleChildScrollView(
            child: Column(
              children: arr.asMap().entries.map((entry) => buildOption(section, entry.key, entry.value, selectedIdx)).toList(),
            ),
          ),
        ),
      );
    } else {
      optionsWidget = Column(
        children: arr.asMap().entries.map((entry) => buildOption(section, entry.key, entry.value, selectedIdx)).toList(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0), // Reduced vertical gap
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

  Widget buildOption(Map<String, dynamic> section, int idx, dynamic item, int selectedIdx) {
    final tag = section['tag'];
    if (item['editable'] == true) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          decoration: InputDecoration(
            labelText: item['title'] ?? '',
            border: const OutlineInputBorder(),
          ),
        ),
      );
    }
    if (tag == "userType") {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
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
            Switch(
              value: selectedIdx == idx,
              activeColor: rapiDarkPurple,
              onChanged: (val) {
                setState(() {
                  selectedIndexes[tag] = val ? idx : -1;
                });
              },
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
                item['imgIcon'] is String && (item['imgIcon'] as String).isNotEmpty
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

  // Confirmation sheet
  void _showConfirmationSheet(BuildContext context) async {
    final String response = await rootBundle.loadString('assets/confirmation.json');
    final data = json.decode(response);
    final pageData = data['apiResponseData']?['pageData'];
    final bool isCtaEnable = pageData?['isCtaEnable'] == true;
    final List<dynamic> confirmationData = pageData?['confirmationData'] ?? [];
    final String ctaTxt = pageData?['ctaTxt'] ?? "Continue";

    if (!isCtaEnable) return;

    // Maintain switch and text field state for each item
    List<bool> switchStates = confirmationData.map((item) => item['isEnable'] == true).toList();
    List<TextEditingController> controllers = confirmationData.map((item) {
      final editValue = item['editValue'];
      return TextEditingController(text: editValue != null ? (editValue['text'] ?? '') : '');
    }).toList();

    showModalBottomSheet(
      backgroundColor: Colors.white,
      enableDrag: false,
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
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          "Confirmation",
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
                  const SizedBox(height: 8),
                  // Cards
                  ...confirmationData.asMap().entries.map((entry) {
                    int idx = entry.key;
                    var item = entry.value;
                    final bool hasEdit = item['editValue'] != null && item['editValue']['editable'] == true;
                    final String editHint = item['editHint'] ?? '';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
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
                                    Text(item['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    if ((item['subTitle'] ?? '').isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(item['subTitle'], style: const TextStyle(fontSize: 13, color: Colors.black54)),
                                      ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: switchStates[idx],
                                activeColor: const Color(0xFF60269E),
                                onChanged: (val) {
                                  setState(() {
                                    switchStates[idx] = val;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (hasEdit && switchStates[idx])
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextField(
                                controller: controllers[idx],
                                enabled: switchStates[idx],
                                decoration: InputDecoration(
                                  hintText: editHint,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF60269E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                        onPressed: () {
                        Navigator.of(context).pop(); // Close the confirmation sheet
                        _showConsentSheet(context);   // Show the consent sheet
                        // Handle continue logic here
                        },
                      child: Text(
                        ctaTxt,
                        style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Consent sheet
  void _showConsentSheet(BuildContext context) async {
    final String response = await rootBundle.loadString('assets/consent.json');
    final data = json.decode(response);
    final pageData = data['apiResponseData']?['pageData'];

    // Map all fields from JSON
    final String consentHeaderTitle = pageData?['consentHeaderTitle'] ?? "Consent";
    final String consentTitle = pageData?['consentTitle'] ?? "";
    final String consentFirstCtaTxt = pageData?['consentFirstCtaTxt'] ?? "Agree";
    final String consentSecondCtaTxt = pageData?['consentSecondCtaTxt'] ?? "Disagree";
    final bool isConsentFirstCtaEnable = pageData?['isConsentFirstCtaEnable'] ?? false;
    final bool isConsentSecondCtaEnable = pageData?['isConsentSecondCtaEnable'] ?? false;

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      enableDrag: false,
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
      },
    );
  }
}