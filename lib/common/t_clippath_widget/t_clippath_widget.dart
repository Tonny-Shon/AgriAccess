import 'package:flutter/material.dart';
import '../widgets/custom_shapes/curved_edges/curved_edges.dart';

class TClipPathWidget extends StatelessWidget {
  const TClipPathWidget({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TCustomCurvedEdges(),
      child: child,
    );
  }
}
