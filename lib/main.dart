import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: CaregiverApp()));
}

class CaregiverApp extends ConsumerStatefulWidget {
  const CaregiverApp({super.key});

  @override
  ConsumerState<CaregiverApp> createState() => _CaregiverAppState();
}

class _CaregiverAppState extends ConsumerState<CaregiverApp> {
  @override
  void initState() {
    super.initState();
    // Pre-authenticate default caregiver so the 5-tab AppShell is visible on launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).login('caregiver_demo_user');
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Carebuddy App',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}
