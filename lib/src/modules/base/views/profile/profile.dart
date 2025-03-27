import 'package:do_it_now/src/resources/utils/show_text.dart';
import 'package:do_it_now/src/resources/widgets/app_button.dart';
import 'package:do_it_now/src/resources/widgets/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/views/login/login.dart';

final ValueNotifier<bool> editable = ValueNotifier<bool>(false);

class ProfileView extends ConsumerWidget {
  static const routeName = '/ProfileView';
  const ProfileView({super.key});

  Future<void> _updateDisplayName(BuildContext context, String newName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(newName);
        await user.reload();
        showText('Display name updated successfully');
      }
    } catch (e) {
      showText('Failed to update display name: $e');
    }
  }

  Future<void> _updatePhotoURL(BuildContext context, String url) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePhotoURL(url);
        await user.reload();
        showText('Profile photo updated successfully');
      }
    } catch (e) {
      showText('Failed to update Profile photo: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = FirebaseAuth.instance.currentUser;

    final TextEditingController nameController = TextEditingController(
      text: user?.displayName ?? '',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AppImagePicker(
                          onUploadComplete: (url) {
                            _updatePhotoURL(context, url.first);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black,
                  backgroundImage:
                      FirebaseAuth.instance.currentUser?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : const NetworkImage(
                                  'https://example.com/real-image-url.jpg')
                              as ImageProvider,
                ),
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: editable,
                builder: (context, isEditable, child) {
                  return isEditable
                      ? Column(
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Edit Display Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            AppButton(
                              onPressed: () {
                                _updateDisplayName(
                                    context, nameController.text);
                              },
                              text: 'Update Name',
                            ),
                            const SizedBox(height: 8),
                            AppButton(
                              buttonType: ButtonType.outlined,
                              onPressed: () {
                                editable.value = false;
                              },
                              text: 'Cancel',
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              user?.displayName ?? 'No Name',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              user?.email ?? 'No Email',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppButton(
                              content: const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              primaryColor: Colors.blue,
                              onPressed: () {
                                editable.value = true;
                              },
                            ),
                          ],
                        );
                },
              ),
              const SizedBox(height: 16),
              AppButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context)
                      .pushReplacementNamed(LoginView.routeName);
                  showText('Logged out');
                },
                text: 'Logout',
                primaryColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
