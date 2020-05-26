import 'package:flutter/material.dart';

/// Defines a custom way of transitioning between routes (screens).
/// This [CustomRoute<T>] class is used in customing a specific route
/// transition animation.
///
/// Usage Example:
/// * Traditional routing
/// ```dart
/// // Default of navigating to a screen
/// Navigator.of(context)
///     .pushReplacementNamed(OrdersScreen.routeName);
/// ```
///
/// * Custom routing
/// ```dart
/// // Use CustomRoute to navigate to a screen with
/// // custom transition animation
/// Navigator.of(context)
///     .pushReplacement(CustomRoute(
///   builder: (context) => OrdersScreen(),
/// )),
/// ```
class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({
    WidgetBuilder builder,
    RouteSettings settings,
  }) : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Below is the default buildTransitions of the MaterialPageRoute.
    // Uncomment it if we want to use the default route transition
    // return super
    //     .buildTransitions(context, animation, secondaryAnimation, child);

    // Create a custom page transition
    if (settings.name == '/') {
      return child;
    }

    // Uncomment the following code snippet if want to use FadeTransition
    return FadeTransition(
      opacity: animation,
      child: child,
    );
    // return ScaleTransition(
    //   scale: animation,
    //   child: child,
    //   alignment: Alignment.bottomCenter,
    // );
  }
}

/// Defines a custom [PageTransitionsBuilder] that can be used to
/// change the default animation of trasitioning between routes.
/// To apply this [CustomPageTransitionsBuilder] to all route transitions,
/// explicitly specify the [pageTransitionsTheme] in the [MaterialApp]'s
/// [theme] argument like so:
///
///```dart
/// MaterialApp(
///   ...,
///   theme: ThemeData(
///     ...,
///     pageTransitionsTheme: PageTransitionsTheme(
///       builders: {
///         TargetPlatform.android: CustomPageTransitionBuilder(),
///         TargetPlatform.iOS: CustomPageTransitionBuilder(),
///       },
///     ),
///     ...,
///   ),
/// )
/// ```
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (route.settings.name == '/') {
      return child;
    }

    // Below, we use the CustomRoute.buildTransition() method
    // to get the same route animation defined in that method.
    // But we can also simply define our own custom page
    // transition here. For example,
    // return ScaleTransition(
    //   scale: animation,
    //   child: child,
    //   alignment: Alignment.bottomCenter,
    // );
    return CustomRoute(
      builder: (_) => child,
      settings: route.settings,
    ).buildTransitions(
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
