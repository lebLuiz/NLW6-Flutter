import 'package:flutter/material.dart';
import 'package:payflow/modules/barcode_sanner/barcode_scanner_controller.dart';
import 'package:payflow/modules/barcode_sanner/barcode_scanner_status.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text.dart';
import 'package:payflow/shared/widgets/bottom_sheet/bottom_sheet_widget.dart';
import 'package:payflow/shared/widgets/set_labels_buttons/set_label_buttons.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({ Key? key }) : super(key: key);

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {

  final controller = BarcodeScannerController();

  @override
  void initState() {
    controller.getAvailableCameras();
    controller.statusNotifier.addListener(() {
      if (controller.status.hasBarcode) {
        Navigator.pushReplacementNamed(context, "/insert_boleto", arguments: controller.status.barcode);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      left: true,
      right: true,
      child: Stack(
        children: [

          ValueListenableBuilder<BarcodeScannerStatus>(
            valueListenable: controller.statusNotifier,
            builder: (_, status, __) {
              if (status.showCamera) {
                return Container(
                  child: controller.cameraController!.buildPreview(),
                );
              } else {
                return Container();
              }
            },
          ),

          RotatedBox(
            quarterTurns: 1,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.black,
                title: Text(
                  "Escaneie o c??digo de barras de boleto",
                  style: TextStyles.buttonBackground,
                ),
                leading: BackButton(
                  color: AppColors.background,
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.black54,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: SetLabelButtons(
                primaryLabel: "Inserir c??digo do boleto",
                primaryOnPressed: () {
                  controller.status = BarcodeScannerStatus.error("Error");
                },
                secondaryLabel: "Adicionar da galeria",
                secondaryOnPressed: controller.scanWithImagePicker
              ),
            ),
          ),

          ValueListenableBuilder<BarcodeScannerStatus>(
            valueListenable: controller.statusNotifier,
            builder: (_, status, __) {
              if (status.hasError) {
                return Align(
                  alignment: Alignment.bottomLeft,
                  child: BottomSheetWidget(
                    primaryLabel: "Escanear novamente",
                    primaryOnPressed: () {
                      controller.scanWithCamera();
                    },
                    secondaryLabel: "Digitar c??digo",
                    secondaryOnPressed: (){},
                    title: "N??o foi poss??vel identificar um c??digo de barras.",
                    subTitle: "Tente escanear novamente ou digite o c??digo do seu boleto."
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}