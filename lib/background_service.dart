import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';


class BackgroundService {
  BackgroundService() : super();

  static final service = FlutterBackgroundService();

  static Future<void> initializeService({bool? autostart}) async {
    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: autostart ?? true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          isForegroundMode: true,
          initialNotificationContent: 'Preparing',
          initialNotificationTitle: 'Background Service',
          autoStart: autostart ?? true,
          foregroundServiceNotificationId: 888),
    );
  }

  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // run background services/task for both Android & IOS

    if (service is AndroidServiceInstance) {
      // run background services/task for Andriod here
      // for ex...
      Timer.periodic(Duration(seconds: 1), (timer) {
        service.setForegroundNotificationInfo(
            title: "Background Service Demo",
            content: "${timer.tick} it is running");
      });
    }
    if (service is IOSServiceInstance) {
      // run background services/task for IOS here
      //
      //
    }
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    return true;
  }

  static void startService() async {
    if (await service.isRunning() == false) {
      service.startService();
    }
  }

  static void stopBackgroundService() async {
    if (await service.isRunning() == true) {
      service.invoke("stopService");
    }
  }
}
