import 'package:flutter/material.dart';
import 'custom_widgets/back_to_app_btn.dart';
import 'custom_widgets/get_started.dart';
import 'custom_widgets/rapi_colors.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  bool applyForQR = false;
  int businessType = 0;
  int turnover = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 2),
                BackToAppBtn(),
                const SizedBox(height: 16),
                const Text(
                  "Select Your Type",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Want to apply for?
                ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text(
                    "Want to apply for ?",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide.none,
                  ),
                  collapsedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide.none,
                  ),
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              children: const [
                                Text("QR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                SizedBox(height: 2),
                                Text("Accept payment via QR", style: TextStyle(fontSize: 12, color: Colors.black54)),
                              ],
                            ),
                          ),
                          Switch(
                            value: applyForQR,
                            activeColor: rapiDarkPurple,
                            onChanged: (val) {
                              setState(() => applyForQR = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Want to do Business As?
                ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text(
                    "Want to do Business As?",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide.none,
                  ),
                  collapsedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide.none,
                  ),
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Column(
                        children: [
                          businessTypeTile(0, "Individual"),
                          const SizedBox(height: 4),
                          businessTypeTile(1, "Proprietor"),
                        ],
                      ),
                    ),
                  ],
                ),
                // Your Annual business turnover
                ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text(
                    "Your Annual business turnover",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide.none,
                  ),
                  collapsedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide.none,
                  ),
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: turnoverTile(0, "3 to 5 lakh"),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: turnoverTile(1, "5 to 10 lakh"),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: turnoverTile(2, "10 to 20 lakh"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(), // Pushes everything above the button
              ],
            ),
            // Continue button at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 22,
              child: Center(
                child: GetStartedButton(
                  text: "Continue",
                  onPressed: () {
                    _showConfirmationSheet(context);
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

  Widget businessTypeTile(int value, String label) {
    return InkWell(
      onTap: () => setState(() => businessType = value),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Radio<int>(
              value: value,
              groupValue: businessType,
              activeColor: rapiDarkPurple,
              onChanged: (val) => setState(() => businessType = val!),
            ),
            Text(label, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Image.asset(
              'assets/business_type.png',
              height: 32,
              width: 32,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget turnoverTile(int value, String label) {
    return InkWell(
      onTap: () => setState(() => turnover = value),
      child: Row(
        children: [
          Radio<int>(
            value: value,
            groupValue: turnover,
            activeColor: rapiDarkPurple,
            onChanged: (val) => setState(() => turnover = val!),
          ),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void _showConfirmationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        bool aadharLinked = false;
        bool udyamDetail = false;
        return StatefulBuilder(
          builder: (context, setState) => Padding(
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
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Aadhar Detail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 2),
                            Text("Do you have your mobile number linked with your Aadhar ?", style: TextStyle(fontSize: 13, color: Colors.black54)),
                          ],
                        ),
                      ),
                      Switch(
                        value: aadharLinked,
                        activeColor: Color(0xFF60269E),
                        onChanged: (val) => setState(() => aadharLinked = val),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Udyam Detail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 2),
                            Text("Do you have a Udyam certificate number?", style: TextStyle(fontSize: 13, color: Colors.black54)),
                          ],
                        ),
                      ),
                      Switch(
                        value: udyamDetail,
                        activeColor: Color(0xFF60269E),
                        onChanged: (val) => setState(() => udyamDetail = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF60269E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      // Your continue logic here
                    },
                    child: const Text("Continue", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}