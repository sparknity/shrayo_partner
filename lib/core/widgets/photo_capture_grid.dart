import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Photo capture and thumbnail display grid for visit/wound documentation (Section 5.2).
class PhotoCaptureGrid extends StatelessWidget {
  const PhotoCaptureGrid({
    super.key,
    required this.imagePaths,
    required this.onImagesChanged,
    this.title = 'Documentation Photos',
    this.maxImages = 5,
    this.readOnly = false,
  });

  final List<String> imagePaths;
  final ValueChanged<List<String>> onImagesChanged;
  final String title;
  final int maxImages;
  final bool readOnly;

  Future<void> _pickImage(ImageSource source) async {
    if (imagePaths.length >= maxImages) return;

    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1920,
    );

    if (image != null) {
      final updatedList = List<String>.from(imagePaths)..add(image.path);
      onImagesChanged(updatedList);
    }
  }

  void _removeImage(int index) {
    final updatedList = List<String>.from(imagePaths)..removeAt(index);
    onImagesChanged(updatedList);
  }

  void _showSourceSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusCard)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primaryBlue),
                title: const Text('Take Photo with Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.primaryBlue),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canAddMore = !readOnly && imagePaths.length < maxImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '${imagePaths.length} / $maxImages',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppSpacing.s,
            mainAxisSpacing: AppSpacing.s,
            childAspectRatio: 1.0,
          ),
          itemCount: imagePaths.length + (canAddMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == imagePaths.length && canAddMore) {
              return InkWell(
                onTap: () => _showSourceSelector(context),
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
                    border: Border.all(color: AppColors.borderDivider, style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_a_photo_outlined, color: AppColors.primaryBlue, size: 28),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Add Photo',
                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryBlue),
                      ),
                    ],
                  ),
                ),
              );
            }

            final path = imagePaths[index];
            final file = File(path);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (!readOnly)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: AppColors.white, size: 14),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
