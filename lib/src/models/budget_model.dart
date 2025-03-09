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
  int categoryId;

  BudgetModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.spent,
    required this.startDate,
    required this.endDate,
    required this.period,
    required this.categoryId,
  });

  BudgetModel copyWith({
    int? id,
    String? name,
    Decimal? amount,
    Decimal? spent,
    DateTime? startDate,
    DateTime? endDate,
    String? period,
    int? categoryId,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      period: period ?? this.period,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'amount': amount,
      'spent': spent,
      'startDate': startDate,
      'endDate': endDate,
      'period': period,
      'categoryId': categoryId,
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
      categoryId: map['categoryId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetModel.fromJson(String source) =>
      BudgetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BudgetModel(id: $id, name: $name, amount: $amount, spent: $spent, startDate: $startDate, endDate: $endDate, period: $period, categoryId: $categoryId)';
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
        other.period == period &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        amount.hashCode ^
        spent.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        period.hashCode ^
        categoryId.hashCode;
  }
}
