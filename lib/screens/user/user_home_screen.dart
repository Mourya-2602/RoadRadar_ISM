import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/common/custom_app_bar.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Home',
        showBackButton: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_outlined,
              size: 80,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              'Welcome to Road Radar',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            const Text(
              'User Home Screen',
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
