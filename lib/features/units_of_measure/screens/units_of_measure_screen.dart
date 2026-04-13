import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/unit_of_measure.dart';
import '../bloc/unit_of_measure_bloc.dart';
import '../data/unit_of_measure_repository.dart';
import 'create_unit_screen.dart';

/// Entry-point screen for the Units of Measure feature.
///
/// Uses a [StreamBuilder] wired to [UnitOfMeasureRepository.watchAll] so the
/// list automatically reflects changes made on *any* device in real time —
/// no pull-to-refresh or manual reload needed.
///
/// Write operations (create / edit / delete) are still routed through the
/// [UnitOfMeasureBloc] to keep all mutation logic in one place.
class UnitsOfMeasureScreen extends StatelessWidget {
  const UnitsOfMeasureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The repository is created once and shared with the BLoC.
    final repository = UnitOfMeasureRepository();

    return BlocProvider(
      create: (_) => UnitOfMeasureBloc(repository: repository),
      child: _UnitsOfMeasureView(repository: repository),
    );
  }
}

class _UnitsOfMeasureView extends StatelessWidget {
  const _UnitsOfMeasureView({required this.repository});

  final UnitOfMeasureRepository repository;

  void _navigateToCreate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<UnitOfMeasureBloc>(),
          child: const CreateUnitScreen(),
        ),
      ),
    );
    // No need to handle the return value — the stream automatically
    // pushes the updated list the moment Firestore confirms the write.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Units of Measure'),
        centerTitle: false,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreate(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Unit'),
      ),
      // ── StreamBuilder ────────────────────────────────────────────────────
      // Firestore's snapshots() keeps a persistent WebSocket open and pushes
      // a new QuerySnapshot every time any document in the collection changes
      // on any device. StreamBuilder rebuilds the widget tree whenever a new
      // snapshot arrives, giving us live multi-device sync for free.
      body: StreamBuilder<List<UnitOfMeasure>>(
        stream: repository.watchAll(),
        builder: (context, snapshot) {
          // While the first snapshot is on its way, show a spinner.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SelectableText(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final units = snapshot.data ?? [];

          if (units.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.straighten_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No units yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap  +  Add Unit  to create the first one.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: units.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final unit = units[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    unit.code.length > 3
                        ? unit.code.substring(0, 3)
                        : unit.code,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                title: Text(unit.name),
                subtitle: Text('Code: ${unit.code}  •  ID: ${unit.id}'),
                trailing: Icon(
                  unit.isActive ? Icons.check_circle : Icons.cancel,
                  color: unit.isActive ? Colors.green : Colors.red,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
