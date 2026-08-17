import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/patient_repository.dart';
import '../../domain/entities/patient_models.dart';

/// Granular provider for searching patient directory (Section 9.0.1).
final patientDirectoryProvider =
    FutureProvider.family<List<PatientSummary>, String?>(
  (ref, searchQuery) async {
    final repository = ref.watch(patientRepositoryProvider);
    final result = await repository.getPatientDirectory(searchQuery: searchQuery);
    return result.when(
      success: (directory) => directory,
      failure: (failure) => throw failure,
    );
  },
);

/// Granular provider for patient overview dashboard data.
final patientOverviewProvider =
    FutureProvider.family<PatientOverview, String>(
  (ref, patientId) async {
    final repository = ref.watch(patientRepositoryProvider);
    final result = await repository.getPatientOverview(patientId);
    return result.when(
      success: (overview) => overview,
      failure: (failure) => throw failure,
    );
  },
);

/// Granular provider for patient medical profile.
final medicalProfileProvider =
    FutureProvider.family<MedicalProfile, String>(
  (ref, patientId) async {
    final repository = ref.watch(patientRepositoryProvider);
    final result = await repository.getMedicalProfile(patientId);
    return result.when(
      success: (profile) => profile,
      failure: (failure) => throw failure,
    );
  },
);

/// Granular provider for patient attached medical documents.
final patientDocumentsProvider =
    FutureProvider.family<List<PatientDocument>, String>(
  (ref, patientId) async {
    final repository = ref.watch(patientRepositoryProvider);
    final result = await repository.getDocuments(patientId);
    return result.when(
      success: (docs) => docs,
      failure: (failure) => throw failure,
    );
  },
);

/// Granular provider for downloading patient document bytes.
final downloadDocumentProvider =
    FutureProvider.family<Uint8List, String>(
  (ref, documentId) async {
    final repository = ref.watch(patientRepositoryProvider);
    final result = await repository.downloadDocument(documentId);
    return result.when(
      success: (bytes) => bytes,
      failure: (failure) => throw failure,
    );
  },
);
