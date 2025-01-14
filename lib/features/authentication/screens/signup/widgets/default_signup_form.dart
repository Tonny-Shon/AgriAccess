import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import '../../../../../controllers/signup_controller/signup_controller.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import 'terms_conditions_checkbox.dart';

class TDefaultSignupForm extends StatelessWidget {
  const TDefaultSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    //final dark = THelperFunctions.isDarkMode(context);

    return Form(
      key: controller.signupFormkey1,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  expands: false,
                  controller: controller.firstname,
                  validator: (value) =>
                      TValidator.validateEmptyText('First Name', value),
                  decoration: const InputDecoration(
                      labelText: TTexts.firstName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwinputFields),
              Expanded(
                child: TextFormField(
                  expands: false,
                  validator: (value) =>
                      TValidator.validateEmptyText('Last Name', value),
                  controller: controller.lastname,
                  decoration: const InputDecoration(
                      labelText: TTexts.lastName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwinputFields),

          //Username
          TextFormField(
            controller: controller.username,
            validator: (value) =>
                TValidator.validateEmptyText('User name', value),
            expands: false,
            decoration: const InputDecoration(
                labelText: TTexts.username,
                prefixIcon: Icon(Iconsax.user_edit)),
          ),
          const SizedBox(height: TSizes.spaceBtwinputFields),

          //Phone Number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => TValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
                labelText: TTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
          ),
          const SizedBox(height: TSizes.spaceBtwinputFields),

          //Password
          Obx(
            () => TextFormField(
              validator: (value) => TValidator.validatePassword(value),
              controller: controller.password,
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: TTexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye)),
              ),
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwinputFields),

          //Terms & conditions Checkbox
          const TTermsAndConditionsCheckbox(),

          const SizedBox(height: TSizes.spaceBtwSections),
          //Sign up Button

          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => !controller.privacyPolicy.value
                    ? {}
                    : controller.signupuser(
                        //categoryController.selectedCategory.value!
                        ),
                style: ElevatedButton.styleFrom(
                    iconColor: Colors.green,
                    side: const BorderSide(color: Colors.transparent),
                    backgroundColor: !controller.privacyPolicy.value
                        ? Colors.grey
                        : Colors.green[800]),
                // Get.to(() => const VerifyEmailScreen()),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(TTexts.createUserAccount),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
