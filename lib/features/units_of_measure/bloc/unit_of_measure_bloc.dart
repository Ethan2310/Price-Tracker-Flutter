import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/unit_of_measure.dart';
import '../data/unit_of_measure_repository.dart';
import 'unit_of_measure_event.dart';
import 'unit_of_measure_state.dart';

/// Orchestrates all business logic for Unit of Measure operations.
///
/// How it works:
///   1. The UI adds an [UnitOfMeasureEvent] (e.g. [CreateUnitOfMeasureEvent]).
///   2. The BLoC calls the [UnitOfMeasureRepository] (data layer).
///   3. It emits [UnitOfMeasureState] subclasses that the UI reacts to.
///
/// The UI never calls Firestore directly — all data access is here.
class UnitOfMeasureBloc
    extends Bloc<UnitOfMeasureEvent, UnitOfMeasureState> {
  final UnitOfMeasureRepository _repository;

  UnitOfMeasureBloc({required UnitOfMeasureRepository repository})
      : _repository = repository,
        super(const UnitOfMeasureInitial()) {
    on<CreateUnitOfMeasureEvent>(_onCreateUnitOfMeasure);
  }

  /// Handles [CreateUnitOfMeasureEvent]:
  ///   - emits [UnitOfMeasureLoading] immediately (shows spinner in UI)
  ///   - calls the repository to persist the new unit
  ///   - emits [UnitOfMeasureCreateSuccess] or [UnitOfMeasureError]
  Future<void> _onCreateUnitOfMeasure(
    CreateUnitOfMeasureEvent event,
    Emitter<UnitOfMeasureState> emit,
  ) async {
    emit(const UnitOfMeasureLoading());

    try {
      final unit = UnitOfMeasure(
        id: '',           // Firestore generates this on add()
        code: event.code.trim().toUpperCase(),
        name: event.name.trim(),
        isActive: true,   // New units are active by default
      );

      final newId = await _repository.create(unit);

      emit(UnitOfMeasureCreateSuccess(id: newId));
    } catch (e) {
      emit(UnitOfMeasureError(e.toString()));
    }
  }
}
