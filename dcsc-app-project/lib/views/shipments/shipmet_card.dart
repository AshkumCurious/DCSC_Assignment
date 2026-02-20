import 'package:flutter/material.dart';

class ShipmentCard extends StatelessWidget {
  const ShipmentCard({
    super.key,
    required this.trackingId,
    required this.status,
    required this.custName,
    required this.address,
    required this.onPressed,
    required this.onStatusUpdate,
  });

  final String trackingId;
  final String status;
  final String custName;
  final String address;
  final void Function()? onPressed;
  final void Function()? onStatusUpdate;

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              offset: const Offset(2, 5),
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  trackingId,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _statusColor(status),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(custName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(address, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Disable Update button if already Delivered
                if (status != "Delivered")
                  ElevatedButton(
                    onPressed: onStatusUpdate,
                    child: const Text("Update"),
                  ),
                if (status != "Delivered") const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: onPressed,
                  child: const Text("Details"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}