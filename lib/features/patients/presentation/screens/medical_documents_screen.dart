import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/document_tile.dart';
import '../../data/fixtures/patient_fixtures.dart';

/// Medical Documents screen matching `Medical Documents.png`.
class MedicalDocumentsScreen extends StatelessWidget {
  const MedicalDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final docs = PatientFixtures.medicalDocuments;

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.m),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        return DocumentTile(
          fileName: doc['title'],
          fileSize: doc['size'],
          uploadDate: doc['date'],
          fileExtension: doc['fileType'],
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening ${doc['title']}...')),
            );
          },
        );
      },
    );
  }
}
