import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zini_pay/controllers/login_controller.dart';
import 'package:zini_pay/controllers/shared_preference.dart';
import 'package:zini_pay/pages/home_page/home_page.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final PreferencesService preferencesService = PreferencesService();

  LoginPage({Key? key}) : super(key: key) {
    _checkLoggedIn();
  }

  void _checkLoggedIn() async {
    final isLoggedIn = await preferencesService.getLoginState();

    if (isLoggedIn) {
      Get.offAll(HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                SvgPicture.asset('assets/images/amico.svg',
                    width: 342, height: 348),
                const SizedBox(height: 10),
                Text(
                  'Log in',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF36454F),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0XFF36454F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 288,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3D3D3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: loginController.emailController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          border: InputBorder.none,
                          hintText: 'jondoe@example.com',
                          hintStyle: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color(0X8036454F),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Api Key',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0XFF36454F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 288,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3D3D3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: loginController.apiKeyController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Obx(() => loginController.isLoading.value
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: 288,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () async {
                            await loginController.handleLogin();
                            if (!loginController.isLoading.value) {
                              await preferencesService.setLoginState(true);
                              await preferencesService.setEmail(
                                  loginController.emailController.text);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Log in',
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                color: Color(0XFFD3D3D3),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
