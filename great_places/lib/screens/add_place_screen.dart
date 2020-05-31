import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/place.dart';
import '../providers/great_places.dart';
import '../widgets/image_input.dart';
import '../widgets/location_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _form = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;

  Map<String, dynamic> formData = {
    'title': '',
  };

  void _handleSelectImage(File pickedImage) {
    this._pickedImage = pickedImage;
  }

  void _handleSelectPlace(PlaceLocation pickedLocation) {
    this._pickedLocation = pickedLocation;
  }

  void _savePlace() {
    if (!_form.currentState.validate()) {
      return;
    }
    if (_pickedImage == null) {
      _showAlert(
        title: 'No Image Taken!',
        message: 'Please take an image of the place you want to add',
      );
      return;
    }
    if (_pickedLocation == null) {
      _showAlert(
        title: 'No Location Specified!',
        message: 'Please specify the location of the place',
      );
      return;
    }
    _form.currentState.save();

    // Add place info to the places list,
    // then go back to the places_list_scren
    Provider.of<GreatPlaces>(context, listen: false).addPlace(
      formData['title'],
      _pickedImage,
      _pickedLocation,
    );
    Navigator.of(context).pop();
  }

  void _showAlert({String title, String message}) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Title'),
                        controller: _titleController,
                        onSaved: (newValue) {
                          formData['title'] = newValue;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please specify the title.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      ImageInput(_handleSelectImage),
                      SizedBox(height: 10),
                      LocationInput(_handleSelectPlace),
                    ],
                  ),
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Place'),
            onPressed: _savePlace,
            color: Theme.of(context).accentColor,
            padding: EdgeInsets.all(10),
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          )
        ],
      ),
    );
  }
}
