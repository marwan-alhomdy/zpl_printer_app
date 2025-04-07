import 'package:flutter/material.dart';

import '../../color_app.dart';
import '../../text_style.dart';

class AppberWitoutBack extends StatelessWidget implements PreferredSizeWidget {
  const AppberWitoutBack({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.3,
      centerTitle: true,
      leadingWidth: 0,
      foregroundColor: AppColors.secondaryOneColor,
      leading: const SizedBox(),
      title: Text(
        title,
        style: AppTextStyles.getMediumStyle(
          fontSize: 16,
          color: AppColors.secondaryOneColor,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
