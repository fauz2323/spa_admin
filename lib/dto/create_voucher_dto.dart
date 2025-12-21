class CreateVoucherDto {
  final int? id;
  final String name;
  final String price;
  final double discountAmount;
  final DateTime expiryDate;

  CreateVoucherDto({
    this.id,
    required this.name,
    required this.price,
    required this.discountAmount,
    required this.expiryDate,
  });
}
