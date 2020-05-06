import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../models/meal.dart';
import '../widgets/meal_item.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  String categoryTitle;
  List<Meal> displayedMeals;
  var _loadedInitData = false;

  @override
  void initState() {
    super.initState();
  }

  // Override this method to only load the whole meals of the given
  // category (specified by the routeArgs) one time at the beginning
  // when we initialize this state object.
  // Because we also need to refer to the 'context', we cannot do it
  // inside the initState method. Instead, we do it here - inside the
  // didChangeDependencies method with the use of a flag field
  // _loadedInitData determining whether the initial data has been loaded.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loadedInitData) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, Object>;
      final String categoryId = routeArgs['id'];
      categoryTitle = routeArgs['title'];
      displayedMeals = DUMMY_MEALS.where((meal) {
        return meal.categories.contains(categoryId);
      }).toList();

      _loadedInitData = true;
    }
  }

  void _removeMeal(String mealId) {
    setState(() {
      displayedMeals.removeWhere((meal) => meal.id == mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return MealItem(
              id: displayedMeals[index].id,
              title: displayedMeals[index].title,
              imageUrl: displayedMeals[index].imageUrl,
              duration: displayedMeals[index].duration,
              complexity: displayedMeals[index].complexity,
              affordability: displayedMeals[index].affordability,
              removeItem: _removeMeal,
            );
          },
          itemCount: displayedMeals.length,
        ),
      ),
    );
  }
}
