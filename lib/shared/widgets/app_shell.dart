import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

/// Bottom navigation shell for the 5 main tabs.
class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({required this.child, super.key});

  static const _tabs = [
    _TabItem(label: 'Home', icon: Icons.grid_view_rounded, path: '/'),
    _TabItem(label: 'Rides', icon: Icons.route_rounded, path: '/rides'),
    _TabItem(label: 'Ride', icon: Icons.play_circle_rounded, path: '/ride-tracking'),
    _TabItem(label: 'Fuel', icon: Icons.local_gas_station_rounded, path: '/fuel'),
    _TabItem(label: 'More', icon: Icons.apps_rounded, path: '/more'),
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/rides')) return 1;
    if (location.startsWith('/ride-tracking')) return 2;
    if (location.startsWith('/fuel')) return 3;
    if (location.startsWith('/more')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: child,
      bottomNavigationBar: _RLBottomNav(
        selectedIndex: selectedIndex,
        tabs: _tabs,
        onTap: (i) => context.go(_tabs[i].path),
      ),
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  final String path;
  const _TabItem({required this.label, required this.icon, required this.path});
}

class _RLBottomNav extends StatelessWidget {
  final int selectedIndex;
  final List<_TabItem> tabs;
  final ValueChanged<int> onTap;

  const _RLBottomNav({
    required this.selectedIndex,
    required this.tabs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68 + MediaQuery.of(context).padding.bottom,
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(
          children: List.generate(tabs.length, (i) {
            final isSelected = i == selectedIndex;
            final isCenter = i == 2; // Ride button — slightly highlighted
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isCenter)
                      Container(
                        width: 48,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.amber
                              : AppColors.amberSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.amber
                                : AppColors.amberDim,
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          tabs[i].icon,
                          size: 20,
                          color: isSelected
                              ? AppColors.textInverse
                              : AppColors.amber,
                        ),
                      )
                    else
                      Icon(
                        tabs[i].icon,
                        size: 22,
                        color: isSelected
                            ? AppColors.amber
                            : AppColors.textMuted,
                      ),
                    const SizedBox(height: 4),
                    Text(
                      tabs[i].label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? (isCenter && !isSelected
                                ? AppColors.amber
                                : AppColors.amber)
                            : AppColors.textMuted,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
