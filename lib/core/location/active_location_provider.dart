import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// Provider exposing the raw position stream from Geolocator or mock override.
///
/// Throttled at source level (e.g. via distanceFilter or periodic sampling)
/// per Section 9.2.2.
final locationStreamProvider = Provider<Stream<Position>>((ref) {
  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Minimum 10 meters change to emit new position
  );
  return Geolocator.getPositionStream(locationSettings: locationSettings);
});

/// Single [StreamProvider.autoDispose] exposing the active caregiver location.
///
/// **Caregiver Rule (Section 9.2 & 9.3)**:
/// - Throttled at the source to prevent excessive platform channel calls & battery drain.
/// - Lifecycle-managed: Auto-disposes when no UI screens watch it, and [ref.onDispose] cancels subscription.
/// - Returns standard [AsyncValue<Position>] handling loading/data/error states natively.
final activeLocationProvider = StreamProvider.autoDispose<Position>((ref) {
  final stream = ref.watch(locationStreamProvider);
  final controller = StreamController<Position>();

  final subscription = stream.listen(
    (position) {
      if (!controller.isClosed) {
        controller.add(position);
      }
    },
    onError: (Object error, StackTrace stackTrace) {
      if (!controller.isClosed) {
        controller.addError(error, stackTrace);
      }
    },
    onDone: () {
      if (!controller.isClosed) {
        controller.close();
      }
    },
  );

  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
});
