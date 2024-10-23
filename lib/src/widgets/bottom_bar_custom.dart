import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final PageController controller;
  final Function(int) onItemSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.controller,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SlidingClippedNavBar(
      backgroundColor: Colors.white,
      onButtonPressed: (index) {
        onItemSelected(index);
        controller.animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuad,
        );
      },
      iconSize: 30,
      fontSize: 20,
      selectedIndex: selectedIndex,
      activeColor: Colors.blue,
      inactiveColor: Colors.grey.shade300,
      barItems: [
        BarItem(
          icon: Icons.edit_calendar,
          title: 'Tasks',
        ),
        BarItem(
          icon: Icons.check_circle_sharp,
          title: 'Completed',
        ),
        // Puedes agregar más ítems aquí
      ],
    );
  }
}
