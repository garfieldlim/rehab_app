import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/injection_container.dart';

class ServiceScreen extends StatelessWidget {
  final List<BluetoothService> services;

  const ServiceScreen({Key? key, required this.services}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BluetoothCharacteristic? ffe2Characteristic;
    // Search for the characteristic with UUID ffe2 across all services.
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toUpperCase() == 'FFE2') {
          ffe2Characteristic = characteristic;
          break; // Stop searching once found
        }
      }
      if (ffe2Characteristic != null) {
        break; // Stop searching through services once found
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Services'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bluetooth_connected,
              size: 100.0,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 20), // Adds space between the icon and the button
            ffe2Characteristic != null
                ? ElevatedButton(
                    onPressed: () => _onCharacteristicButtonPressed(context, ffe2Characteristic!),
                    child: Text('Connect to Characteristic UUID: ${ffe2Characteristic.uuid}'),
                  )
                : const Text('No characteristic with UUID ffe2 found.'),
          ],
        ),
      ),
    );
  }

  void _onCharacteristicButtonPressed(BuildContext context, BluetoothCharacteristic characteristic) {
    sl<BluetoothBloc>().add(UpdateCharaEvent(characteristic));
    Navigator.pushNamed(context, '/Home');
  }
}
