import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  BottomNavigationBarItem _buildNavItem({
    required IconData icon, 
    required String label, 
    required int navIndex,
    bool isCenterButton = false,
  }) {
    final bool isSelected = currentIndex == navIndex;
    final Color iconColor = isCenterButton 
        ? kSecondaryColor 
        : (isSelected ? kSecondaryColor : kTextColor.withAlpha(178));
    
    Widget finalIcon = isCenterButton 
        ? Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: kSecondaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: kTextColor, size: 30.0),
          )
        : Icon(icon, color: iconColor, size: 28);

    if (isCenterButton) {
      finalIcon = Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: finalIcon,
      );
    }

    return BottomNavigationBarItem(
      icon: finalIcon, 
      label: label, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kInputFillColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25), 
          topRight: Radius.circular(25),
        ),
        border: Border.all(color: Colors.white.withAlpha(20), width: 1.0), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(75), 
            blurRadius: 15, 
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          items: [
            _buildNavItem(icon: Icons.home, label: 'Home', navIndex: 0),
            _buildNavItem(icon: Icons.bar_chart, label: 'Stats', navIndex: 1),
            _buildNavItem(icon: Icons.add, label: '', navIndex: 2, isCenterButton: true), 
            _buildNavItem(icon: Icons.calendar_month, label: 'Log', navIndex: 3),
            _buildNavItem(icon: Icons.person, label: 'Profile', navIndex: 4),
          ],
          currentIndex: currentIndex, 
          selectedItemColor: kSecondaryColor,
          unselectedItemColor: kTextColor.withAlpha(178),
          backgroundColor: kInputFillColor, 
          type: BottomNavigationBarType.fixed,
          iconSize: 28.0, 
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
