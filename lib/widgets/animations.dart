import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AppAnimations {
  // Page transition animations
  static Route<T> slideUpRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route<T> slideRightRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Fade route
  static Route<T> fadeRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // Scale route
  static Route<T> scaleRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          )),
          child: child,
        );
      },
    );
  }

  // Card animations
  static Widget cardSlideInAnimation(Widget child, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(0, 50, 0),
      child: child,
    );
  }

  static Widget cardFadeInAnimation(Widget child, int index) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 400 + (index * 150)),
      curve: Curves.easeIn,
      child: Transform.scale(
        scale: 1.0,
        child: child,
      ),
    );
  }

  // Loading animations
  static Widget loadingPulse() {
    return AnimatedBuilder(
      animation: AlwaysStoppedAnimation<double>(1.0),
      builder: (context, child) {
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Constants.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Constants.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget shimmerLoading() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Constants.borderColor,
                Constants.surfaceColor,
                Constants.borderColor,
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
              begin: Alignment(-1.0, 0.0),
              end: Alignment(1.0, 0.0),
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Container(
            width: constraints.maxWidth,
            height: 200,
            decoration: BoxDecoration(
              color: Constants.borderColor,
              borderRadius: Constants.borderRadiusL,
            ),
          ),
        );
      },
    );
  }

  // Button press animations
  static Widget animatedButton({
    required Widget child,
    required VoidCallback onPressed,
    Duration duration = const Duration(milliseconds: 150),
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedScale(
        duration: duration,
        scale: 1.0,
        child: AnimatedContainer(
          duration: duration,
          curve: Curves.easeInOut,
          child: child,
        ),
      ),
    );
  }

  // Floating action button animation
  static Widget floatingActionButtonAnimation({
    required Widget child,
    required VoidCallback onPressed,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return AnimatedScale(
      duration: duration,
      scale: 1.0,
      curve: Curves.elasticOut,
      child: child,
    );
  }

  // Tab indicator animation
  static Widget tabIndicator({
    required Widget child,
    required Animation<double> animation,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (animation.value * 0.1),
          child: child,
        );
      },
      child: child,
    );
  }

  // Refresh indicator animation
  static Widget refreshIndicator({
    required Widget child,
    required RefreshCallback onRefresh,
  }) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Constants.primaryColor,
      backgroundColor: Constants.surfaceColor,
      strokeWidth: 3,
      child: child,
    );
  }

  // Success animation
  static Widget successAnimation(VoidCallback onComplete) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Constants.successColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 50,
            ),
          ),
          SizedBox(height: Constants.spacingL),
          Text(
            'Success!',
            style: Constants.headlineMedium.copyWith(
              color: Constants.successColor,
            ),
          ),
        ],
      ),
    );
  }

  // Error animation
  static Widget errorAnimation(VoidCallback onComplete) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Constants.errorColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 50,
            ),
          ),
          SizedBox(height: Constants.spacingL),
          Text(
            'Something went wrong',
            style: Constants.headlineMedium.copyWith(
              color: Constants.errorColor,
            ),
          ),
        ],
      ),
    );
  }

  // Bounce animation
  static Widget bounceInAnimation(Widget child, Duration duration) {
    return AnimatedBuilder(
      animation: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: AlwaysStoppedAnimation<double>(1.0),
        curve: Curves.elasticOut,
      )),
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0,
          child: child,
        );
      },
      child: child,
    );
  }

  // Slide up from bottom sheet animation
  static Widget bottomSheetSlideAnimation(
      Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset(0, 0),
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.elasticOut,
      )),
      child: child,
    );
  }

  // Typing animation
  static Widget typingAnimation(String text, Duration duration) {
    return AnimatedBuilder(
      animation: AlwaysStoppedAnimation<double>(1.0),
      builder: (context, child) {
        return Text(
          text,
          style: Constants.bodyMedium,
        );
      },
    );
  }

  // Progress bar animation
  static Widget progressBarAnimation(double value, Color color) {
    return AnimatedBuilder(
      animation: AlwaysStoppedAnimation<double>(value),
      builder: (context, child) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        );
      },
    );
  }

  // Floating labels animation
  static Widget floatingLabelAnimation({
    required Widget child,
    bool isFocused = false,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(0, isFocused ? -20 : 0, 0),
      child: child,
    );
  }

  // Notification slide animation
  static Widget notificationSlideAnimation(
      Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.elasticOut,
      )),
      child: child,
    );
  }

  // Image zoom animation
  static Widget imageZoomAnimation(Widget child, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: Duration(milliseconds: 200),
        scale: 1.0,
        curve: Curves.easeInOut,
        child: child,
      ),
    );
  }

  // Notification badge animation
  static Widget notificationBadge(int count) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: count > 0
          ? Container(
              key: ValueKey(count),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Constants.errorColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: Constants.labelSmall.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  // Toggle switch animation
  static Widget toggleSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
    Duration duration = const Duration(milliseconds: 200),
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: duration,
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: Constants.borderRadiusL,
          color: value ? Constants.primaryColor : Constants.borderColor,
        ),
        child: AnimatedAlign(
          duration: duration,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.all(3),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
