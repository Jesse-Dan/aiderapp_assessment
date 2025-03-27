import 'package:do_it_now/src/providers/auth_provider.dart';
import 'package:do_it_now/src/resources/extensions/context.dart';
import 'package:do_it_now/src/resources/utils/validator_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../resources/widgets/app_button.dart';
import '../../../../resources/widgets/app_text_field.dart';
import '../../../../resources/widgets/highlight_text.dart';
import '../register/register.dart';

class LoginView extends ConsumerWidget with ValidatorMixin {
  static const routeName = '/LoginView';
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final authProviderRef = ref.read(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    authProviderRef.loginUser();
                  }
                },
                text: 'Login',
              ),
              const SizedBox(height: 16),
              HighlightedText(
                text: "Don't have an account? Register",
                onWordClick: (word) {
                  switch (word) {
                    case 'Register':
                      Navigator.pushNamed(context, RegisterView.routeName);
                  }
                },
                defaultStyle: context.textTheme.labelLarge!.copyWith(),
                highlightWords: {
                  "Register": context.textTheme.labelLarge!
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
