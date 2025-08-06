import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatelessWidget {
  const RoundedButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.bgColor,
    this.foregroundColor,
    this.icon,
  });
  final String label;
  final Widget? icon;
  final Color? bgColor, foregroundColor;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? Theme.of(context).cardColor,
          foregroundColor:
              foregroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        icon: icon,
        label: Text(label, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
