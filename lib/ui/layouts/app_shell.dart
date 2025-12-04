import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../elena_ui_system.dart';
import 'elena_navbar.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const AppShell({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 900;

        return Scaffold(
          backgroundColor: ElenaColors.background,
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------------------------------
                // MENU LATERAL PARA WEB/ESCRITORIO
                // ---------------------------------------
                if (isWide)
                  NavigationRail(
                    selectedIndex: currentIndex,
                    onDestinationSelected: (index) =>
                        _onItemTap(index, context),
                    labelType: NavigationRailLabelType.selected,
                    leading: const SizedBox(height: 8),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: Text("Inicio"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.restaurant_outlined),
                        selectedIcon: Icon(Icons.restaurant),
                        label: Text("Comidas"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.access_time),
                        selectedIcon: Icon(Icons.access_time_filled),
                        label: Text("Ayuno"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.fitness_center_outlined),
                        selectedIcon: Icon(Icons.fitness_center),
                        label: Text("Ejercicio"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_outline),
                        selectedIcon: Icon(Icons.person),
                        label: Text("Perfil"),
                      ),
                    ],
                  ),

                // ---------------------------------------
                // CHILD (siempre una sola instancia)
                // ---------------------------------------
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),

          // ---------------------------------------
          // NAVBAR SOLO PARA MÓVIL
          // ---------------------------------------
          bottomNavigationBar:
              isWide ? null : ElenaNavBar(currentIndex: currentIndex),
        );
      },
    );
  }

  // ---------------------------------------
  // NAVEGACIÓN (versión optimizada)
  // ---------------------------------------
  void _onItemTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.push('/register-meal');
        break;
      case 2:
        context.push('/fasting');
        break;
      case 3:
        context.push('/register-workout');
        break;
      case 4:
        context.push('/profile');
        break;
      default:
        context.go('/dashboard');
    }
  }
}
