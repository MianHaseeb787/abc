import 'dart:developer';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WindowsUSBPrinterScreen(),
    );
  }
}

class WindowsUSBPrinterScreen extends StatefulWidget {
  const WindowsUSBPrinterScreen({Key? key}) : super(key: key);

  @override
  _WindowsUSBPrinterScreenState createState() =>
      _WindowsUSBPrinterScreenState();
}

class _WindowsUSBPrinterScreenState extends State<WindowsUSBPrinterScreen> {
  var defaultPrinterType = PrinterType.usb;
  var printerManager = PrinterManager.instance;
  BluetoothPrinter? selectedPrinter;

  @override
  void initState() {
    super.initState();
    _scan();
  }

  void _scan() {
    // Scan for USB printers
    printerManager.discovery(type: defaultPrinterType).listen((device) {
      setState(() {
        selectedPrinter = device as BluetoothPrinter?;
      });
    });
  }

  void _printReceipt() async {
    if (selectedPrinter == null) return;

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    final receiptContent = 'Hello, Printer! sjkdbnshjkdb  ';

    final bytes = generator.text(receiptContent,
        styles: const PosStyles(align: PosAlign.center));

    // Connect to the selected USB printer
    await printerManager.connect(
        type: selectedPrinter!.typePrinter,
        model: UsbPrinterInput(name: selectedPrinter!.deviceName));

    // Send the print command
    printerManager.send(type: selectedPrinter!.typePrinter, bytes: bytes);

    // Disconnect after printing
    await printerManager.disconnect(type: selectedPrinter!.typePrinter);

    log('Printed receipt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text('USB Printer Example (Windows)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _printReceipt();
              },
              child: const Text('Print'),
            ),
            if (selectedPrinter != null) const SizedBox(height: 20),
            if (selectedPrinter != null)
              Text('Selected Printer: ${selectedPrinter!.deviceName}'),
          ],
        ),
      ),
    );
  }
}

class BluetoothPrinter {
  String? deviceName;
  PrinterType typePrinter;

  BluetoothPrinter({
    this.deviceName,
    this.typePrinter = PrinterType.usb, // Change the default to PrinterType.usb
  });
}
