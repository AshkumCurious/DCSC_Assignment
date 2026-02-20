import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:demo/models/shipment_model.dart';

class ApiService {
  // Change this to your machine's IP if running on a physical device
  // e.g. "http://192.168.1.10:8000"
  static const String baseUrl = "http://10.233.158.114:8000";

  // GET /shipments?page=1&page_size=20
  static Future<List<ShipmentModel>> fetchShipments({int page = 1, int pageSize = 20}) async {
    final response = await http.get(
      Uri.parse("$baseUrl/shipments?page=$page&page_size=$pageSize"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List shipments = data['shipments'];
      return shipments.map((s) => ShipmentModel.fromJson(s)).toList();
    } else {
      throw Exception("Failed to fetch shipments");
    }
  }

  // PUT /shipments/{tracking_id}/status
  static Future<void> updateStatus(String trackingId, String status) async {
    final response = await http.put(
      Uri.parse("$baseUrl/shipments/$trackingId/status"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"status": status}),
    );

    if (response.statusCode == 200) {
      return; // don't parse, provider already knows the new status
    } else if (response.statusCode == 404) {
      throw Exception("Shipment not found");
    } else {
      throw Exception("Failed to update status");
    }
  }
}