import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/social_login_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Container(),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is AuthAuthenticated) {
            context.go('/home');
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom - 48,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(flex: 3),

                      Text(
                        'Hoşgeldiniz',
                        style: AppTextStyles.headingLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tempus varius ut vitae interdum id\ntortor elementum tristique eleifend at.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Ad Soyad',
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: AppColors.textHint,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ad soyad gerekli';
                          }
                          if (value.length < 2) {
                            return 'Ad soyad en az 2 karakter olmalı';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _emailController,
                        hintText: 'E-Posta',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.textHint,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'E-posta gerekli';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Geçerli bir e-posta girin';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Şifre',
                        obscureText: true,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.textHint,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Şifre gerekli';
                          }
                          if (value.length < 6) {
                            return 'Şifre en az 6 karakter olmalı';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Şifre Tekrar',
                        obscureText: true,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.textHint,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Şifre tekrarı gerekli';
                          }
                          if (value != _passwordController.text) {
                            return 'Şifreler eşleşmiyor';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            const TextSpan(text: 'Kullanıcı sözleşmesini '),
                            TextSpan(
                              text: 'okudum ve kabul ediyorum',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: '. Bu sözleşmeyi okuyarak devam ediniz lütfen.'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: 'Şimdi Kaydol',
                            isLoading: state is AuthLoading,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  AuthRegisterRequested(
                                    name: _nameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      SocialLoginRow(
                        onGooglePressed: () {
                        },
                        onApplePressed: () {
                        },
                        onFacebookPressed: () {
                        },
                      ),

                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Zaten bir hesabın var mı? ',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Giriş Yap!',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 65),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
