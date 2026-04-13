import 'package:equatable/equatable.dart';

/// Base class for every state the [UnitOfMeasureBloc] can emit.
///
/// States represent *facts* about the world right now.
/// The UI rebuilds whenever a new state is emitted.
abstract class UnitOfMeasureState extends Equatable {
  const UnitOfMeasureState();

  @override
  List<Object?> get props => [];
}

/// Nothing has happened yet — the screen just loaded.
class UnitOfMeasureInitial extends UnitOfMeasureState {
  const UnitOfMeasureInitial();
}

/// An async operation is in flight — show a loading indicator.
class UnitOfMeasureLoading extends UnitOfMeasureState {
  const UnitOfMeasureLoading();
}

/// The create operation completed successfully.
/// Carries the Firestore-generated [id] of the new document.
class UnitOfMeasureCreateSuccess extends UnitOfMeasureState {
  final String id;

  const UnitOfMeasureCreateSuccess({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Something went wrong — [message] describes the failure.
class UnitOfMeasureError extends UnitOfMeasureState {
  final String message;

  const UnitOfMeasureError(this.message);

  @override
  List<Object?> get props => [message];
}