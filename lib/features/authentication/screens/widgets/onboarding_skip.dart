import 'package:flutter/material.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../controllers/onboarding/onboarding_controller.dart';

// ignore: camel_case_types
class onBoardingSkip extends StatelessWidget {
  const onBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
        top: TDeviceUtils.getAppBarHeight(),
        right: TSizes.defaultSpace,
        child: TextButton(
            onPressed: () => onBoardingController.instance.skipPage(),
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.white, fontSize: 18),
            )));
  }
}
