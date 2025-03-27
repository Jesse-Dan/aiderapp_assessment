import 'package:do_it_now/src/providers/auth_provider.dart';
import 'package:do_it_now/src/resources/extensions/context.dart';
import 'package:do_it_now/src/resources/utils/validator_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../resources/widgets/app_button.dart';
import '../../../../resources/widgets/app_text_field.dart';
import '../../../../resources/widgets/highlight_text.dart';

class RegisterView extends ConsumerWidget with ValidatorMixin {
  static const routeName = '/RegisterView';
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final authProviderRef = ref.read(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: authProviderRef.firstnameController,
                labelText: "First Name",
                validator: (str) => validateNotEmpty(str, 'First Name'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: authProviderRef.lastnameController,
                labelText: "Last Name",
                validator: (str) => validateNotEmpty(str, 'Last Name'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: authProviderRef.emailController,
                labelText: "Email",
                validator: validateEmail,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: authProviderRef.passwordController,
                labelText: 'Password',
                validator: validatePassword,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 16),
              AppButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    authProviderRef.registerUser();
                  }
                },
                text: 'Register',
              ),
              const SizedBox(height: 16),
              HighlightedText(
                text: "Already have an account? Login",
                onWordClick: (word) {
                  switch (word) {
                    case 'Login':
                      Navigator.pop(context);
                  }
                },
                defaultStyle: context.textTheme.labelLarge!.copyWith(),
                highlightWords: {
                  "Login": context.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.bold)
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
