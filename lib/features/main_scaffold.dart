import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ScaffoldWithNavbar extends ConsumerStatefulWidget {
   ScaffoldWithNavbar(this.navigationShell, {super.key});
   StatefulNavigationShell navigationShell;

   @override
   ConsumerState<ScaffoldWithNavbar> createState() => _ScaffoldWithNavbarState();
}

class _ScaffoldWithNavbarState extends ConsumerState<ScaffoldWithNavbar> with TickerProviderStateMixin {

  @override
  void initState() {
    appInitializer.performStartupLogic(context,ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
          children:[
            widget.navigationShell,
          ]
      ),
    );
  }

}