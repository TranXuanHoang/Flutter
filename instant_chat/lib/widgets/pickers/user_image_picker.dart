import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) userImagePickingHandler;

  UserImagePicker(this.userImagePickingHandler);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  final _picker = ImagePicker();

  void _pickProfileImage() async {
    final imageSource = await showDialog(
      context: context,
      child: AlertDialog(
        title: Text(
          'Take Your Profile Picture From?',
          style: TextStyle(
            color: Theme.of(context).primaryTextTheme.headline6.color,
          ),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.image,
                    color: Theme.of(context).accentColor,
                  ),
                  Text(
                    'Galery',
                    style: TextStyle(
                      color: Theme.of(context).primaryTextTheme.headline6.color,
                    ),
                  ),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
              onPressed: () => Navigator.of(context).pop('galery'),
            ),
            FlatButton(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.camera,
                    color: Theme.of(context).accentColor,
                  ),
                  Text(
                    'Camera',
                    style: TextStyle(
                      color: Theme.of(context).primaryTextTheme.headline6.color,
                    ),
                  ),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
              onPressed: () => Navigator.of(context).pop('camera'),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
    if (imageSource == null) {
      return;
    }
    final pickedImage = await _picker.getImage(
      source:
          imageSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = File(pickedImage.path);
    });
    widget.userImagePickingHandler(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          onPressed: _pickProfileImage,
          icon: Icon(Icons.image),
          label: Text(
              '${_pickedImage == null ? 'Add' : 'Change'} Profile Picture'),
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
