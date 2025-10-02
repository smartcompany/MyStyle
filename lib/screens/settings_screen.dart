import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.settings ?? 'Settings',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
        ),
      ),
      body: Container(
        color: const Color(0xFFF8FAFC),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 앱 정보 섹션
            _buildSectionHeader(
              AppLocalizations.of(context)?.appInfo ?? 'App Information',
            ),
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: AppLocalizations.of(context)?.appVersion ?? 'App Version',
              subtitle: '1.0.0',
              onTap: () {},
              showTrailing: false,
            ),

            const SizedBox(height: 24),

            // 개인정보 및 보안 섹션
            _buildSectionHeader(
              AppLocalizations.of(context)?.privacyAndSecurity ??
                  'Privacy & Security',
            ),
            _buildSettingsTile(
              icon: Icons.privacy_tip_outlined,
              title:
                  AppLocalizations.of(context)?.privacyPolicy ??
                  'Privacy Policy',
              subtitle:
                  AppLocalizations.of(context)?.privacyPolicyDescription ??
                  'View our privacy policy',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showTrailing = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        trailing: showTrailing
            ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
            : null,
        onTap: onTap,
      ),
    );
  }
}
