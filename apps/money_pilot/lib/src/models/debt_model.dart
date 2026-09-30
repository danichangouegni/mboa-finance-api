class DebtModel {

  final String id;

  final String personName;

  final String description;

  final int amount;

  final bool isReceivable;

  final DateTime dueDate;

  DebtModel({

    required this.id,

    required this.personName,

    required this.description,

    required this.amount,

    required this.isReceivable,

    required this.dueDate,

  });

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'personName': personName,

      'description': description,

      'amount': amount,

      'isReceivable': isReceivable,

      'dueDate':
          dueDate.toIso8601String(),

    };

  }

  factory DebtModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return DebtModel(

      id: json['id'] ?? '',

      personName:
          json['personName'] ?? '',

      description:
          json['description'] ?? '',

      amount:
          json['amount'] ?? 0,

      isReceivable:
          json['isReceivable'] ?? true,

      dueDate:
          json['dueDate'] != null

              ? DateTime.parse(
                  json['dueDate'],
                )

              : DateTime.now(),

    );

  }

}
