import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Portal',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F4E78),
        ),
      ),
      home: const EmployeeIdScreen(),
    );
  }
}

// ============================================================
// EMPLOYEE ID SCREEN
// ============================================================

class EmployeeIdScreen extends StatefulWidget {
  const EmployeeIdScreen({super.key});

  @override
  State<EmployeeIdScreen> createState() =>
      _EmployeeIdScreenState();
}

class _EmployeeIdScreenState
    extends State<EmployeeIdScreen> {

  final TextEditingController employeeIdController =
  TextEditingController();

  bool loading = false;

  // YOUR EXISTING GOOGLE APPS SCRIPT URL
  static const String webAppUrl =
      'https://script.google.com/macros/s/AKfycbxTFGQ3pa4UiI-oPFHy0HI_WbXh0jv2kV8eJdPNuTLb_79VfRG80rp07lBgnTBQNLU/exec';

  // ==========================================================
  // OPEN EXISTING ATTENDANCE PORTAL
  // ==========================================================

  void openAttendancePortal() {
    final employeeId =
    employeeIdController.text
        .trim()
        .toUpperCase();

    if (employeeId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter Employee ID',
          ),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    final url =
        '$webAppUrl?id=${Uri.encodeComponent(employeeId)}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AttendanceWebView(
          url: url,
        ),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    employeeIdController.dispose();
    super.dispose();
  }

  // ==========================================================
  // MOBILE UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),

            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 30,
              ),

              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  const SizedBox(height: 35),

                  // APP ICON
                  Container(
                    width: 72,
                    height: 72,

                    decoration: BoxDecoration(
                      color:
                      const Color(0xFF1F4E78),

                      borderRadius:
                      BorderRadius.circular(20),
                    ),

                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // TITLE
                  const Text(
                    'Attendance Portal',
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 25,
                      fontWeight:
                      FontWeight.bold,
                      color:
                      Color(0xFF1F2937),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Employee Login',

                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // EMPLOYEE ID
                  TextField(
                    controller:
                    employeeIdController,

                    textCapitalization:
                    TextCapitalization.characters,

                    textInputAction:
                    TextInputAction.done,

                    decoration:
                    InputDecoration(
                      labelText:
                      'Employee ID',

                      hintText:
                      'AEPL-040',

                      prefixIcon:
                      const Icon(
                        Icons
                            .badge_outlined,
                      ),

                      contentPadding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),

                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          13,
                        ),
                      ),

                      enabledBorder:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          13,
                        ),

                        borderSide:
                        BorderSide(
                          color: Colors
                              .grey
                              .shade300,
                        ),
                      ),

                      filled: true,
                      fillColor:
                      Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // CONTINUE BUTTON
                  SizedBox(
                    width:
                    double.infinity,

                    height: 52,

                    child:
                    ElevatedButton(
                      onPressed:
                      loading
                          ? null
                          : openAttendancePortal,

                      style:
                      ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        const Color(
                          0xFF1F4E78,
                        ),

                        foregroundColor:
                        Colors.white,

                        elevation: 0,

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                            13,
                          ),
                        ),
                      ),

                      child: loading
                          ? const SizedBox(
                        width: 21,
                        height: 21,

                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                          Colors.white,
                        ),
                      )
                          : const Text(
                        'CONTINUE',

                        style:
                        TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight
                              .bold,
                          letterSpacing:
                          .3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Enter your Employee ID to continue',

                    textAlign:
                    TextAlign.center,

                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ATTENDANCE WEBVIEW
// ============================================================

class AttendanceWebView
    extends StatefulWidget {

  final String url;

  const AttendanceWebView({
    super.key,
    required this.url,
  });

  @override
  State<AttendanceWebView> createState() =>
      _AttendanceWebViewState();
}

class _AttendanceWebViewState
    extends State<AttendanceWebView> {

  late final WebViewController
  controller;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    // ========================================================
    // CHROME / WEB TESTING
    // ========================================================

    if (kIsWeb) {
      _openInBrowser();
      return;
    }

    // ========================================================
    // ANDROID / IOS WEBVIEW
    // ========================================================

    controller =
    WebViewController()

      ..setJavaScriptMode(
        JavaScriptMode
            .unrestricted,
      )

      ..setNavigationDelegate(
        NavigationDelegate(

          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                loading = true;
              });
            }
          },

          onPageFinished: (_) {
            if (mounted) {
              setState(() {
                loading = false;
              });
            }
          },

          onWebResourceError:
              (error) {
            debugPrint(
              'WebView Error: '
                  '${error.description}',
            );
          },
        ),
      )

      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  // ==========================================================
  // OPEN BROWSER WHEN TESTING ON CHROME
  // ==========================================================

  Future<void> _openInBrowser() async {

    final uri =
    Uri.parse(widget.url);

    final launched =
    await launchUrl(
      uri,
      mode:
      LaunchMode
          .externalApplication,
    );

    if (!launched &&
        mounted) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to open Attendance Portal',
          ),
        ),
      );
    }
  }

  // ==========================================================
  // BACK BUTTON
  // ==========================================================

  Future<bool> handleBack() async {

    if (kIsWeb) {
      return true;
    }

    if (await controller
        .canGoBack()) {

      await controller.goBack();

      return false;
    }

    return true;
  }

  // ==========================================================
  // WEBVIEW SCREEN
  // ==========================================================

  @override
  Widget build(
      BuildContext context,
      ) {

    // ========================================================
    // CHROME SCREEN
    // ========================================================

    if (kIsWeb) {

      return Scaffold(

        appBar: AppBar(
          title:
          const Text(
            'Attendance Portal',
          ),

          backgroundColor:
          const Color(
            0xFF1F4E78,
          ),

          foregroundColor:
          Colors.white,
        ),

        body: const Center(
          child: Text(
            'Opening Attendance Portal...',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    // ========================================================
    // IOS / ANDROID SCREEN
    // ========================================================

    return PopScope(

      canPop: false,

      onPopInvokedWithResult:
          (didPop, result) async {

        if (didPop) {
          return;
        }

        final shouldPop =
        await handleBack();

        if (shouldPop &&
            mounted) {

          Navigator.pop(
            context,
          );
        }
      },

      child: Scaffold(

        appBar: AppBar(

          title:
          const Text(
            'Attendance Portal',
          ),

          backgroundColor:
          const Color(
            0xFF1F4E78,
          ),

          foregroundColor:
          Colors.white,
        ),

        body: Stack(

          children: [

            WebViewWidget(
              controller:
              controller,
            ),

            if (loading)
              const LinearProgressIndicator(
                minHeight: 3,
              ),
          ],
        ),
      ),
    );
  }
}