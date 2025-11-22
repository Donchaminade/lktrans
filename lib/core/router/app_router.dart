import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/widgets/main_shell.dart';
import 'package:lktrans/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:lktrans/features/auth/presentation/screens/login_screen.dart';
import 'package:lktrans/features/auth/presentation/screens/otp_screen.dart';
import 'package:lktrans/features/auth/presentation/screens/signup_screen.dart';
import 'package:lktrans/features/home/presentation/screens/home_screen.dart';
import 'package:lktrans/features/routes/presentation/screens/route_catalog_screen.dart';
import 'package:lktrans/features/routes/presentation/screens/route_detail_screen.dart';
import 'package:lktrans/features/splash/presentation/screens/splash_screen.dart';
import 'package:lktrans/features/tickets/presentation/screens/confirmation_screen.dart';
import 'package:lktrans/features/tickets/presentation/screens/payment_screen.dart';
import 'package:lktrans/features/tickets/presentation/screens/reservation_screen.dart';
import 'package:lktrans/features/tickets/presentation/screens/ticket_detail_screen.dart'; // Import TicketDetailScreen
import 'package:lktrans/features/tickets/presentation/screens/tickets_screen.dart'; // Import TicketsScreen

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
        return MainShell(child: child);
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
          path: '/tickets', // Nouvelle route pour les tickets
          builder: (BuildContext context, GoRouterState state) => const TicketsScreen(),
        ),
        // Ajouter d'autres routes principales ici (ex: /history, /profile)
      ],
    ),
    GoRoute(
      path: '/route-details', // Modified to not use path parameter
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: RouteDetailScreen(
          routeId: state.extra! as String, // Extraira l'ID de 'extra'
        ),
      ),
    ),
    GoRoute(
      path: '/ticket-details', // New route for TicketDetailScreen
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: TicketDetailScreen(
          ticketData: state.extra! as Map<String, dynamic>, // Pass the entire ticket object
        ),
      ),
    ),
    GoRoute(
      path: '/reservation',
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: const ReservationScreen(),
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