import 'package:flutter/material.dart';
import '../../../../core/widgets/confirm_dialog.dart';

/// Helper class to prompt the user for confirmation before logging out.
abstract class LogoutConfirmationDialog {
  static Future<bool> show(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Log Out',
      message:
          'Are you sure you want to log out of Care Manager Portal? Your session credentials will be cleared.',
      confirmLabel: 'Log Out',
      cancelLabel: 'Cancel',
      isDestructive: true,
      icon: Icons.logout_rounded,
    );
    return confirmed ?? false;
  }
}
