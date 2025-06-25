import 'package:flutter/material.dart';

import '../../../../gen/assets.gen.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(Assets.images.mapPlaceholder.path);
  }
}
