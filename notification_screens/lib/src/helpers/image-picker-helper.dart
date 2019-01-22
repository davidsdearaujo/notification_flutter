import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  void showImage(BuildContext context, Function(File) setImage) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Stack(
            children: <Widget>[
              Positioned(
                width: 200,
                height: 150,
                bottom: (MediaQuery.of(context).size.height - 150) / 2,
                left: (MediaQuery.of(context).size.width - 200) / 2,
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        _buildButton(
                          onTap: () =>
                              ImagePicker.pickImage(source: ImageSource.gallery)
                                  .then((image) => _cropImage(
                                        imageFile: image,
                                        context: context,
                                        setImage: setImage,
                                      )),
                          text: "Galeria",
                          icon: Icons.image,
                          context: context,
                        ),
                        _buildButton(
                          onTap: () =>
                              ImagePicker.pickImage(source: ImageSource.camera)
                                  .then((image) => _cropImage(
                                        imageFile: image,
                                        context: context,
                                        setImage: setImage,
                                      )),
                          text: "Câmera",
                          icon: Icons.camera_alt,
                          context: context,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void showVideo(BuildContext context, Function(File) setImage) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Stack(
            children: <Widget>[
              Positioned(
                width: 200,
                height: 150,
                bottom: (MediaQuery.of(context).size.height - 150) / 2,
                left: (MediaQuery.of(context).size.width - 200) / 2,
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        _buildButton(
                          onTap: () =>
                              ImagePicker.pickVideo(source: ImageSource.gallery)
                                  .then((video) {
                                    Navigator.of(context).pop();
                                    setImage(video);
                                  }),
                          text: "Galeria",
                          icon: Icons.video_library,
                          context: context,
                        ),
                        _buildButton(
                          onTap: () =>
                              ImagePicker.pickVideo(source: ImageSource.camera)
                                  .then((video) {
                                    Navigator.of(context).pop();
                                    setImage(video);
                                  }),
                          text: "Câmera",
                          icon: Icons.videocam,
                          context: context,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildButton(
      {Function() onTap, String text, IconData icon, BuildContext context}) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: RaisedButton(
        color: Theme.of(context).accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: onTap,
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: Icon(icon, color: Colors.white),
          title: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Future<Null> _cropImage({
    File imageFile,
    BuildContext context,
    Function(File) setImage,
  }) async {
    setImage(
      await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        ratioX: 1.0,
        ratioY: 1.0,
        maxWidth: 512,
        maxHeight: 512,
      ),
    );
    Navigator.of(context).pop();
  }
}
