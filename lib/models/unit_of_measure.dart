import 'package:cloud_firestore/cloud_firestore.dart';

class UnitOfMeasure {
  final String id;
  final String code;
  final String name;
  final bool isActive;

  const UnitOfMeasure({
    required this.id,
    required this.code,
    required this.name,
    required this.isActive,
  });

  factory UnitOfMeasure.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return UnitOfMeasure(
      id: snapshot.id,
      code: data['code'] as String,
      name: data['name'] as String,
      isActive: data['isActive'] as bool,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'name': name,
      'isActive': isActive,
    };
  }

  UnitOfMeasure copyWith({
    String? id,
    String? code,
    String? name,
    bool? isActive,
  }) {
    return UnitOfMeasure(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitOfMeasure &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'UnitOfMeasure(id: $id, code: $code, name: $name, isActive: $isActive)';
}
