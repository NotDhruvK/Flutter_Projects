import 'package:flutter/material.dart';
import 'package:recipies_app/models/meal.dart';
import 'package:recipies_app/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, this.title, required this.meals});

  final String? title;
  final List<Meal> meals;

  @override
  Widget build(BuildContext context) {
    Widget content = meals.isEmpty
        // IF MEALS ARE EMPTY
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Uh oh....nothing here!",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Try selecting a different category',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          )
        // IF MEALS ARE NOT EMPTY
        : ListView.builder(
            itemCount: meals.length,
            itemBuilder: (ctx, index) => MealItem(meal: meals[index]),
          );

    if (title == null) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content,
    );
  }
}
