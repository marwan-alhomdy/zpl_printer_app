import 'package:flutter/material.dart';

import '../../color_app.dart';
import '../../text_style.dart';

class AppberWithBack extends StatelessWidget implements PreferredSizeWidget {
  const AppberWithBack({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.3,
      centerTitle: true,
      leadingWidth: 60,
      foregroundColor: AppColors.secondaryOneColor,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios),
      ),
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
