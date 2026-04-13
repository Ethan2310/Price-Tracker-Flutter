import 'package:equatable/equatable.dart';

/// Base class for every event the [UnitOfMeasureBloc] can receive.
///
/// Events represent *intentions* — things the user or system wants to do.
/// Each concrete subclass carries exactly the data that action needs.
abstract class UnitOfMeasureEvent extends Equatable {
  const UnitOfMeasureEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the user submits the "Create Unit of Measure" form.
class CreateUnitOfMeasureEvent extends UnitOfMeasureEvent {
  final String code;
  final String name;

  const CreateUnitOfMeasureEvent({
    required this.code,
    required this.name,
  });

  @override
  List<Object?> get props => [code, name];
}
