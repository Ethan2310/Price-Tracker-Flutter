import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/unit_of_measure.dart';

/// Data-layer access for the `units_of_measure` Firestore collection.
///
/// All Firestore calls are isolated here so the BLoC never touches the
/// database directly — making the business logic easy to test or swap out.
class UnitOfMeasureRepository {
  UnitOfMeasureRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<UnitOfMeasure> get _collection =>
      _firestore.collection('units_of_measure').withConverter(
            fromFirestore: UnitOfMeasure.fromFirestore,
            toFirestore: (unit, _) => unit.toFirestore(),
          );

  /// Adds a new document and returns the auto-generated [UnitOfMeasure.id].
  Future<String> create(UnitOfMeasure unit) async {
    final ref = await _collection.add(unit);
    return ref.id;
  }

  /// Fetches all units of measure ordered by name (one-shot read).
  Future<List<UnitOfMeasure>> getAll() async {
    final snapshot = await _collection.orderBy('name').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Returns a live stream of all units of measure ordered by name.
  ///
  /// Firestore pushes a new event whenever any document in the collection
  /// is created, updated, or deleted — on *any* device. This is what
  /// enables real-time sync across multiple users / devices without any
  /// extra polling or manual refresh logic.
  Stream<List<UnitOfMeasure>> watchAll() {
    return _collection
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
