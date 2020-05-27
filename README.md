# Animated Splash Screen

## Do it your way

### Assets image
![ezgif com-video-to-gif (1)](https://user-images.githubusercontent.com/22732544/83060360-b3e21000-a031-11ea-9666-834f08e43045.gif)

### Custom Widget
![ezgif com-video-to-gif (4)](https://user-images.githubusercontent.com/22732544/83060348-ad539880-a031-11ea-875b-7a5d055e7659.gif)

### Url image
![ezgif com-video-to-gif (3)](https://user-images.githubusercontent.com/22732544/83060353-af1d5c00-a031-11ea-8ba1-3361057610d7.gif)

### IconData
![ezgif com-video-to-gif (2)](https://user-images.githubusercontent.com/22732544/83060355-b2184c80-a031-11ea-8ae2-d274b957eae5.gif)

### Or just change PageTransition and/or SplashTransition
![ezgif com-video-to-gif (5)](https://user-images.githubusercontent.com/22732544/83060336-a75db780-a031-11ea-99d3-856fa9326b28.gif)

## Getting Started
To use is simple, just do this:

    @override
      Widget build(BuildContext context) {
        return AnimatedSplashScreen(
          splash: 'images/splash.png',
          nextScreen: MainScreen(),
          splashTransition: SplashTransition.rotationTransition,
          pageTransitionType: PageTransitionType.scale,
        );
      }
      
### Splash Parameter
Here, you can pass:
* String with assets route;
* String with your url Image, don't forget of pass tag like this "[n]www.my-url.com/my-image.png";
* IconData;
* Widget;

### SplashTransition
    enum SplashTransition {
      slideTransition,
      scaleTransition,
      rotationTransition,
      sizeTransition,
      fadeTransition,
      decoratedBoxTransition
    }

### PageTransitionType
    enum PageTransitionType {
      fade,
      rightToLeft,
      leftToRight,
      upToDown,
      downToUp,
      scale,
      rotate,
      size,
      rightToLeftWithFade,
      leftToRightWithFade,
    }
    
### Others:
    AnimatedSplashScreen({
        Curve curve = Curves.easeInCirc,
        Future Function() function, // Here you can make something before change of screen
        int duration = 2500,
        @required dynamic splash,
        @required Widget nextScreen,
        Color backgroundColor = Colors.white,
        Animatable customTween,
        bool centered = true,
        SplashTransition splashTransition = SplashTransition.fadeTransition,
        PageTransitionType pageTransitionType = PageTransitionType.downToUp,
     })
     
## With Future Screen
Here you can do something that will return your next screen, ex:

    AnimatedSplashScreen.withScreenFunction(
      splash: 'images/splash.png',
      screenFunction: () async{
        return MainScreen();
      },
      splashTransition: SplashTransition.rotationTransition,
      pageTransitionType: PageTransitionType.scale,
    )
    
## Help Maintenance

I've been maintaining quite many repos these days and burning out slowly. If you could help me cheer up, buying me a cup of coffee will make my life really happy and get much energy out of it.

<a href="https://www.buymeacoffee.com/RtrHv1C" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>