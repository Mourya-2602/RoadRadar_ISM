import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/common/custom_app_bar.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Driver Profile',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(
                Icons.person_outline,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              'Driver Profile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            const Text(
              'Profile details will be displayed here',
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
