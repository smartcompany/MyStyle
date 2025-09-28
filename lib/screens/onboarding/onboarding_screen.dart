import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_theme.dart';
import '../photo_upload_screen.dart';
import '../../widgets/common/app_button.dart';
import '../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;

  late List<OnboardingPage> _pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  void _initializePages(BuildContext context) {
    _pages = [
      OnboardingPage(
        title: AppLocalizations.of(context)!.aiStyleDiagnosis,
        subtitle: AppLocalizations.of(context)!.findYourStyleSubtitle,
        description: AppLocalizations.of(context)!.expertLevelAnalysis,
        icon: Icons.face_retouching_natural,
        color: AppTheme.primaryColor,
      ),
      OnboardingPage(
        title: AppLocalizations.of(context)!.customizedGuide,
        subtitle: AppLocalizations.of(context)!.detailedGuidance,
        description: AppLocalizations.of(context)!.actionableAdvice,
        icon: Icons.style,
        color: AppTheme.secondaryColor,
      ),
      OnboardingPage(
        title: AppLocalizations.of(context)!.comprehensiveAnalysis,
        subtitle: AppLocalizations.of(context)!.styleGuide,
        description: AppLocalizations.of(context)!.detailedAnalysis,
        icon: Icons.psychology,
        color: AppTheme.accentColor,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _startApp();
    }
  }

  void _skipOnboarding() {
    _startApp();
  }

  void _startApp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const PhotoUploadScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    _initializePages(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Skip Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: const Text(
                        '건너뛰기',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // Bottom Section
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Page Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppTheme.primaryColor
                                : AppTheme.borderColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Next Button
                    AppButton(
                      text: _currentPage == _pages.length - 1
                          ? AppLocalizations.of(context)!.startAnalysis
                          : AppLocalizations.of(context)!.next,
                      onPressed: _nextPage,
                      isFullWidth: true,
                      icon: _currentPage == _pages.length - 1
                          ? Icons.arrow_forward
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 60, color: page.color),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Subtitle
          Text(
            page.subtitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Description
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });
}
