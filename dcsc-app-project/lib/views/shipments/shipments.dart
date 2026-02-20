import 'package:demo/models/shipment_model.dart';
import 'package:demo/views/shipments/details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/shipment_controller.dart';
import 'shipmet_card.dart';

class Shipments extends StatefulWidget {
  const Shipments({super.key});

  @override
  State<Shipments> createState() => _ShipmentsState();
}

class _ShipmentsState extends State<Shipments> {
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch from API on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShipmentProvider>().fetchAllShipments("");
    });
  }

  void _showStatusDialog(BuildContext context, ShipmentProvider provider, int index) {
    final shipment = provider.shipments[index];
    final statuses = ["In Transit", "Out for Delivery", "Delivered"];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.sizeOf(context).height*0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Update Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ...statuses.map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: shipment.status == s
                          ? null // disable current status
                          : () async {
                              Navigator.pop(dialogContext);
                              try {
                                await provider.updateStatus(shipment.trackingId, s);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Status updated to '$s'")),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Failed to update status")),
                                );
                              }
                            },
                      child: Text(s),
                    ),
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<ShipmentProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  TextField(
                    controller: searchCtrl,
                    decoration: const InputDecoration(
                      hintText: "Search by tracking ID or name",
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // local filter — no extra API call needed
                      provider.searchShipments(value);
                    },
                  ),
                  const SizedBox(height: 10),

                  // Loading / error / list states
                  if (provider.isLoading)
                    const Expanded(child: Center(child: CircularProgressIndicator()))
                  else if (provider.errorMessage != null)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(provider.errorMessage!, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () => provider.fetchAllShipments(""),
                              child: const Text("Retry"),
                            )
                          ],
                        ),
                      ),
                    )
                  else if (provider.shipments.isEmpty)
                    const Expanded(child: Center(child: Text("No shipments found.")))
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: provider.shipments.length,
                        itemBuilder: (context, index) {
                          ShipmentModel shipment = provider.shipments[index];
                          return ShipmentCard(
                            trackingId: shipment.trackingId,
                            status: shipment.status,
                            custName: shipment.customerName,
                            address: shipment.deliveryAddress,
                            onPressed: () {
                              provider.setCurrentShipment(index);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const Details()));
                            },
                            onStatusUpdate: () => _showStatusDialog(context, provider, index),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}