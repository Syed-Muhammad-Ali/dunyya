// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:dunyya/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewClass extends StatefulWidget {
  const WebViewClass({super.key});

  @override
  _WebViewClassState createState() => _WebViewClassState();
}

class _WebViewClassState extends State<WebViewClass> {
  WebViewController webViewController = WebViewController();
  final ValueNotifier<bool> isloadingNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isPageLoadingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      isloadingNotifier.value = false;
      requestCamera();
    });
    super.initState();
  }

  Future requestCamera() async {
    final status = await Permission.camera.request();
    final granted = status.isGranted;
    // if (!granted) {
    //   _showPermissionDialog(
    //     title: "Camera Permission Needed",
    //     message: "Enable camera permission to use this feature.",
    //   );
    // }
    // return granted;
  }

  Future<void> clearWebViewCache() async {
    await webViewController.clearCache();
    // await webViewController.clearCookies();
    // await clearCookies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.black,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              webViewController.reload();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
        leading: InkWell(
          onTap: () async {
            if (webViewController != null) {
              await clearWebViewCache(); // Clear cache before going back

              webViewController.goBack();
            }
          },
          child: Platform.isIOS
              ? Icon(Icons.arrow_back_ios, size: 25, color: Colors.white)
              : Icon(Icons.arrow_back, size: 20, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(
              controller: webViewController
                ..loadRequest(Uri.parse("https://dunyya.com/"))
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onProgress: (int progress) {
                      // Update loading bar.
                    },
                    onPageStarted: (String url) {
                      if (!isPageLoadingNotifier.value) {
                        isPageLoadingNotifier.value = true;
                      }
                    },

                    onHttpError: (error) {
                      print("Error $error");
                    },

                    onNavigationRequest: (request) async {
                      print('onNavigationRequest is ${request.url}');
                      return await NavigationDecision.navigate;
                    },

                    onPageFinished: (String url) {
                      if (isPageLoadingNotifier.value) {
                        isPageLoadingNotifier.value = false;
                      }
                    },
                    onWebResourceError: (WebResourceError error) {
                      // isPageLoadingNotifier.value=false;
                    },
                  ),
                ),
            ),
            ValueListenableBuilder(
              valueListenable: isPageLoadingNotifier,
              builder: (BuildContext context, bool value, Widget? child) {
                return value
                    ? Container(
                        color: Colors.grey.withOpacity(0.3),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 3, 144, 215),
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            ),
            ValueListenableBuilder(
              valueListenable: isloadingNotifier,
              builder: (BuildContext context, bool value, Widget? child) {
                return value ? const SplashScreen() : const SizedBox();
              },
            ),
            //
          ],
        ),
      ),
    );
  }
}
