import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class LimitedOfferBottomSheet extends StatelessWidget {
  const LimitedOfferBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2D1B2E),
            Color(0xFF1A0E1B),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                  'Sınırlı Teklif',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Jeton paketini seçerek bonus\nkazanın ve yeni bölümlerin kilidini açın!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 24),

                // Benefits section
                Text(
                  'Alacağınız Bonuslar',
                  style: AppTextStyles.headingSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Benefits icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBenefitItem(
                      icon: Icons.diamond,
                      label: 'Premium\nHesap',
                      color: const Color(0xFFE50914),
                    ),
                    _buildBenefitItem(
                      icon: Icons.favorite,
                      label: 'Daha\nFazla Eşleşme',
                      color: const Color(0xFFE50914),
                    ),
                    _buildBenefitItem(
                      icon: Icons.arrow_upward,
                      label: 'Öne\nÇıkarma',
                      color: const Color(0xFFE50914),
                    ),
                    _buildBenefitItem(
                      icon: Icons.favorite_border,
                      label: 'Daha\nFazla Beğeni',
                      color: const Color(0xFFE50914),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Package selection title
                Text(
                  'Kilidi açmak için bir jeton paketi seçin',
                  style: AppTextStyles.headingSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Package options
                Row(
                  children: [
                    Expanded(
                      child: _buildPackageCard(
                        discount: '-10%',
                        tokens: '200',
                        bonusTokens: '330',
                        price: '₺99,99',
                        subtitle: 'Başına haftalık',
                        color: const Color(0xFF8B1538),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPackageCard(
                        discount: '-70%',
                        tokens: '2.000',
                        bonusTokens: '3.375',
                        price: '₺799,99',
                        subtitle: 'Başına haftalık',
                        color: const Color(0xFF6B46C1),
                        isPopular: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPackageCard(
                        discount: '-35%',
                        tokens: '1.000',
                        bonusTokens: '1.350',
                        price: '₺399,99',
                        subtitle: 'Başına haftalık',
                        color: const Color(0xFF8B1538),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Show all tokens button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE50914), Color(0xFFC53030)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle show all tokens
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'Tüm Jetonları Gör',
                      style: AppTextStyles.buttonLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.grey[300],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPackageCard({
    required String discount,
    required String tokens,
    required String bonusTokens,
    required String price,
    required String subtitle,
    required Color color,
    bool isPopular = false,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle package selection
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: isPopular ? Border.all(color: const Color(0xFF6B46C1), width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Discount badge
            Container(
              margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                discount,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Tokens
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tokens,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      bonusTokens,
                      style: AppTextStyles.headingSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'Jeton',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Price
                    Text(
                      price,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
