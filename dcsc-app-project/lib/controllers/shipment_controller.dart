import 'package:demo/models/shipment_model.dart';
import 'package:demo/services/api_service.dart';
import 'package:flutter/material.dart';

class ShipmentProvider extends ChangeNotifier {
  List<ShipmentModel> _shipments = [];
  List<ShipmentModel> get shipments => _shipments;

  List<ShipmentModel> _allShipments = []; // holds full list for local search

  ShipmentModel? _currentShipment;
  ShipmentModel? get currentShipment => _currentShipment;

  bool isLoading = false;
  String? errorMessage;

  void setCurrentShipment(int index) {
    _currentShipment = _shipments[index];
    notifyListeners();
  }

  Future<void> fetchAllShipments(String searchText) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _allShipments = await ApiService.fetchShipments();
      _filterShipments(searchText);
    } catch (e) {
      errorMessage = "Failed to load shipments. Is the server running?";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _filterShipments(String searchText) {
    final search = searchText.toLowerCase();
    if (search.isEmpty) {
      _shipments = List.from(_allShipments);
    } else {
      _shipments = _allShipments.where((s) {
        return s.trackingId.toLowerCase().contains(search) ||
            s.customerName.toLowerCase().contains(search);
      }).toList();
    }
  }

  void searchShipments(String searchText) {
    _filterShipments(searchText);
    notifyListeners();
  }

 Future<void> updateStatus(String trackingId, String status) async {
  try {
    await ApiService.updateStatus(trackingId, status); // no return value needed

    // apply status locally on success
    final shipmentIndex = _shipments.indexWhere((s) => s.trackingId == trackingId);
    if (shipmentIndex != -1) _shipments[shipmentIndex].status = status;

    final allIndex = _allShipments.indexWhere((s) => s.trackingId == trackingId);
    if (allIndex != -1) _allShipments[allIndex].status = status;

    if (_currentShipment?.trackingId == trackingId) {
      _currentShipment!.status = status;
    }

    notifyListeners();
  } catch (e) {
    throw Exception("Failed to update status: $e");
  }
}
}