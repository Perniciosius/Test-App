import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        appBarTheme: AppBarTheme(color: Colors.white),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _title = [
    "Home",
    "Not Home",
  ];
  int _index = 0;
  int _prevIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title[_index]),
      ),
      body: PageTransitionSwitcher(
        reverse: _index < _prevIndex,
        duration: Duration(milliseconds: 500),
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
            SharedAxisTransition(
          child: child,
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
        ),
        child: IndexedStack(
          key: ValueKey(_index),
          index: _index,
          children: [
            Home(),
            NotHome(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplanemode_active),
            label: "Not Home",
          ),
        ],
        currentIndex: _index,
        elevation: 10.0,
        onTap: (value) {
          setState(() {
            _prevIndex = _index;
            _index = value;
          });
        },
      ),
    );
  }
}

class Home extends StatelessWidget {
  final ShapeBorder _shapeBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background1.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: OpenContainer(
          closedBuilder: (_, openContainer) => TextButton(
            onPressed: openContainer,
            child: Text("Go Somewhere"),
          ),
          closedElevation: 10.0,
          openBuilder: (_, closeContainer) => Somewhere(closeContainer),
          transitionDuration: Duration(milliseconds: 700),
          tappable: false,
          openShape: _shapeBorder,
          closedShape: _shapeBorder,
        ),
      ),
    );
  }
}

class NotHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 10.0,
          child: TextButton(
            onPressed: () {
              showGeneralDialog(
                context: context,
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (context, animation, _) {
                  print(animation.value * 10);
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10.0,
                      sigmaY: 10.0,
                    ),
                    child: Center(
                      child: Card(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: SizedBox(
                            height: 200,
                            width: 200,
                            child: Center(child: Text("Hello"))),
                      ),
                    ),
                  );
                },
              );
            },
            child: Text("Hello"),
            // shape:
            //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
        ),
      ),
    );
  }
}

class Somewhere extends StatelessWidget {
  final Function({Null returnValue}) closeContainer;
  Somewhere(this.closeContainer);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        closeContainer();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Somewhere"),
        ),
        body: Center(
          child: Text("Somewhere"),
        ),
      ),
    );
  }
}
