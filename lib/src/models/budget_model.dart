// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';

class BudgetModel {
  int id;
  String name;
  Decimal amount;
  Decimal spent;
  DateTime startDate;
  DateTime endDate;
  String period;

  BudgetModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.spent,
    required this.startDate,
    required this.endDate,
    required this.period,
  });

  BudgetModel copyWith({
    int? id,
    String? name,
    Decimal? amount,
    Decimal? spent,
    DateTime? startDate,
    DateTime? endDate,
    String? period,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      period: period ?? this.period,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'amount': amount,
      'spent': spent,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'period': period,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as int,
      name: map['name'] as String,
      amount: Decimal.parse(map['amount'].toString()),
      spent: Decimal.parse(map['spent'].toString()),
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      period: map['period'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetModel.fromJson(String source) =>
      BudgetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BudgetModel(id: $id, name: $name, amount: $amount, spent: $spent, startDate: $startDate, endDate: $endDate, period: $period)';
  }

  @override
  bool operator ==(covariant BudgetModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.amount == amount &&
        other.spent == spent &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.period == period;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        amount.hashCode ^
        spent.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        period.hashCode;
  }
}
