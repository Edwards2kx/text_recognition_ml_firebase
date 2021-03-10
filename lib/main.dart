import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File image;
  String myString = 'Aqui va lo leido en la imagen';

  void _buscarImagen() async {
    File _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print('se escogio una imagen');
    setState(() {
      image = _image;
      myString = ''; //limpia la cadena de caracteres
    });
    _procesarImagen();
  }

  void _procesarImagen() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(image);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        print(line.text);
        setState(() {
          myString = '$myString${line.text}\n';
        });
//        for (TextElement word in line.elements) {
        //print(word.text);
//        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase MLKit for Workana job'),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          image != null
              ? InteractiveViewer(
                  child: Container(
                    child: Image.file(
                      image,
                      height: 500.0,
                    ),
                  ),
                )
              : Container(
                  width: 500,
                  height: 500,
                  child: Image.asset(
                    'assets/no_image.jpg',
                    fit: BoxFit.fitHeight,
                  ),
                  decoration: BoxDecoration(color: Colors.amber),
                ),
          SizedBox(
            height: 30.0,
          ),
          Text(myString),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () {
          _buscarImagen();
        },
      ),
    );
  }
}
