import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../widgets/common/custom_button.dart';
import '../services/api_service.dart';

class OnboardingScreen extends StatefulWidget {
  final int initialPage;
  final bool roleSelection;

  const OnboardingScreen(
      {super.key, this.initialPage = 0, this.roleSelection = false});

  // Named constructor for showing the last page directly
  const OnboardingScreen.roleSelection({super.key})
      : initialPage = 2,
        roleSelection = true;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  late int _currentPage;
  final int _totalPages = 3;

  final List<OnboardingPage> _pages = [
    const OnboardingPage(
      title: 'Welcome to Road Radar',
      description:
          'Track public vehicles in real-time and make your journey easier.',
      icon: Icons.location_on,
    ),
    const OnboardingPage(
      title: 'Choose Your Role',
      description:
          'Are you a user looking for vehicles, a driver, or an admin?',
      icon: Icons.people_alt,
    ),
    const OnboardingPage(
      title: 'Get Started',
      description: 'Select your role to continue to the app.',
      icon: Icons.arrow_forward,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToNextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: _pages,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _totalPages,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.primaryColor
                              : AppTheme.primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Next button
                  if (_currentPage < _totalPages - 1)
                    CustomButton(
                      text: 'Next',
                      onPressed: _navigateToNextPage,
                    ),

                  // Role selection buttons on last page
                  if (_currentPage == _totalPages - 1)
                    Column(
                      children: [
                        CustomButton(
                          text: 'Continue as User',
                          onPressed: () {
                            _showUserNameDialog(context);
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomButton(
                          text: 'I am a Driver',
                          isSecondary: true,
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.login);
                          },
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            _showAdminPinDialog(context);
                          },
                          child: const Text(
                            'Admin Access',
                            style: TextStyle(
                              color: AppTheme.secondaryTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to enter username for user role
  void _showUserNameDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final ApiService apiService = ApiService();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Your Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Your name',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  // Show loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Dialog(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 20),
                              Text("Saving..."),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  // Save user name to shared preferences
                  final result = await apiService.saveUserName(name);

                  // Close loading dialog
                  Navigator.pop(context);

                  if (result) {
                    // Close name dialog
                    Navigator.pop(context);
                    // Navigate to user home
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.userHome);
                  } else {
                    // Show error if saving failed
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to save name. Please try again.'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  // Dialog to enter admin PIN
  void _showAdminPinDialog(BuildContext context) {
    final TextEditingController pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Admin Access'),
          content: TextField(
            controller: pinController,
            decoration: const InputDecoration(
              hintText: 'Enter PIN',
            ),
            keyboardType: TextInputType.number,
            obscureText: true,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (pinController.text.trim() == '123456') {
                  // Hardcoded for demo
                  Navigator.pop(context);
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.adminHome);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid PIN. Please try again.'),
                    ),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }
}

// Individual onboarding page
class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 50,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: AppTheme.headingStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: AppTheme.bodyStyle.copyWith(
              color: AppTheme.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
