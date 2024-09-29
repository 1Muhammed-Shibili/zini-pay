import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zini_pay/controllers/login_controller.dart';
import 'package:zini_pay/controllers/sms_controller.dart';

class BottomSheetCustom extends StatelessWidget {
  final SmsSyncController controller = Get.find<SmsSyncController>();
  final LoginController loginController = Get.find<LoginController>();

  BottomSheetCustom({super.key});

  void _showMessagesBottomSheet() {
    controller.fetchMessages().then((_) {
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'All Messages',
                      style: GoogleFonts.acme(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (controller.messages.isEmpty) {
                        return const Text('No messages available.');
                      }
                      return SizedBox(
                        height: 400,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.messages.length,
                            itemBuilder: (context, index) {
                              final message = controller.messages[index];
                              return ListTile(
                                title: Text(message['message'] ?? 'No message'),
                                subtitle: Text(
                                  'From: ${message['from']}\nTimestamp: ${message['time']}',
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 10,
                left: 10,
                child: Opacity(
                  opacity: 0.7,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                    ),
                    child: const Icon(Icons.close),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showDevicesBottomSheet() {
    controller.fetchDevices().then((_) {
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'All Devices',
                      style: GoogleFonts.acme(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (controller.devices.isEmpty) {
                        return const Text('No devices available.');
                      }
                      return SizedBox(
                          height: 400,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.devices.length,
                              itemBuilder: (context, index) {
                                final device = controller.devices[index];
                                return ListTile(
                                  title: Text(
                                      device['deviceName'] ?? 'No device name'),
                                  subtitle: Text('Email: ${device['email']}'),
                                );
                              },
                            ),
                          ));
                    }),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 10,
                left: 10,
                child: Opacity(
                  opacity: 0.7,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                    ),
                    child: const Icon(Icons.close),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void showMessages() {
    _showMessagesBottomSheet();
  }

  void showDevices() {
    _showDevicesBottomSheet();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
