import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import '../professional/presentation/bloc/professional_bloc.dart';
import '../professional/presentation/widgets/request_card.dart';
import '../../core/widgets/loading_indicator.dart';

class PendingRequestsScreen extends StatefulWidget {
  const PendingRequestsScreen({super.key});

  @override
  State<PendingRequestsScreen> createState() => _PendingRequestsScreenState();
}

class _PendingRequestsScreenState extends State<PendingRequestsScreen> {
  Position? _currentPosition;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _loadLocationAndRequests();
  }

  Future<void> _loadLocationAndRequests() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services disabled');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      if (mounted) {
        context.read<ProfessionalBloc>().add(
              LoadPendingRequestsEvent(
                lat: position.latitude,
                lng: position.longitude,
              ),
            );
      }
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ProfessionalBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pending Requests'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadLocationAndRequests,
            ),
          ],
        ),
        body: BlocConsumer<ProfessionalBloc, ProfessionalState>(
          listener: (context, state) {
            if (state is ProfessionalFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is ProfessionalActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              _loadLocationAndRequests();
            }
          },
          builder: (context, state) {
            if (_isLoadingLocation || state is ProfessionalLoading) {
              return const LoadingIndicator(message: 'Finding nearby requests...');
            } else if (state is PendingRequestsLoaded) {
              if (state.requests.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No pending requests nearby'),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.requests.length,
                itemBuilder: (context, index) {
                  final request = state.requests[index];
                  return RequestCard(
                    request: request,
                    onAccept: () {
                      context.read<ProfessionalBloc>().add(
                            AcceptRequestEvent(request['id'] as String),
                          );
                    },
                  );
                },
              );
            }
            return const Center(child: Text('Enable location to see nearby requests'));
          },
        ),
      ),
    );
  }
}
