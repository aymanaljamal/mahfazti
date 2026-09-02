import 'package:flutter/material.dart';

import '../presentation/theme/app_theme.dart';
import 'router.dart';

class MahfaztiApp extends StatelessWidget {
  const MahfaztiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'محفظتي',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
