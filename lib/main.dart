import 'package:flutter/material.dart';
import 'constants/app_theme.dart';
import 'constants/app_constants.dart';
import 'router/app_router.dart';

void main() {
  runApp(const StyleGuideApp());
}

class StyleGuideApp extends StatelessWidget {
  const StyleGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
