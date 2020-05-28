import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  /// Saves file taken by Android/iOS devices
  File _storedImage;

  /// Save image loaded by web browsers' image picker.
  /// Determine whether to show on the image preview area by
  /// looking at the kIsWeb.
  Image _webBrowserImage;

  Future<void> _takePicture() async {
    // Android and iOS
    if (!kIsWeb) {
      // Take a photo using the camera of the device and
      // show it in the image preview by using setState
      final imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );
      setState(() {
        _storedImage = imageFile;
      });

      // Store a copy of the photo taken into the app directory
      // for later uses in the future
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(imageFile.path);
      final savedImage = await imageFile.copy('$appDir/$fileName');
    }

    // Web browsers
    // @todo: Need to add logic to save the picked image chosen via
    // the image picker of the web browsers
    if (kIsWeb) {
      Image fromPicker =
          await ImagePickerWeb.getImage(outputType: ImageType.widget);

      if (fromPicker != null) {
        setState(() {
          _webBrowserImage = fromPicker;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 100,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: kIsWeb
              ? _webBrowserImage
              : _storedImage != null
                  ? Image.file(
                      _storedImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Text(
                      'No Image Taken',
                      textAlign: TextAlign.center,
                    ),
          alignment: Alignment.center,
        ),
        SizedBox(width: 10),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
