library animated_splash_screen;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';

enum _splashType { simpleSplash, backgroundScreenReturn }
enum SplashTransition {
  slideTransition,
  scaleTransition,
  rotationTransition,
  sizeTransition,
  fadeTransition,
  decoratedBoxTransition
}

class AnimatedSplashScreen extends StatefulWidget {
  final PageTransitionType transitionType;
  final SplashTransition splashTransition;
  final Future Function() function;
  final Animatable customAnimation;
  final Color backgroundColor;
  final Widget nextScreen;
  final _splashType type;
  final bool centered;

  /// It can be string for [Image.asserts], normal [Widget] or you can user tags
  /// to choose which one you image type, for example:
  /// * '[n]www.my-site.com/my-image.png' to [Image.network]
  /// * '[i]Icons.my_icon' to [Icon] widget
  final dynamic splash;
  final int duration;
  final Curve curve;

  factory AnimatedSplashScreen({
    Curve curve = Curves.easeInCirc,
    Future Function() function,
    int duration = 2500,
    @required dynamic splash,
    @required Widget nextScreen,
    Color backgroundColor = Colors.white,
    Animatable customTween,
    bool centered = true,
    SplashTransition splashTransition = SplashTransition.fadeTransition,
    PageTransitionType pageTransitionType = PageTransitionType.downToUp,
  }) {
    return AnimatedSplashScreen._internal(
        backgroundColor: backgroundColor,
        transitionType: pageTransitionType,
        splashTransition: splashTransition,
        customAnimation: customTween,
        function: function,
        duration: duration,
        centered: centered,
        splash: splash,
        type: _splashType.simpleSplash,
        nextScreen: nextScreen,
        curve: curve);
  }

  factory AnimatedSplashScreen.withScreenFunction({
    Curve curve = Curves.easeInCirc,
    bool centered = true,
    int duration = 2500,
    @required dynamic splash,
    @required Future<Widget> Function() screenFunction,
    Animatable customTween,
    Color backgroundColor = Colors.white,
    SplashTransition splashTransition = SplashTransition.fadeTransition,
    PageTransitionType pageTransitionType = PageTransitionType.downToUp,
  }) {
    return AnimatedSplashScreen._internal(
        type: _splashType.backgroundScreenReturn,
        transitionType: pageTransitionType,
        splashTransition: splashTransition,
        backgroundColor: backgroundColor,
        customAnimation: customTween,
        function: screenFunction,
        duration: duration,
        centered: centered,
        nextScreen: null,
        splash: splash,
        curve: curve);
  }

  AnimatedSplashScreen._internal({
    @required this.splashTransition,
    @required this.customAnimation,
    @required this.backgroundColor,
    @required this.transitionType,
    @required this.nextScreen,
    @required this.function,
    @required this.duration,
    @required this.centered,
    @required this.splash,
    @required this.curve,
    @required this.type,
  })  : assert(duration != null, 'Duration cannot be null'),
        assert(transitionType != null, 'TransitionType cannot be null'),
        assert(splashTransition != null, 'SplashTransition cannot be null'),
        assert(curve != null, 'Curve cannot be null');

  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  static BuildContext _context;
  Animation _animation;

  AnimatedSplashScreen get w => widget;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 800));

    Animatable animation = w.customAnimation ??
        () {
          switch (w.splashTransition) {
            case SplashTransition.slideTransition:
              return Tween<Offset>(
                end: Offset.zero,
                begin: Offset(1, 0),
              );

            case SplashTransition.decoratedBoxTransition:
              return DecorationTween(
                  end: BoxDecoration(color: Colors.black87),
                  begin: BoxDecoration(color: Colors.redAccent));

            default:
              return Tween(begin: 0.0, end: 1.0);
          }
        }();

    _animation = animation
        .animate(CurvedAnimation(parent: _animationController, curve: w.curve));
    _animationController.forward();
    doTransition();
  }

  doTransition() async {
    if (w.type == _splashType.backgroundScreenReturn)
      navigator(await w.function());
    else
      navigator(w.nextScreen);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.reset();
  }

  navigator(screen) {
    Future.delayed(
            Duration(milliseconds: w.duration < 1000 ? 2000 : w.duration))
        .then((_) => Navigator.of(_context).pushReplacement(
            PageTransition(type: w.transitionType, child: screen)));
  }

  Widget getSplash() {
    final size = MediaQuery.of(context).size.shortestSide * 0.2;
    Widget main({@required Widget child}) =>
        w.centered ? Center(child: child) : child;

    return getTransition(
        child: main(
            child: SizedBox(
                height: size,
                child: w.splash is String
                    ? <Widget>() {
                        if (w.splash.toString().contains('[n]'))
                          return Image.network(
                              w.splash.toString().replaceAll('[n]', ''));
                        else
                          return Image.asset(w.splash);
                      }()
                    : (w.splash is IconData
                        ? Icon(w.splash, size: size)
                        : w.splash))));
  }

  Widget getTransition({@required Widget child}) {
    switch (w.splashTransition) {
      case SplashTransition.slideTransition:
        return SlideTransition(
            position: (_animation as Animation<Offset>), child: child);
        break;

      case SplashTransition.scaleTransition:
        return ScaleTransition(
            scale: (_animation as Animation<double>), child: child);
        break;

      case SplashTransition.rotationTransition:
        return RotationTransition(
            turns: (_animation as Animation<double>), child: child);
        break;

      case SplashTransition.sizeTransition:
        return SizeTransition(
            sizeFactor: (_animation as Animation<double>), child: child);
        break;

      case SplashTransition.fadeTransition:
        return FadeTransition(
            opacity: (_animation as Animation<double>), child: child);
        break;

      case SplashTransition.decoratedBoxTransition:
        return DecoratedBoxTransition(
            decoration: (_animation as Animation<Decoration>), child: child);
        break;

      default:
        return FadeTransition(
            opacity: (_animation as Animation<double>), child: child);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(backgroundColor: w.backgroundColor, body: getSplash());
  }
}
