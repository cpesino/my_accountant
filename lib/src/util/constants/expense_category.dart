// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';



class ExpenseCategory {
  int id;
  IconData? icon;
  String category;

  ExpenseCategory({
    required this.id,
    required this.category,
  }) {
    icon = icons[id + 1];
  }

  static const List<IconData> icons = [
    Icons.house,
    Icons.fastfood,
    Icons.local_taxi,
    Icons.shopping_cart,
    Icons.account_balance,
    Icons.savings,
    Icons.sports_esports,
    Icons.school,
    Icons.card_giftcard,
    Icons.receipt,
    Icons.shield,
    Icons.electrical_services,
    Icons.category,
  ]; 
}
