import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rapipay_ui/second_page.dart' show SecondPage;
import 'custom_widgets/back_to_app_btn.dart';
import 'custom_widgets/get_started.dart';
import 'custom_widgets/language_dropdown.dart';
import 'package:lottie/lottie.dart';
import 'custom_widgets/rapi_colors.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF60269E), // Use your dark purple
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RapiPay UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: rapiDarkPurple),
        primaryColor: rapiDarkPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: rapiDarkPurple,
          foregroundColor: Colors.white,
        ),
      ),
      home: const RapiPayHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RapiPayHomePage extends StatefulWidget {
  const RapiPayHomePage({super.key});

  @override
  State<RapiPayHomePage> createState() => _RapiPayHomePageState();
}

class _RapiPayHomePageState extends State<RapiPayHomePage> {
  final TextEditingController _mobileController = TextEditingController();
  String _selectedLanguage = "English";
  final List<String> _languages = ["English", "Hindi"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 0),
                      BackToAppBtn(), // <-- Use your custom button here
                      const SizedBox(height: 20), // Space before input
                      MobileInputField(controller: _mobileController),
                      const SizedBox(height: 32), // Space before logo
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/rapipay_logo.png',
                              height: 80,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24), // Space before animation
                      SizedBox(
                        height: 220,
                        width: 340,
                        child: Lottie.asset(
                          'assets/animations/get_started 2.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 40), // Space before button
                      GetStartedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SecondPage()),
                          );
                        },
                      ),
                      const SizedBox(height: 40), // Space before language section
                      Image.asset(
                        'assets/web_icon.png',
                        height: 32,
                        width: 32,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Select Language",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      LanguageDropdown(
                        value: _selectedLanguage,
                        languages: _languages,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedLanguage = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 5,
              child: Text(
                "V–1.7.1",
                style: const TextStyle(
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

class MobileInputField extends StatelessWidget {
  final TextEditingController controller;

  const MobileInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        decoration: InputDecoration(
          hintText: "Type Mobile No",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          counterText: "",
        ),
      ),
    );
  }
}
