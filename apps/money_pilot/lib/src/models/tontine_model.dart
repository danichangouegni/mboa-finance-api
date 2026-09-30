class TontineModel {

  final String id;

  final String name;

  final int monthlyContribution;

  final int membersCount;

  final int durationMonths;

  final String nextRecipient;

  final DateTime nextRoundDate;

  final int nextRoundAmount;

  final List<String> members;

  TontineModel({

    required this.id,

    required this.name,

    required this.monthlyContribution,

    required this.membersCount,

    required this.durationMonths,

    required this.nextRecipient,

    required this.nextRoundDate,

    required this.nextRoundAmount,

    required this.members,

  });

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'name': name,

      'monthlyContribution':
          monthlyContribution,

      'membersCount':
          membersCount,

      'durationMonths':
          durationMonths,

      'nextRecipient':
          nextRecipient,

      'nextRoundDate':
          nextRoundDate
              .toIso8601String(),

      'nextRoundAmount':
          nextRoundAmount,

      'members': members,

    };

  }

  factory TontineModel.fromJson(
      Map<String, dynamic> json) {

  return TontineModel(

    id: (json['id'] ?? '')
        .toString(),

    name: json['name'] ?? '',

    monthlyContribution:
        int.tryParse(
          json['monthlyContribution']
              .toString(),
        ) ?? 0,

    membersCount:
        int.tryParse(
          json['membersCount']
              .toString(),
        ) ?? 0,

    durationMonths:
        int.tryParse(
          json['durationMonths']
              .toString(),
        ) ?? 0,

    nextRecipient:
        json['nextRecipient'] ?? '',

    nextRoundDate:
        json['nextRoundDate'] != null
            ? DateTime.parse(
                json['nextRoundDate'],
              )
            : DateTime.now(),

    nextRoundAmount:
        int.tryParse(
          json['nextRoundAmount']
              .toString(),
        ) ?? 0,

        members: (() {

        final data = json['members'];

        if (data is List) {
            return data
                .map((e) => e.toString())
                .toList();
        }

        return <String>[];

        })(),
    );

  }

}
