import 'package:flutter/cupertino.dart';

class BaseShellLayout extends StatelessWidget {
  const BaseShellLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
