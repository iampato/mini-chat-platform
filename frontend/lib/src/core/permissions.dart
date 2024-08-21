// request location permission
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestLocationPermission(
  BuildContext context, {
  bool openSettings = true,
}) async {
  final permission = await Permission.location.request();
  if (permission.isGranted) {
    return true;
  } else if (permission.isDenied) {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Location Permission"),
        content: const Text(
            "Location permission is required to use this application"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Deny"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
    if (result == true) {
      final permission = await Permission.location.request();
      if (permission.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else if (permission.isPermanentlyDenied) {
    if (openSettings) {
      // show dialog to open settings
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Location Permission"),
          content: const Text(
              "Location permission is required to use this application"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Deny"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );
    }

    return false;
  } else {
    return false;
  }
}


Future<bool> requestStoragePermission(
  BuildContext context, {
  bool openSettings = true,
}) async {
  final permission = await Permission.storage.request();
  if (permission.isGranted) {
    return true;
  } else if (permission.isDenied) {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Storage Permission"),
        content: const Text(
            "Storage permission is required to use this application"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Deny"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
    if (result == true) {
      final permission = await Permission.location.request();
      if (permission.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else if (permission.isPermanentlyDenied) {
    if (openSettings) {
      // show dialog to open settings
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Storage Permission"),
          content: const Text(
              "Storage permission is required to use this application"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Deny"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );
    }

    return false;
  } else {
    return false;
  }
}
