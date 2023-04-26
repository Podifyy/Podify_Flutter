import 'package:flutter/material.dart';
import 'package:podify/auth/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:podify/providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  final String? title;
  const HomeScreen({super.key, this.title});
  static const String routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final routes = List.generate(20, (i) => 'test $i');

  final navigatorKey = GlobalKey<NavigatorState>();

  bool isMenuFixed(BuildContext context) {
    return MediaQuery.of(context).size.width > 500;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final menu = Container(
        color: theme.canvasColor,
        child: SafeArea(
            right: false,
            child: Drawer(
              elevation: 0,
              child: ListView(
                children: <Widget>[
                  for (final s in routes)
                    ListTile(
                      title: Text(s),
                      onTap: () {
                        // Using navigator key, because the widget is above nested navigator
                        navigatorKey.currentState!
                            .pushNamedAndRemoveUntil(s, (r) => false);

                        // navigatorKey.currentState.pushNamed(s);
                      },
                    ),
                ],
              ),
            )));

    return Row(
      children: <Widget>[
        if (isMenuFixed(context)) menu,
        Expanded(
          child: Navigator(
            key: navigatorKey,
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(settings.name!),
                      ),
                      body: SafeArea(
                        child: Text(settings.name!),
                      ),
                      drawer: isMenuFixed(context) ? null : menu,
                    );
                  },
                  settings: settings);
            },
          ),
        ),
      ],
    );
  }
}
