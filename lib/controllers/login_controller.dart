import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zini_pay/controllers/shared_preference.dart';
import 'package:zini_pay/pages/home_page/home_page.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController apiKeyController = TextEditingController();
  final PreferencesService preferencesService = PreferencesService();
  var isLoading = false.obs;

  bool _validateInput() {
    if (emailController.text.isEmpty && apiKeyController.text.isEmpty) {
      Get.snackbar('Please enter', 'Email and API key.');
      return false;
    }
    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Incorrect', 'Please enter a valid email address.');
      return false;
    }
    if (apiKeyController.text.isEmpty) {
      Get.snackbar('Error', 'API key cannot be empty.');
      return false;
    }
    return true;
  }

  Future<void> _login() async {
    const url = 'https://demo.zinipay.com/app/auth';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': emailController.text,
          'apiKey': apiKeyController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          await preferencesService.setLoginState(true);
          await preferencesService.setEmail(emailController.text);
          Get.to(() => HomePage());
          emailController.clear();
          apiKeyController.clear();
        } else {
          Get.snackbar(
              'Error', responseData['message'] ?? 'Authentication failed');
        }
      } else {
        Get.snackbar('Incorrect Credentials', 'Check the password and Api key');
      }
    } catch (error) {
      Get.snackbar(
          'Error', 'Failed to connect to the server. Try again later.');
    }
  }

  Future<void> handleLogin() async {
    if (_validateInput()) {
      isLoading.value = true;
      update();
      await _login();
      isLoading.value = false;
    }
  }
}
