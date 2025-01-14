import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../t_clippath_widget/t_clippath_widget.dart';
import '../widgets/custom_shapes/containers/rounded_container.dart';

class TPrimaryCurvedWidget extends StatelessWidget {
  const TPrimaryCurvedWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TClipPathWidget(
      child: Container(
        color: Colors.green[700],
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
              top: -150,
              right: -250,
              child: TRoundedContainer(
                backgroundColor: TColors.textWhite.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: TRoundedContainer(
                backgroundColor: TColors.textWhite.withOpacity(0.1),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
