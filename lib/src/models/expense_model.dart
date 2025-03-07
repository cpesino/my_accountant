// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
class ExpenseModel {
  int id;
  String description;
  Decimal amount;
  DateTime createdDate;
  ExpenseModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.createdDate,
  });

  ExpenseModel copyWith({
    int? id,
    String? description,
    Decimal? amount,
    DateTime? createdDate,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'amount': amount,
      'createdDate': createdDate.millisecondsSinceEpoch,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as int,
      description: map['description'] as String,
      amount: map['amount'] as Decimal,
      createdDate: DateTime.parse(map['createdDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromJson(String source) =>
      ExpenseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExpenseModel(id: $id, description: $description, amount: $amount, createdDate: $createdDate)';
  }

  @override
  bool operator ==(covariant ExpenseModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.description == description &&
        other.amount == amount &&
        other.createdDate == createdDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        amount.hashCode ^
        createdDate.hashCode;
  }
}
