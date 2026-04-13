import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../bloc/unit_of_measure_bloc.dart';
import '../bloc/unit_of_measure_event.dart';
import '../bloc/unit_of_measure_state.dart';

/// Form screen for creating a new Unit of Measure.
///
/// BLoC flow on this screen:
///
///   User taps "Create"
///       │
///       ▼
///   [CreateUnitOfMeasureEvent] added to [UnitOfMeasureBloc]
///       │
///       ▼
///   BLoC emits [UnitOfMeasureLoading]  →  button shows spinner
///       │
///       ├─ success ──▶  [UnitOfMeasureCreateSuccess]
///       │                  └─ BlocListener shows SnackBar, pops back (result: true)
///       │
///       └─ failure ──▶  [UnitOfMeasureError]
///                          └─ BlocListener shows error SnackBar
///
/// This screen does NOT own the BLoC — it is provided by the parent
/// [UnitsOfMeasureScreen] via [BlocProvider.value] so the same BLoC
/// instance handles the event.
class CreateUnitScreen extends StatefulWidget {
  const CreateUnitScreen({super.key});

  @override
  State<CreateUnitScreen> createState() => _CreateUnitScreenState();
}

class _CreateUnitScreenState extends State<CreateUnitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<UnitOfMeasureBloc>().add(
          CreateUnitOfMeasureEvent(
            code: _codeController.text,
            name: _nameController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UnitOfMeasureBloc, UnitOfMeasureState>(
      // ── listener: side-effects (navigation, snackbars) ──────────────────
      listener: (context, state) {
        if (state is UnitOfMeasureCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unit of Measure created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Return `true` so the list screen knows to refresh.
          Navigator.of(context).pop(true);
        }

        if (state is UnitOfMeasureError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      // ── builder: UI that reflects the current state ──────────────────────
      builder: (context, state) {
        final isLoading = state is UnitOfMeasureLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text('New Unit of Measure'),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Section header ──────────────────────────────────────
                  Text(
                    'Unit details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'The code is stored in uppercase and must be unique.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),

                  // ── Code field ──────────────────────────────────────────
                  AppTextField(
                    controller: _codeController,
                    label: 'Code',
                    hint: 'e.g. KG, L, EACH',
                    prefixIcon: Icons.tag,
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Code is required';
                      }
                      if (value.trim().length > 10) {
                        return 'Code must be 10 characters or fewer';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Name field ──────────────────────────────────────────
                  AppTextField(
                    controller: _nameController,
                    label: 'Name',
                    hint: 'e.g. Kilogram, Litre, Each',
                    prefixIcon: Icons.label_outline,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // ── Submit button ───────────────────────────────────────
                  AppButton(
                    label: 'Create Unit',
                    icon: Icons.add_circle_outline,
                    isLoading: isLoading,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 12),

                  // ── Cancel button ───────────────────────────────────────
                  AppButton(
                    label: 'Cancel',
                    variant: AppButtonVariant.outline,
                    onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
