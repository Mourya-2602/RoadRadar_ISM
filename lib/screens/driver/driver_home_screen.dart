import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/common/custom_app_bar.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Driver Home',
        showBackButton: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.drive_eta_outlined,
              size: 80,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              'Welcome, Driver',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            const Text(
              'Driver Home Screen',
              style: TextStyle(
                color: AppTheme.secondaryTextColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
