import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zini_pay/pages/login_page/login_page.dart';

Future<void> logout() async {
  final shouldLogout = await Get.dialog<bool>(
    AlertDialog(
      title: Text(
        'Confirm Logout',
        style: GoogleFonts.montserrat(),
      ),
      content: Text(
        'Are you sure you want to log out?',
        style: GoogleFonts.montserrat(),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text(
            'Cancel',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0XFF36454F),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: Text(
            'Logout',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    ),
  );
  if (shouldLogout == true) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('email');
    Get.offAll(() => LoginPage());
  }
}
