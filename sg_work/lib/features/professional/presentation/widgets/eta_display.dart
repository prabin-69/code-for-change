import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';

class ETADisplay extends StatefulWidget {
  final double customerLat;
  final double customerLng;
  final double professionalLat;
  final double professionalLng;

  const ETADisplay({
    super.key,
    required this.customerLat,
    required this.customerLng,
    required this.professionalLat,
    required this.professionalLng,
  });

  @override
  State<ETADisplay> createState() => _ETADisplayState();
}

class _ETADisplayState extends State<ETADisplay> {
  final ApiClient _apiClient = ApiClient();
  Map<String, dynamic>? _etaData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchETA();
  }

  Future<void> _fetchETA() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.get(
        ApiConstants.eta,
        queryParams: {
          'originLat': widget.professionalLat.toString(),
          'originLng': widget.professionalLng.toString(),
          'destLat': widget.customerLat.toString(),
          'destLng': widget.customerLng.toString(),
        },
      );
      setState(() {
        _etaData = response['data'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Failed to fetch ETA: $e');
    }
  }

  void _openNavigation() async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${widget.customerLat},${widget.customerLng}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estimated Arrival',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_etaData != null) ...[
            Row(
              children: [
                const Icon(Icons.timelapse, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  _etaData!['duration'] ?? 'N/A',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  _etaData!['distance'] ?? 'N/A',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openNavigation,
                icon: const Icon(Icons.directions),
                label: const Text('Open in Google Maps'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ] else ...[
            const Text('Could not calculate ETA'),
            TextButton(
              onPressed: _fetchETA,
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}