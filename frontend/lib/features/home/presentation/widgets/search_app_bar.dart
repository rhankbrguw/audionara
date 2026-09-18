import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/search_strings.dart';
import '../../../../core/theme/app_colors.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final bool autofocus;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final Timer? debounceTimer;

  const SearchAppBar({
    super.key,
    required this.searchController,
    this.autofocus = false,
    required this.onSubmitted,
    required this.onChanged,
    required this.onClear,
    this.debounceTimer,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: AppColors.textPrimary,
        ),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        },
      ),
      title: TextField(
        controller: searchController,
        autofocus: autofocus,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: SearchStrings.searchHint,
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: onClear,
                )
              : null,
        ),
        onSubmitted: onSubmitted,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
