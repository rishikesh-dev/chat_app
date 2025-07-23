import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final Widget child;
  final double radius;
  const AvatarWidget({super.key, required this.child, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(radius: radius, child: child);
  }
}
