class UpdateBudgetRequestModel {
  final double amount;
  final int categoryId;
  final int year;
  final int month;

  const UpdateBudgetRequestModel({
    required this.amount,
    required this.categoryId,
    required this.year,
    required this.month,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'categoryId': categoryId,
      'year': year,
      'month': month,
    };
  }
}