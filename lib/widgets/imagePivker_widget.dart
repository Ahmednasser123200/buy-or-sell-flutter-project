import 'dart:io';

import 'package:buysell/provider/cat_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neumorphic_button/neumorphic_button.dart';
import 'package:provider/provider.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;
  bool _uploading = false;
  final picker = ImagePicker();

  get height => null;

  get width => null;

  Future<void> getImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("No image selected");
        }
      });
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);
    Future<String?> uploadFile() async {
      File file = File(_image!.path);
      String imageName =
          'productimage/${DateTime.now().microsecondsSinceEpoch}';
      String? downloadUrl;
      try {
        await FirebaseStorage.instance.ref(imageName).putFile(file);
        downloadUrl =
            await FirebaseStorage.instance.ref(imageName).getDownloadURL();
        if (downloadUrl != null) {
          setState(() {
            _image = null;
            _provider.getImages(downloadUrl);
          });
        }
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Cancelled")));
      }
      return downloadUrl;
    }

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              _provider.urlList.length > 0
                  ? "Upload more image"
                  : 'Upload image',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              children: [
                Stack(
                  children: [
                    if (_image != null)
                      Positioned(
                          child: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _image = null;
                          });
                        },
                      )),
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: _image == null
                            ? Icon(
                                CupertinoIcons.photo_on_rectangle,
                                color: Colors.grey,
                              )
                            : Image.file(_image!),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),

                /* Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListView.builder(
                      itemCount: _provider.urlList.length,
                      itemBuilder: (context, index) {
                        final imageUrl = _provider.urlList[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(child: Image.network(imageUrl)),
                        );
                      },
                    ),
                  ),*/
                /*Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: GalleryImageView(
                      listImage: _provider.urlList.map((url) => Image.network(url).image).toList(),
                      imageDecoration: BoxDecoration(border: Border.all(color: Colors.white)),
                    ),
                  ),*/
                if (_provider.urlList.length > 0)
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey),
                    child: GalleryImage(
                        imageUrls: _provider.urlList,
                        numOfShowImages: _provider.urlList.length),
                  ),
                SizedBox(
                  height: 20.h,
                ),
                if (_image != null)
                  Row(
                    children: [
                      Expanded(
                          child: NeumorphicButton(
                              width: 60.w,
                              height: 50.w,
                              child: Text(
                                'Save',
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.green,
                              bottomRightShadowColor: Colors.transparent,
                              topLeftShadowColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  _uploading = true;
                                });
                                uploadFile().then((url) {
                                  if (url != null) {
                                    setState(() {
                                      _uploading = false;
                                    });
                                  }
                                });
                              })),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                          child: NeumorphicButton(
                              width: 60.w,
                              height: 50.w,
                              child: Text(
                                'cancel',
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.red,
                              bottomRightShadowColor: Colors.transparent,
                              topLeftShadowColor: Colors.transparent,
                              onTap: () {})),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        padding: EdgeInsets.all(9),
                        width: double.infinity,
                        height: 40,
                        child: Text(
                          'Upload image',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        bottomRightShadowColor: Colors.transparent,
                        topLeftShadowColor: Colors.transparent,
                        onTap: getImage,
                      ),
                    )
                  ],
                ),
                if (_uploading)
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
