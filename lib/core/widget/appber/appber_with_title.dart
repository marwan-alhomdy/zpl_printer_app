import 'package:flutter/material.dart';

import '../../color_app.dart';
import '../../text_style.dart';

class AppberWithTitle extends StatelessWidget implements PreferredSizeWidget {
  const AppberWithTitle({super.key, required this.title, this.actions});
  final String title;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.3,
      centerTitle: true,
      leadingWidth: 50,
      foregroundColor: AppColors.secondaryOneColor,
      actions: actions,
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
