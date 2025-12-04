import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../ui/layouts/app_shell.dart';

// Screens
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/nutrition/presentation/screens/meal_register_screen.dart';
import '../../features/fasting/presentation/screens/fasting_timer_screen.dart';
import '../../features/workout/presentation/screens/workout_register_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_profile_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_biometrics_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_results_screen.dart';

import 'package:elena_app/core/router/router_refresh.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: "/login",

    // ------------------------------------------------------
    // SOLUCIÓN CLAVE: Reconstruye GoRouter al cambiar auth
    // ------------------------------------------------------
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),

    // ------------------------------------------------------
    // REDIRECT GLOBAL
    // ------------------------------------------------------
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;

      final loggingIn = state.matchedLocation == "/login";
      final registering = state.matchedLocation == "/register";
      final onboarding = state.matchedLocation.startsWith("/onboarding");

      // Si no está autenticado → solo puede ir a login o register
      if (user == null) {
        if (!loggingIn && !registering) {
          return "/login";
        }
        return null;
      }

      // Si ya está autenticado → no volver a login/register
      if (loggingIn || registering) {
        return "/dashboard";
      }

      // Onboarding intacto
      return null;
    },

    routes: [
      // ---------------------------
      // RUTAS PÚBLICAS
      // ---------------------------
      GoRoute(
        path: "/login",
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: "/register",
        builder: (_, __) => const RegisterScreen(),
      ),

      GoRoute(
        path: "/onboarding/profile",
        builder: (_, __) => const OnboardingProfileScreen(),
      ),
      GoRoute(
        path: "/onboarding/biometrics",
        builder: (_, __) => const OnboardingBiometricsScreen(),
      ),
      GoRoute(
        path: "/onboarding/results",
        builder: (_, __) => const OnboardingResultsScreen(),
      ),

      // ---------------------------
      // SHELL (NAV BAR)
      // ---------------------------
      ShellRoute(
        builder: (context, state, child) {
          final index = _calculateCurrentIndex(state.matchedLocation);
          return AppShell(
            child: child,
            currentIndex: index,
          );
        },
        routes: [
          GoRoute(
            path: "/dashboard",
            builder: (_, __) => const DashboardScreen(),
          ),
          GoRoute(
            path: "/register-meal",
            builder: (_, __) => const MealRegisterScreen(),
          ),
          GoRoute(
            path: "/fasting",
            builder: (_, __) => const FastingTimerScreen(),
          ),
          GoRoute(
            path: "/register-workout",
            builder: (_, __) => const WorkoutRegisterScreen(),
          ),
          GoRoute(
            path: "/profile",
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}

int _calculateCurrentIndex(String location) {
  if (location.startsWith("/dashboard")) return 0;
  if (location.startsWith("/register-meal")) return 1;
  if (location.startsWith("/fasting")) return 2;
  if (location.startsWith("/register-workout")) return 3;
  if (location.startsWith("/profile")) return 4;
  return 0;
}
