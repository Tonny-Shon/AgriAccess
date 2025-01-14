import 'package:agriaccess/features/authentication/screens/signup/default_signup.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import '../../../../../controllers/login_controller/login_controller.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../signup/signup.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
      child: Form(
        key: loginController.loginformKey,
        child: Column(
          children: [
            ///Email
            TextFormField(
              controller: loginController.username,
              validator: (value) =>
                  TValidator.validateEmptyText('Username', value),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: TTexts.username),
            ),
            const SizedBox(height: TSizes.spaceBtwinputFields),

            ///Password
            Obx(
              () => TextFormField(
                obscureText: loginController.hidePassword.value,
                controller: loginController.password,
                validator: (value) =>
                    TValidator.validateEmptyText('Password', value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  labelText: TTexts.password,
                  suffixIcon: IconButton(
                    onPressed: () => loginController.hidePassword.value =
                        !loginController.hidePassword.value,
                    icon: Icon(!loginController.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye),
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwinputFields / 2),

            ///Remember me and forget password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///Remember me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(TTexts.rememberMe),
                  ],
                ),

                ///Forgot password
                TextButton(
                  onPressed: () {},
                  child: const Text(TTexts.forgetPassword),
                ),
              ],
            ),

            ///Signin button

            Obx(
              () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => loginController.loginuser(),
                    style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Colors.transparent),
                        backgroundColor: Colors.green[800]),

                    //Get.to(() => NavigationMenu()),
                    child: loginController.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(TTexts.signIn),
                  )),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            ///Create account button

            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final isLoggedIn = GetStorage().read('loggedInUserId');
                    if (isLoggedIn == null) {
                      Get.to(() => const DefaultSignupScreen());
                    } else {
                      Get.to(() => const SignupScreen());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      backgroundColor: Colors.transparent),
                  child: const Text(
                    TTexts.createAccount,
                    style: TextStyle(color: Colors.green),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
