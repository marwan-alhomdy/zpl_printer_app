import 'package:flutter/material.dart';
import 'package:zpl_printer_app/core/color_app.dart';

import '../text_style.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(14.0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          gradient: AppGradientColors.mainGradien,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          text,
          style: AppTextStyles.getMediumStyle(color: Colors.white),
        ),
      ),
    );
  }
}
