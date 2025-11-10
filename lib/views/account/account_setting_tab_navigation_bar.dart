import 'package:flutter/material.dart';
import '../../colors.dart';

class AccountSettingTabNavigationBar extends StatelessWidget {
  const AccountSettingTabNavigationBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 600;
        
        if (isSmallScreen) {
          // Show dropdown on small screens
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<int>(
                value: selectedIndex,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                items: List.generate(tabs.length, (index) {
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    onTabChanged(value);
                  }
                },
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textPrimary,
                ),
                dropdownColor: AppColors.white,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          );
        }
        
        // Show tab bar on larger screens
        final tabBarWidth = screenWidth * 0.45;
        
        return Center(
          child: SizedBox(
            width: tabBarWidth,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: List.generate(tabs.length, (index) {
                  final isSelected = index == selectedIndex;
                  final isFirst = index == 0;
                  final isLast = index == tabs.length - 1;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTabChanged(index),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.white : Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: isFirst && isSelected
                                ? const Radius.circular(8)
                                : Radius.zero,
                            bottomLeft: isFirst && isSelected
                                ? const Radius.circular(8)
                                : Radius.zero,
                            topRight: isLast && isSelected
                                ? const Radius.circular(8)
                                : Radius.zero,
                            bottomRight: isLast && isSelected
                                ? const Radius.circular(8)
                                : Radius.zero,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        child: Center(
                          child: Text(
                            tabs[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

