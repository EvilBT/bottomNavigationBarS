import 'package:flutter/material.dart';

import 'package:bottom_navigation_bar_s/bottom_navigation_bar_s.dart';

void main() {
  //debugPaintSizeEnabled = true;
  runApp(new MaterialApp(
    home: BottomNavigationDemo(),
  ));
}

class NavigationIconView {
  NavigationIconView(
      {Widget icon,
        String title,
        Color color,
        TickerProvider vsync,
        int badgeCount})
      : _icon = icon,
        _color = color,
        _title = title,
        item = BottomNavigationBarItemS(
            icon: icon,
            title: title == null ? null : Text(title),
            backgroundColor: color,
            badgeCount: badgeCount),
        controller = AnimationController(
            duration: kThemeAnimationDuration, vsync: vsync) {
    _animation = CurvedAnimation(
        parent: controller,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn));
  }
  final Widget _icon;
  final Color _color;
  final String _title;
  final BottomNavigationBarItemS item;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(
      BottomNavigationBarTypeS type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarTypeS.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0.0, 0.02),
          end: Offset.zero,
        ).animate(_animation),
        child: IconTheme(
            data: IconThemeData(
              color: iconColor,
              size: 120.0,
            ),
            child: Semantics(
              label: 'Placeholder for $_title tab',
              child: _icon,
            )),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return Container(
      margin: EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      color: iconTheme.color,
    );
  }
}

class BottomNavigationDemo extends StatefulWidget {
  @override
  _BottomNavigationDemoState createState() => _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarTypeS _type = BottomNavigationBarTypeS.fixed;
  List<NavigationIconView> _navigationViews;
  bool _hideBadge = true;
  bool _autoHideBadge = true;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      NavigationIconView(
          icon: const Icon(Icons.access_alarm),
          title: '警告',
          color: Colors.deepPurple,
          vsync: this,
          badgeCount: 100
      ),
      NavigationIconView(
          icon: CustomIcon(),
          title: '盒子',
          color: Colors.deepOrange,
          vsync: this
      ),
      NavigationIconView(
          icon: FloatingActionButton(onPressed: null,child: Icon(Icons.add),mini: false,),
          color: Colors.teal,
          vsync: this
      ),
      NavigationIconView(
          icon: Icon(Icons.favorite),
          title: '喜爱',
          color: Colors.indigo,
          vsync: this,
          badgeCount: 99
      ),
      NavigationIconView(
        icon: Icon(Icons.event_available),
        title: '事项',
        color: Colors.pink,
        vsync: this,
        badgeCount: 4,
      )
    ];

    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews) view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {});
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transtions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transtions.add(view.transition(_type, context));

    transtions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return Stack(
      children: transtions,
    );
  }

  void _update() {
    setState(() {
      int count = _navigationViews[_currentIndex].item.badgeCount;
      count = count == null ? null : --count;
      _navigationViews[_currentIndex].item.badgeCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarS botNavBar = BottomNavigationBarS(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      hideBadge: _hideBadge,
      autoHideBadge: _autoHideBadge,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          //int count = _navigationViews[_currentIndex].item.badgeCount;
          //count = count == null ? 1 : ++count;
          //_navigationViews[_currentIndex].item.badgeCount = count;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    final FloatingActionButton fab = FloatingActionButton(onPressed: _update,
      child: Icon(Icons.arrow_downward),);

    return Scaffold(
      appBar: AppBar(
        title: Text('底部导航'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                switch(value) {
                  case 'Fixed':
                    _type = BottomNavigationBarTypeS.fixed;
                    break;
                  case 'Shifting':
                    _type = BottomNavigationBarTypeS.shifting;
                    break;
                  case 'HideBadge':
                    _hideBadge = !_hideBadge;
                    break;
                  case 'AutoHideBadge':
                    _autoHideBadge = !_autoHideBadge;
                    break;
                }
              });
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                value: 'Fixed',
                child: Text('Fixed'),
              ),
              PopupMenuItem<String>(
                value: 'Shifting',
                child: Text('Shifting'),
              ),
              PopupMenuItem<String>(
                value: 'HideBadge',
                child: Text('HideBadge'),
              ),
              PopupMenuItem<String>(
                value: 'AutoHideBadge',
                child: Text('AutoHideBadge'),
              )
            ],
          )
        ],
      ),
      body: new Center(
        child: _buildTransitionsStack(),
      ),
      bottomNavigationBar: botNavBar,
      floatingActionButton: fab,
    );
  }
}

