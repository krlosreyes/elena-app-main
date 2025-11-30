import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Auth
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';

// Onboarding (nuevos archivos)
import '../../features/onboarding/presentation/screens/onboarding_profile_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_biometrics_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_results_screen.dart';

// Main app screens
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/fasting/presentation/screens/fasting_timer_screen.dart';
import '../../features/nutrition/presentation/screens/meal_register_screen.dart';
import '../../features/workout/presentation/screens/workout_register_screen.dart';
import '../../features/body_composition/presentation/screens/weekly_checkin_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';

/// Provider del router principal
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',

    // ---------------------------------------------------
    // REDIRECT DE AUTENTICACIÓN
    // ---------------------------------------------------
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isAuth = user != null;

      final publicRoutes = ['/login', '/register'];
      final isPublicRoute = publicRoutes.contains(state.matchedLocation);

      // Si NO está autenticado y va a una ruta privada
      if (!isAuth && !isPublicRoute) {
        return '/login';
      }

      // Si está autenticado e intenta ir a login/register
      if (isAuth && isPublicRoute) {
        return '/dashboard';
      }

      return null;
    },

    // ---------------------------------------------------
    // RUTAS
    // ---------------------------------------------------
    routes: [
      // ------------------
      // AUTH
      // ------------------
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),

      // ------------------
      // ONBOARDING NUEVO
      // ------------------

      /// Pantalla 1 – Perfil personal
      // ------------------
// ONBOARDING NUEVO
// ------------------

      GoRoute(
        path: '/onboarding/profile',
        builder: (_, __) => const OnboardingProfileScreen(),
      ),

      GoRoute(
        path: '/onboarding/biometrics',
        builder: (_, __) => const OnboardingBiometricsScreen(),
      ),

      GoRoute(
        path: '/onboarding/results',
        builder: (_, __) => const OnboardingResultsScreen(),
      ),

      // ------------------
      // MAIN APP
      // ------------------

      GoRoute(
        path: '/dashboard',
        builder: (_, __) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/fasting',
        builder: (_, __) => const FastingTimerScreen(),
      ),
      GoRoute(
        path: '/register-meal',
        builder: (_, __) => const MealRegisterScreen(),
      ),
      GoRoute(
        path: '/register-workout',
        builder: (_, __) => const WorkoutRegisterScreen(),
      ),
      GoRoute(
        path: '/weekly-checkin',
        builder: (_, __) => const WeeklyCheckinScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (_, __) => const HistoryScreen(),
      ),
    ],

    // Error – pantalla genérica
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Página no encontrada: ${state.matchedLocation}',
        ),
      ),
    ),
  );
});
