import 'package:device_info_plus/device_info_plus.dart';

class DeviceService {
  static Future<String> getDeviceId() async {
    final info = DeviceInfoPlugin();
    try {
      final android = await info.androidInfo;
      return android.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    } catch (e) {
      // Fallback
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }
}
