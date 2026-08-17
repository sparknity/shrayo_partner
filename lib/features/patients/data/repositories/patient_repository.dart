import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/result.dart';
import '../../domain/entities/patient_models.dart';

abstract class PatientRepository {
  Future<Result<List<PatientSummary>>> getPatientDirectory({String? searchQuery});
  Future<Result<PatientOverview>> getPatientOverview(String patientId);
  Future<Result<MedicalProfile>> getMedicalProfile(String patientId);
  Future<Result<List<PatientDocument>>> getDocuments(String patientId);
  Future<Result<Uint8List>> downloadDocument(String documentId);
}

class PatientRepositoryImpl implements PatientRepository {
  final ApiClient _apiClient;

  PatientRepositoryImpl(this._apiClient);

  @override
  Future<Result<List<PatientSummary>>> getPatientDirectory({String? searchQuery}) async {
    final queryParams = <String, dynamic>{};
    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParams['q'] = searchQuery;
    }

    return await _apiClient.get(
      '/api/v1/patients',
      queryParameters: queryParams,
      decoder: (json) {
        if (json is List) {
          return json.map((e) => PatientSummary.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <PatientSummary>[];
      },
    );
  }

  @override
  Future<Result<PatientOverview>> getPatientOverview(String patientId) async {
    return await _apiClient.get(
      '/api/v1/patients/$patientId/overview',
      decoder: (json) => PatientOverview.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<MedicalProfile>> getMedicalProfile(String patientId) async {
    return await _apiClient.get(
      '/api/v1/patients/$patientId/medical-profile',
      decoder: (json) => MedicalProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<List<PatientDocument>>> getDocuments(String patientId) async {
    return await _apiClient.get(
      '/api/v1/patients/$patientId/documents',
      decoder: (json) {
        if (json is List) {
          return json.map((e) => PatientDocument.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <PatientDocument>[];
      },
    );
  }

  @override
  Future<Result<Uint8List>> downloadDocument(String documentId) async {
    return await _apiClient.get(
      '/api/v1/documents/$documentId/download',
      decoder: (json) {
        if (json is List<int>) {
          return Uint8List.fromList(json);
        }
        return Uint8List(0);
      },
    );
  }
}

final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PatientRepositoryImpl(apiClient);
});
