import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/visit_workflow/domain/visit_workflow_stage.dart';
import '../../features/visit_workflow/presentation/providers/active_visit_provider.dart';

/// Shows confirmation dialog when a caregiver attempts to abandon an active visit flow.
Future<bool> showVisitLeaveConfirmationDialog(BuildContext context) async {
  final bool? leave = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Visit in Progress'),
        content: const Text(
          'A visit workflow is currently active. Are you sure you want to leave anyway? Unsaved changes may be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Leave Anyway'),
          ),
        ],
      );
    },
  );
  return leave ?? false;
}

/// Scaffold wrapper that guards visit workflow back presses with [PopScope].
class VisitLockScope extends ConsumerWidget {
  final Widget child;

  const VisitLockScope({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitState = ref.watch(activeVisitProvider);

    return PopScope(
      canPop: !visitState.isVisitInProgress,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        // Step backward through visit workflow stages if checked in
        if (visitState.stage == VisitWorkflowStage.submission) {
          ref.read(activeVisitProvider.notifier).updateStage(VisitWorkflowStage.assessment);
        } else if (visitState.stage == VisitWorkflowStage.assessment) {
          ref.read(activeVisitProvider.notifier).updateStage(VisitWorkflowStage.checkedIn);
        } else {
          final shouldLeave = await showVisitLeaveConfirmationDialog(context);
          if (shouldLeave && context.mounted) {
            ref.read(activeVisitProvider.notifier).updateStage(VisitWorkflowStage.notStarted);
            Navigator.of(context).pop();
          }
        }
      },
      child: child,
    );
  }
}
