import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


enum SocialLoginType { google, apple, facebook }

class SocialLoginButton extends StatelessWidget {
  final SocialLoginType type;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.type,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: _getForegroundColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(_getForegroundColor()),
                ),
              )
            : _buildIcon(),
      ),
    );
  }

  Color _getBackgroundColor() {
    // Tüm social butonlar CustomTextField renginde olsun
    return AppColors.inputBackground;
  }

  Color _getForegroundColor() {
    // Tüm iconlar beyaz olsun
    return AppColors.textPrimary;
  }

  Widget _buildIcon() {
    switch (type) {
      case SocialLoginType.google:
        return Text(
          'G',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _getForegroundColor(),
          ),
        );
      case SocialLoginType.apple:
        return Icon(
          Icons.apple,
          size: 24,
          color: _getForegroundColor(),
        );
      case SocialLoginType.facebook:
        return Icon(
          Icons.facebook,
          size: 24,
          color: _getForegroundColor(),
        );
    }
  }
}

class SocialLoginRow extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;
  final bool isLoading;

  const SocialLoginRow({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialLoginButton(
          type: SocialLoginType.google,
          onPressed: onGooglePressed,
          isLoading: isLoading,
        ),
        const SizedBox(width: 16),
        SocialLoginButton(
          type: SocialLoginType.apple,
          onPressed: onApplePressed,
          isLoading: isLoading,
        ),
        const SizedBox(width: 16),
        SocialLoginButton(
          type: SocialLoginType.facebook,
          onPressed: onFacebookPressed,
          isLoading: isLoading,
        ),
      ],
    );
  }
}
