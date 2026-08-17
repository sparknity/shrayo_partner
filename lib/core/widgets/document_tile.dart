import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Document sync status.
enum DocumentSyncStatus {
  synced,
  pending,
  error,
}

/// Document tile row widget for `workspace/documents` (Section 5.2).
class DocumentTile extends StatelessWidget {
  const DocumentTile({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.uploadDate,
    this.syncStatus = DocumentSyncStatus.synced,
    this.fileExtension = 'pdf',
    this.onTap,
    this.onDelete,
  });

  final String fileName;
  final String fileSize;
  final String uploadDate;
  final DocumentSyncStatus syncStatus;
  final String fileExtension;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final fileIcon = switch (fileExtension.toLowerCase()) {
      'pdf' => Icons.picture_as_pdf,
      'jpg' || 'png' || 'jpeg' => Icons.image,
      'doc' || 'docx' => Icons.description,
      _ => Icons.insert_drive_file,
    };

    final (syncText, syncColor, syncIcon) = switch (syncStatus) {
      DocumentSyncStatus.synced => ('Synced', AppColors.healthGreen, Icons.cloud_done),
      DocumentSyncStatus.pending => ('Pending Sync', const Color(0xFFD97706), Icons.cloud_upload),
      DocumentSyncStatus.error => ('Sync Failed', AppColors.emergencyRed, Icons.cloud_off),
    };

    return Card(
      elevation: 0,
      color: AppColors.surfaceBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
        side: const BorderSide(color: AppColors.borderDivider),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s + 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueLight.withAlpha(40),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
                ),
                child: Icon(fileIcon, color: AppColors.primaryBlue, size: 24),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text('$fileSize • $uploadDate', style: AppTextStyles.caption),
                        const SizedBox(width: AppSpacing.s),
                        Icon(syncIcon, size: 12, color: syncColor),
                        const SizedBox(width: 2),
                        Text(
                          syncText,
                          style: AppTextStyles.caption.copyWith(color: syncColor, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.textSecondary, size: 20),
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
