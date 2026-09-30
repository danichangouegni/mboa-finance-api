class TransactionModel {
  final String id;

  final String title;

  final String description;

  final int amount;

  final bool isExpense;

  final DateTime date;
  final String paymentMethod;

 TransactionModel({
  required this.id,
  required this.title,
  required this.description,
  required this.amount,
  required this.isExpense,
  required this.date,
  required this.paymentMethod,
});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'isExpense': isExpense,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
    };
  }

 factory TransactionModel.fromJson(
  Map<String, dynamic> json,
) {
  return TransactionModel(
    id: json['id'] ?? '',

    title: json['title'] ?? '',

    description:
        json['description'] ?? '',

    amount: json['amount'] ?? 0,

    isExpense:
        json['isExpense'] ?? true,

   date: json['date'] != null
    ? DateTime.parse(
        json['date'],
      )
    : DateTime.now(),

paymentMethod:
    json['paymentMethod'] ??
    'Cash',
  );
}
}