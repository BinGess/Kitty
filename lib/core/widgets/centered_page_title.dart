import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CenteredPageTitle extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets padding;
  final double height;

  const CenteredPageTitle({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 8),
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onBackground,
              ),
            ),
            if (leading != null)
              Align(
                alignment: Alignment.centerLeft,
                child: leading,
              ),
            if (trailing != null)
              Align(
                alignment: Alignment.centerRight,
                child: trailing,
              ),
          ],
        ),
      ),
    );
  }
}
