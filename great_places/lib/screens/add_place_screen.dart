import 'package:flutter/material.dart';

import '../widgets/image_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _form = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  Map<String, dynamic> formData = {
    'title': '',
  };

  void _submit() {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();

    print(formData['title']);
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
                        // onFieldSubmitted: (value) => _submit(),
                      ),
                      SizedBox(height: 10),
                      ImageInput(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            onPressed: _submit,
            icon: Icon(Icons.add),
            label: Text('Add Place'),
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
