import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfirmationSheet extends StatefulWidget {
  final VoidCallback onContinue;

  const ConfirmationSheet({super.key, required this.onContinue});

  @override
  State<ConfirmationSheet> createState() => _ConfirmationSheetState();
}

class _ConfirmationSheetState extends State<ConfirmationSheet> {
  List<dynamic> confirmationData = [];
  String ctaTxt = "Continue";
  List<bool> switchStates = [];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final String response = await rootBundle.loadString('assets/confirmation.json');
    final data = json.decode(response);
    final pageData = data['apiResponseData']?['pageData'];
    final bool isCtaEnable = pageData?['isCtaEnable'] == true;
    ctaTxt = pageData?['ctaTxt'] ?? "Continue";
    if (!isCtaEnable) {
      Navigator.of(context).pop();
      return;
    }
    confirmationData = pageData?['confirmationData'] ?? [];
    switchStates = confirmationData.map((item) => item['isEnable'] == true).toList();
    controllers = confirmationData.map((item) {
      final editValue = item['editValue'];
      return TextEditingController(text: editValue != null ? (editValue['text'] ?? '') : '');
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 16,
      ),
      child: confirmationData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                      Navigator.of(context).pop();
                      widget.onContinue();
                    },
                    child: Text(
                      ctaTxt,
                      style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }
}