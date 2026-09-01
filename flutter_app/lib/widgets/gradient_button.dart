import 'package:flutter/material.dart';
import 'package:srilambo_vpn/theme/app_theme.dart';

/// Reusable gradient CTA button used across all screens
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed == null
              ? const LinearGradient(colors: [Color(0xFF2A3050), Color(0xFF1E2438)])
              : AppTheme.greenGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: onPressed == null
              ? null
              : [BoxShadow(color: AppTheme.vpnGreen.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                )
              : Text(
                  label,
                  style: TextStyle(
                    color: onPressed == null ? AppTheme.textHint : Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
