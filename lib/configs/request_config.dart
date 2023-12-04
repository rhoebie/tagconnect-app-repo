import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestService {
  static Future<bool> checkAllPermission(AndroidDeviceInfo androidInfo) async {
    try {
      bool galleryPerm = await galleryPermission();
      bool storagePerm = await storagePermission(androidInfo);
      bool locationPerm = await locationPermission();
      bool cameraPerm = await cameraPermission();

      if (galleryPerm && locationPerm && cameraPerm && storagePerm) {
        return true;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
    return false;
  }

  static Future<bool> storagePermission(AndroidDeviceInfo androidInfo) async {
    if (androidInfo.version.sdkInt >= 30) {
      // For Android 30 and above (API level 30+), use new permission handling
      final storageStatus = await Permission.manageExternalStorage.status;

      if (storageStatus.isDenied) {
        final storageRequest = await Permission.manageExternalStorage.request();
        return storageRequest.isGranted;
      } else {
        return storageStatus.isGranted;
      }
    } else {
      // For Android 29 (API level 29) and below, use the old permission handling
      final storageStatus = await Permission.storage.status;

      if (storageStatus.isDenied) {
        final storagePermissionStatus = await Permission.storage.request();
        return storagePermissionStatus.isGranted;
      } else {
        return storageStatus.isGranted;
      }
    }
  }

  static Future<bool> galleryPermission() async {
    try {
      final galleryStatus = await Permission.mediaLibrary.status;

      if (galleryStatus.isDenied) {
        final galleryRequest = await Permission.mediaLibrary.request();
        return galleryRequest.isGranted;
      } else if (galleryStatus.isPermanentlyDenied) {
        await openAppSettings();
      } else {
        return galleryStatus.isGranted;
      }
    } catch (e) {
      print('Error Gallery Permission: $e');
      return false;
    }
    return false;
  }

  static Future<bool> locationPermission() async {
    try {
      final locationStatus = await Permission.location.status;

      if (locationStatus.isDenied) {
        final locationPermissionStatus = await Permission.location.request();
        return locationPermissionStatus.isGranted;
      } else if (locationStatus.isPermanentlyDenied) {
        await openAppSettings();
      } else {
        return locationStatus.isGranted;
      }
    } catch (e) {
      print('Error Location Permission: $e');
      return false;
    }
    return false;
  }

  static Future<bool> cameraPermission() async {
    try {
      final cameraStatus = await Permission.camera.status;
      if (cameraStatus.isDenied) {
        final cameraPermissionStatus = await Permission.camera.request();
        return cameraPermissionStatus.isGranted;
      } else if (cameraStatus.isPermanentlyDenied) {
        await openAppSettings();
      } else {
        return cameraStatus.isGranted;
      }
    } catch (e) {
      print('Error Camera Permission: $e');
      return false;
    }
    return false;
  }

  static Future<bool> notificationPermission() async {
    try {
      final notifStatus = await Permission.notification.status;
      if (notifStatus.isDenied) {
        final notifPermissionStatus = await Permission.notification.request();
        return notifPermissionStatus.isGranted;
      } else if (notifStatus.isPermanentlyDenied) {
        await openAppSettings();
      } else {
        return notifStatus.isGranted;
      }
    } catch (e) {
      print('Error Notification Permission: $e');
      return false;
    }
    return false;
  }
}
