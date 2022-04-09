import 'package:flutter/material.dart';

class EmptyPage extends StatefulWidget {
  EmptyPage({required this.child});

  final Widget child;

  @override
  _EmptyPage createState() => _EmptyPage();
}

class _EmptyPage extends State<EmptyPage> {
  int _currentRoute = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: widget.child,
                centerTitle: true,
              ),
              body: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  child: Text("this is an empty page")),
            );
          },
        );
      },
    );
  }
}