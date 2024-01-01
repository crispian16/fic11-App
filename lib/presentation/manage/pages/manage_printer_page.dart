import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'package:fic11_starter_pos/core/extensions/build_context_ext.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../widgets/menu_printer_button.dart';
import '../widgets/menu_printer_content.dart';

class ManagePrinterPage extends StatefulWidget {
  const ManagePrinterPage({super.key});

  @override
  State<ManagePrinterPage> createState() => _ManagePrinterPageState();
}

class _ManagePrinterPageState extends State<ManagePrinterPage> {
  int selectedIndex = 0;

  String macName = '';

  bool connected = false;
  List<BluetoothInfo> items = [];


  String optionprinttype = "58 mm";
  List<String> options = ["58 mm", "80 mm"];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
    // ignore: empty_catches
    } on PlatformException {
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    if (result) {
    } else {}

    setState(() {
    });
  }

  Future<void> getBluetoots() async {
    setState(() {
      items = [];
    });
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    setState(() {
    });

    if (listResult.isEmpty) {
    } else {}

    setState(() {
      items = listResult;
    });
  }

  Future<void> connect(String mac) async {
    setState(() {
      connected = false;
    });
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    if (result) connected = true;
    setState(() {
    });
  }

  Future<void> disconnect() async {
    setState(() {
      connected = false;
    });
  }

  Future<void> printTest() async {
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    //print("connection status: $conexionStatus");
    if (conexionStatus) {
    } else {
      //no conectado, reconecte
    }
  }

  Future<List<int>> testTicket() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        optionprinttype == "58 mm" ? PaperSize.mm58 : PaperSize.mm80, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    bytes +=
        generator.text('Code with Bahri', styles: const PosStyles(bold: true));
    bytes +=
        generator.text('Reverse text', styles: const PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: const PosStyles(underline: true), linesAfter: 1);
    bytes += generator.text('Align left',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.text(
      'FIC Batch 11',
      styles: const PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  Future<void> printWithoutPackage() async {
    //impresion sin paquete solo de PrintBluetoothTermal
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      setState(() {});
    } else {
      //no conectado, reconecte
      setState(() {});
    }
  }

  Future<void> printString() async {
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conexionStatus) {
      String enter = '\n';
      await PrintBluetoothThermal.writeBytes(enter.codeUnits);
      //size of 1-5
      String text = "Hello";
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: 1, text: text));
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: 2, text: "$text size 2"));
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: 3, text: "$text size 3"));
    } else {
      //desconectado
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Printer'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Container(
            width: context.deviceWidth / 2,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MenuPrinterButton(
                  label: 'Search',
                  onPressed: () {
                    getBluetoots();
                    selectedIndex = 0;
                    setState(() {});
                  },
                  isActive: selectedIndex == 0,
                ),
                MenuPrinterButton(
                  label: 'Disconnect',
                  onPressed: () {
                    selectedIndex = 1;
                    setState(() {});
                  },
                  isActive: selectedIndex == 1,
                ),
                MenuPrinterButton(
                  label: 'Test',
                  onPressed: () {
                    selectedIndex = 2;
                    setState(() {});
                  },
                  isActive: selectedIndex == 2,
                ),
              ],
            ),
          ),
          const SpaceHeight(34.0),
          _Body(
            // selectedIndex: selectedIndex,
            macName: macName,
            datas: items,
            clickHandler: (mac) async {
              macName = mac;
              await connect(mac);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  // final int selectedIndex;
  final String macName;
  final List<BluetoothInfo> datas;

  //clickHandler
  final Function(String) clickHandler;

  const _Body({
    Key? key,
    required this.macName,
    required this.datas,
    required this.clickHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (datas.isEmpty) {
      return const Text('No data available');
    } else {
      return Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.card, width: 2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: datas.length,
          separatorBuilder: (context, index) => const SpaceHeight(16.0),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              clickHandler(datas[index].macAdress);
            },
            child: MenuPrinterContent(
              isSelected: macName == datas[index].macAdress,
              data: datas[index],
            ),
          ),
        ),
      );
    }
    // return const Placeholder();
  }
}
