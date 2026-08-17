import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/visit_repository.dart';
import '../../domain/entities/visit_models.dart';

/// Parameters for querying visit lists.
class VisitListQuery {
  final DateTime? date;
  final String? statusFilter;

  const VisitListQuery({this.date, this.statusFilter});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitListQuery &&
          other.date == date &&
          other.statusFilter == statusFilter;

  @override
  int get hashCode => Object.hash(date, statusFilter);
}

/// Granular provider for fetching the caregiver's scheduled visit list.
final visitListProvider = FutureProvider.family<List<Visit>, VisitListQuery>(
  (ref, query) async {
    final repository = ref.watch(visitRepositoryProvider);
    final result = await repository.getVisitList(
      date: query.date,
      statusFilter: query.statusFilter,
    );

    return result.when(
      success: (visits) => visits,
      failure: (failure) => throw failure,
    );
  },
);

/// Granular provider for fetching visit details by ID.
final visitDetailProvider = FutureProvider.family<Visit, String>(
  (ref, visitId) async {
    final repository = ref.watch(visitRepositoryProvider);
    final result = await repository.getVisitDetail(visitId);

    return result.when(
      success: (visit) => visit,
      failure: (failure) => throw failure,
    );
  },
);

/// Granular provider for navigation data to a patient's address.
final navigationInfoProvider = FutureProvider.family<NavigationInfo, String>(
  (ref, visitId) async {
    final repository = ref.watch(visitRepositoryProvider);
    final result = await repository.getNavigation(visitId);

    return result.when(
      success: (navInfo) => navInfo,
      failure: (failure) => throw failure,
    );
  },
);
