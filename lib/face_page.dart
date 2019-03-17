
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';

class FacePage extends StatefulWidget {
  @override
  _FacePageState createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {

  File _imageFile;
  static Face i;
  List<Face> _faces=[i];

  void _getImageAndDetectFaces() async{
    print('it s happening');

    final imageFile= await ImagePicker.pickImage(source: ImageSource.gallery);
    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
      )
    );
    final faces = await faceDetector.detectInImage(image);
//    final faces = await faceDetector.processImage(image);
    if(mounted){
      setState(() {
        _imageFile = imageFile;
        _faces = faces;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Faces Detector sia'),
      ),

      body: ImagesAndFaces(imageFile: _imageFile, faces: _faces,),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Pick an Image',
        child: Icon(Icons.add_a_photo),
        onPressed: (){ _getImageAndDetectFaces(); },

      ),

    );
  }
}

class ImagesAndFaces extends StatelessWidget {
  const ImagesAndFaces({
    this.imageFile,
    this.faces,
    Key key,
  }) : super(key: key);

  final File imageFile;
  final List<Face> faces;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset('assets/firebase_lockup.png', fit: BoxFit.cover,),
        Flexible(
          flex: 2,
          child: Container(
            color: Colors.lightGreenAccent,
            constraints: BoxConstraints.expand(),
            child: Image.file(
              imageFile, fit: BoxFit.contain,
            ),
          ),
        ),
        Text('faces found at: '),
        Flexible(
          flex: 1,
          child: ListView(
            children: faces.map<Widget>((f) => FaceCoordinates(f)).toList() ,
          ),
        )
      ],
    );
  }
}

class FaceCoordinates extends StatelessWidget {
  FaceCoordinates(this.face);

  final Face face;
  @override
  Widget build(BuildContext context) {
    final pos =face.boundingBox;
    return ListTile(
      title: Text('(${pos.top}, ${pos.left}, ${pos.bottom}, ${pos.right})'),
    );
  }
}
