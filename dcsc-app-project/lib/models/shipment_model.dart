class ShipmentModel {
  final int id;
  final String trackingId;
  final String customerName;
  final String deliveryAddress;
  final String pickupAddress;
  final String customerPhone;
  String status;
  final String? createdAt;
  final String? updatedAt;

  ShipmentModel({
    required this.id,
    required this.trackingId,
    required this.customerName,
    required this.deliveryAddress,
    required this.pickupAddress,
    required this.customerPhone,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      id: json['id'],
      trackingId: json['tracking_id'],
      customerName: json['customer_name'],
      deliveryAddress: json['delivery_address'],
      pickupAddress: json['pickup_address'],
      customerPhone: json['customer_phone'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}