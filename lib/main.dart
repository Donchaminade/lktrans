import 'package:flutter/material.dart';
import 'package:lktrans/core/router/app_router.dart';
import 'package:lktrans/core/theme/app_theme.dart';

void main() {
  runApp(const LKTransApp());
}

class LKTransApp extends StatelessWidget {
  const LKTransApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'LKTrans',
      theme: AppTheme.light(),
    );
  }
}
