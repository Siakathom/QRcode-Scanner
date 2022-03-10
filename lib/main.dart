import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: HomePage(),
));


class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = "Hey, Press the camera button to scan a QRcode.";
Future _scanQR() async{
  try{
    ScanResult qrResult = await BarcodeScanner.scan();
    setState(() {
      result = qrResult.rawContent;
    });
  }on PlatformException catch (ex){
    if(ex.code == BarcodeScanner.cameraAccessDenied){
      setState(() {
        result = "Camera Permission was Denied";
      });
    }else{
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }on FormatException{
    setState(() {
      result = "You pressed the back button before scanning anything";
    });
  }catch (ex){
    setState(() {
        result = "Unknown Error $ex";
      });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      body: Center(
        child: SelectableText(
        result,
        textAlign: TextAlign.center,
        style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}