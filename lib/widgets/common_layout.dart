import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'common_widget';

class CommonScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final bool isScrollable;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  const CommonScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    this.onBackPressed,
    this.showBackButton = false,
    this.isScrollable = true,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: showBackButton
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
            : null,
        actions: actions,
        elevation: 0,
        centerTitle: true,
      ),
      body: isScrollable
          ? SingleChildScrollView(
              padding: EdgeInsets.all(Constants.spacingM),
              child: body,
            )
          : Padding(
              padding: EdgeInsets.all(Constants.spacingM),
              child: body,
            ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}

class CommonFormScaffold extends StatelessWidget {
  final String title;
  final Widget form;
  final VoidCallback? onSubmit;
  final String submitButtonText;
  final bool isLoading;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const CommonFormScaffold({
    Key? key,
    required this.title,
    required this.form,
    this.onSubmit,
    this.submitButtonText = 'Save',
    this.isLoading = false,
    this.actions,
    this.onBackPressed,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: showBackButton
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
            : null,
        actions: actions,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: EdgeInsets.all(Constants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: form),
                SizedBox(height: Constants.spacingL),
                CommonButton(
                  text: submitButtonText,
                  onPressed: isLoading ? null : onSubmit,
                  isLoading: isLoading,
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthBackground extends StatelessWidget {
  final Widget child;
  final bool showLogo;

  const AuthBackground({
    Key? key,
    required this.child,
    this.showLogo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Constants.primaryLightColor,
            Constants.backgroundColor,
          ],
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Constants.spacingL),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showLogo) ...[
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              borderRadius: Constants.borderRadiusXXL,
                            ),
                            child: Icon(
                              Icons.event,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: Constants.spacingL),
                          Text(
                            'Metron',
                            style: Constants.headlineLarge.copyWith(
                              color: Constants.primaryColor,
                            ),
                          ),
                          SizedBox(height: Constants.spacingXS),
                          Text(
                            'Your event management platform',
                            style: Constants.bodyMedium.copyWith(
                              color: Constants.textSecondaryColor,
                            ),
                          ),
                          SizedBox(height: Constants.spacingXXL),
                        ],
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
