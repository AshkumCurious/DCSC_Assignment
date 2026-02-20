import 'package:demo/controllers/shipment_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Details extends StatelessWidget {
  const Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shipment Details")),
      backgroundColor: Colors.white,
      body: Consumer<ShipmentProvider>(
        builder: (context, ctrl, child) {
          final shipment = ctrl.currentShipment;
          if (shipment == null) {
            return const Center(child: Text("No shipment selected."));
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(shipment.trackingId,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _statusColor(shipment.status),
                      ),
                      child: Text(shipment.status, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _infoRow("Customer", shipment.customerName),
                _infoRow("Phone", shipment.customerPhone),
                _infoRow("Pickup Address", shipment.pickupAddress),
                _infoRow("Delivery Address", shipment.deliveryAddress),
                if (shipment.createdAt != null)
                  _infoRow("Created At", formatDateTime(shipment.createdAt!)),
                if (shipment.updatedAt != null)
                  _infoRow("Last Updated", formatDateTime(shipment.updatedAt!)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "In Transit":
        return Colors.blue;
      case "Out for Delivery":
        return Colors.orange;
      case "Delivered":
        return Colors.green;
      default:
        return Colors.red; // Pending
    }
  }

  String formatDateTime(String date) {
    final dt = DateTime.parse(date);
    return "${dt.day}/${dt.month}/${dt.year}";
  }
}