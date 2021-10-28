// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:radial_button/widget/circle_floating_button.dart';

import 'package:tflite/tflite.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: unused_field
  bool _loading = false;

  // ignore: unused_field
  File? _image;
  // ignore: unused_field
  List? _output;

  final picker = ImagePicker();

  detectImage(PickedFile? image) async {
    var output = await Tflite.runModelOnImage(
      path: image!.path,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadMode() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  pickImage() async {
    // ignore: deprecated_member_use
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    detectImage(image);
  }

  pickGallary() async {
    // ignore: deprecated_member_use
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }

    setState(() {
      _image = File(image.path);
    });
    detectImage(image);
  }

  Future<File>? imageFile;
  File? _file;
  String result = " ";

  ImagePicker? imagePicker;
  selectPhotoFromGallery() async {
    XFile? pickedFile =
        await imagePicker!.pickImage(source: ImageSource.gallery);
    _file = File(pickedFile!.path);
    setState(() {
      // ignore: unnecessary_statements
      _file;
      doImageclassifier();
    });
  }

  capturePhotoFromCamera() async {
    XFile? pickedFile =
        await imagePicker!.pickImage(source: ImageSource.camera);
    _file = File(pickedFile!.path);
    setState(() {
      // ignore: unnecessary_statements
      _file;
      doImageclassifier();
    });
  }

  loadingModel() async {
    String? output = await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );

    print(output);
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    loadingModel();
  }

  doImageclassifier() async {
    var recognization = await Tflite.runModelOnImage(
      path: _file!.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.1,
      asynch: true,
    );
    print(recognization!.length.toString());
    setState(() {
      result = '';
    });

    recognization.forEach((element) {
      setState(() {
        print("Hello world${element.toString()}");
        result += element['label'] + '\n\n';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var itemActionBar = [
      FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          Get.snackbar(
              "Building",
               "in progress",
               icon: Icon(Icons.build_outlined, color: Colors.orangeAccent),
               snackPosition: SnackPosition.BOTTOM,
               backgroundColor: Colors.transparent,
               borderRadius: 20,
               margin: EdgeInsets.all(15),
               colorText: Colors.white,
               duration: Duration(seconds: 4),
               isDismissible: true,
               dismissDirection: SnackDismissDirection.HORIZONTAL,
               forwardAnimationCurve: Curves.easeOutBack,

               );
        },
        child: Icon(Icons.settings),
      ),
      FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        onPressed: () {
          capturePhotoFromCamera();
          print("PickImage");
        },
        child: Icon(Icons.camera),
      ),
      FloatingActionButton(
          backgroundColor: Colors.greenAccent,
          onPressed: () {
            selectPhotoFromGallery();
            print("Gallery");
          },
          child: Icon(Icons.photo_size_select_large_outlined)),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: CircleFloatingButton.floatingActionButton(
        items: itemActionBar,
        color: Colors.redAccent,
        icon: Icons.center_focus_weak_outlined,
        duration: Duration(milliseconds: 900),
        curveAnim: Curves.ease,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            // height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: Image(
                    image: AssetImage(
                      "assets/images/cat_dog_icon.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Dog and Cat Classifier",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    child: _file != null
                        ? Image.file(_file!)
                        : SizedBox(
                            width: 350,
                            height: 250,
                            child: Image(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                "assets/images/cat_dog_icon.png",
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Text(
                    "$result",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                // TextButton(
                //   onLongPress: () {
                //     capturePhotoFromCamera();
                //   },
                //   onPressed: () {
                //     selectPhotoFromGallery();
                //   },
                //   child: Text("Gallery"),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
