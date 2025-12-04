import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../elena_ui_system.dart';

class ElenaNavBar extends StatelessWidget {
  final int currentIndex;

  const ElenaNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.home_outlined, label: "Inicio", route: "/dashboard"),
      _NavItem(
          icon: Icons.restaurant_outlined,
          label: "Comidas",
          route: "/register-meal"),
      _NavItem(icon: Icons.access_time, label: "Ayuno", route: "/fasting"),
      _NavItem(
          icon: Icons.fitness_center_outlined,
          label: "Ejercicio",
          route: "/register-workout"),
      _NavItem(icon: Icons.person_outline, label: "Perfil", route: "/profile"),
    ];

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: const Offset(0, -2),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < items.length; i++)
              _buildNavItem(context, items[i], i == currentIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, _NavItem item, bool isActive) {
    return GestureDetector(
      onTap: () => context.go(item.route),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60, // evita usar Expanded
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 24,
              color: isActive ? ElenaColors.primary : Colors.grey.shade500,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive ? ElenaColors.primary : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;

  _NavItem({required this.icon, required this.label, required this.route});
}
