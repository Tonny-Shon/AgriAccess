import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'bindings/bindings.dart';
import 'features/authentication/screens/onboarding/onboarding.dart';
import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: const OnBoardingScreen(),
      initialBinding: GeneralBindings(),
      debugShowCheckedModeBanner: false,
    );
  }
}
