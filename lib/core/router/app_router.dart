import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/widgets/main_shell.dart';
import 'package:lktrans/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:lktrans/features/auth/presentation/screens/login_screen.dart';
import 'package:lktrans/features/auth/presentation/screens/otp_screen.dart';
import 'package:lktrans/features/auth/presentation/screens/signup_screen.dart';
import 'package:lktrans/features/home/presentation/screens/home_screen.dart';
import 'package:lktrans/features/history/presentation/screens/statistics_screen.dart';
import 'package:lktrans/features/routes/presentation/screens/route_catalog_screen.dart';
import 'package:lktrans/features/routes/presentation/screens/route_detail_screen.dart';
import 'package:lktrans/features/splash/presentation/screens/splash_screen.dart';
import 'package:lktrans/features/tickets/presentation/screens/confirmation_screen.dart';
import 'package:lktrans/features/tickets/presentation/screens/payment_screen.dart';
import 'package:lktrans/features/tickets/presentation/screens/reservation_screen.dart';
import 'package:lktrans/features/tickets/presentation/screens/ticket_detail_screen.dart';
import 'package:lktrans/features/tickets/presentation/screens/tickets_screen.dart';
import 'package:lktrans/features/profile/presentation/screens/profile_screen.dart';
import 'package:lktrans/features/profile/presentation/screens/profile_details_screen.dart'; // New import
import 'package:lktrans/features/settings/presentation/screens/app_settings_screen.dart'; // New import

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: const SignupScreen(),
      ),
    ),
    GoRoute(
      path: '/forgot-password',
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: const ForgotPasswordScreen(),
      ),
    ),
    GoRoute(
      path: '/otp',
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: const OTPScreen(),
      ),
    ),
    // ShellRoute pour la navigation principale avec BottomNavBar
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return MainShell(key: state.pageKey, child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/routes',
          builder: (BuildContext context, GoRouterState state) => const RouteCatalogScreen(),
        ),
        GoRoute(
          path: '/tickets',
          builder: (BuildContext context, GoRouterState state) => const TicketsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/history', // Route pour les statistiques
          builder: (BuildContext context, GoRouterState state) => const StatisticsScreen(),
        ),
        // Ajouter d'autres routes principales ici (ex: /profile)
      ],
    ),
    GoRoute(
      path: '/route-details',
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: RouteDetailScreen(
          routeId: state.extra! as String,
        ),
      ),
    ),
    GoRoute(
      path: '/ticket-details',
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: TicketDetailScreen(
          ticketData: state.extra! as Map<String, dynamic>,
        ),
      ),
    ),
    GoRoute(
      path: '/reservation',
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: ReservationScreen(
          routeData: state.extra as Map<String, dynamic>?, // Optional route data
        ),
      ),
    ),
    GoRoute(
      path: '/payment',
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: const PaymentScreen(),
      ),
    ),
    GoRoute(
      path: '/confirmation',
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: const ConfirmationScreen(),
      ),
    ),
    GoRoute(
      path: '/profile-details', // New route
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: const ProfileDetailsScreen(),
      ),
    ),
    GoRoute(
      path: '/app-settings', // New route
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: const AppSettingsScreen(),
      ),
    ),
  ],
);

CustomTransitionPage<T> _buildPageWithFadeTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
    transitionDuration: const Duration(milliseconds: 400),
  );
}