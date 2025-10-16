import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_routes.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/app_button.dart';
import '../../constants/app_theme.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen>
    with TickerProviderStateMixin {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
        preferredCameraDevice: source == ImageSource.camera
            ? CameraDevice.front
            : CameraDevice.rear,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar(AppLocalizations.of(context)!.imageSelectionError);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _analyzePhoto() {
    if (_selectedImage != null) {
      context.push(AppRoutes.analysis);
    }
  }

  void _retakePhoto() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.photoUpload),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.uploadFacePhoto,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context)!.accurateAnalysisDescription,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Photo Display or Upload Area
              Expanded(
                child: _selectedImage == null
                    ? _buildUploadArea()
                    : _buildPhotoPreview(),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              if (_selectedImage == null) ...[
                AppButton(
                  text: AppLocalizations.of(context)!.takeWithCamera,
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: Icons.camera_alt,
                  isFullWidth: true,
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: AppLocalizations.of(context)!.selectFromGallery,
                  onPressed: () => _pickImage(ImageSource.gallery),
                  type: AppButtonType.outline,
                  icon: Icons.photo_library_outlined,
                  isFullWidth: true,
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: AppLocalizations.of(context)!.retakePhoto,
                        onPressed: _retakePhoto,
                        type: AppButtonType.outline,
                        icon: Icons.refresh,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        text: AppLocalizations.of(context)!.startAnalysis,
                        onPressed: _analyzePhoto,
                        icon: Icons.analytics_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadArea() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        border: Border.all(
          color: AppTheme.borderColor,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 64,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.uploadOrTakePhoto,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.supportedFormats,
            style: const TextStyle(fontSize: 14, color: AppTheme.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPreview() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(_selectedImage!, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
