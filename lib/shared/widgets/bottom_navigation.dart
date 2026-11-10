
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StorytimeBottomNavigation extends StatefulWidget {
  const StorytimeBottomNavigation({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<StorytimeBottomNavigation> createState() => _StorytimeBottomNavigationState();
}

class _StorytimeBottomNavigationState extends State<StorytimeBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.navigationShell.currentIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Shope'),
      ],
      onTap: _onTap,
    );
  }

  void _onTap(index) {
    widget.navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
