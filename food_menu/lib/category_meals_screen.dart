import 'package:flutter/material.dart';

class CategoryMealsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Recepies'),
      ),
      body: Center(
        child: Text('The recepies for the category'),
      ),
    );
  }
}
