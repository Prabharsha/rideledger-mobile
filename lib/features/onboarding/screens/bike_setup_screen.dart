import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/onboarding_provider.dart';

/// Bike setup screen (Step 1 of onboarding)
class BikeSetupScreen extends ConsumerStatefulWidget {
  const BikeSetupScreen({super.key});

  @override
  ConsumerState<BikeSetupScreen> createState() => _BikeSetupScreenState();
}

class _BikeSetupScreenState extends ConsumerState<BikeSetupScreen> {
  late TextEditingController _modelController;
  late TextEditingController _rebuildOdometerController;
  DateTime? _rebuildDate;

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController(text: 'Yamaha TW200 2017');
    _rebuildOdometerController = TextEditingController(text: '0');
    _rebuildDate = DateTime.now();
  }

  @override
  void dispose() {
    _modelController.dispose();
    _rebuildOdometerController.dispose();
    super.dispose();
  }

  void _onContinue() {
    // Validate inputs
    if (_modelController.text.isEmpty ||
        _rebuildOdometerController.text.isEmpty ||
        _rebuildDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Parse odometer as double
    final odometerKm = double.tryParse(_rebuildOdometerController.text) ?? 0;

    // Update onboarding state
    ref.read(onboardingStateProvider.notifier).setBikeSetup(
          bikeModel: _modelController.text,
          rebuildDate: _rebuildDate!,
          rebuildStartOdometerKm: odometerKm,
        );

    // Navigate to next step
    // TODO: Navigate to break in profile screen
    // context.go('/onboarding/break-in-profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bikeSetupTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bike Model
            Text(
              'Bike Model',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _modelController,
              decoration: InputDecoration(
                hintText: 'e.g., Yamaha TW200 2017',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Rebuild Date
            Text(
              'Engine Rebuild Date',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _rebuildDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    _rebuildDate = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_rebuildDate?.toString().split(' ')[0] ?? 'Select date'),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Odometer at Rebuild
            Text(
              'Odometer Reading at Rebuild (km)',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rebuildOdometerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'e.g., 12345',
                suffixText: 'km',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onContinue,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(AppStrings.continueButton),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
