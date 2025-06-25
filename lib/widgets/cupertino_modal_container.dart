import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

class CupertinoModalContainer extends StatelessWidget {
  const CupertinoModalContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: math.max(216, MediaQuery.of(context).size.height * 0.4),
      padding: const EdgeInsets.all(4.0),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6.resolveFrom(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      child: child,
    );
  }
}
