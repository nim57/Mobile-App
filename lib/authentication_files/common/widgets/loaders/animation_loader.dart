import 'package:echo_project_123/Utils/constants/colors.dart';
import 'package:echo_project_123/Utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A widget that displays a Lottie animation with text and an optional action button.
class EAnimationLoaderWidget extends StatelessWidget {
  /// Default constructor for the EAnimationLoaderWidget.
  ///
  /// Parameters:
  /// - [text]: The text to be displayed below the animation.
  /// - [animation]: The path to the Lottie animation file.
  /// - [showAction]: Whether to show an action button below the text.
  /// - [actionText]: The text to be displayed on the action button.
  /// - [onActionPressed]: Callback function to be executed when the action button is pressed.
  const EAnimationLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText = '',
    this.onActionPressed,
  });

  final String text;
  final String animation;
  final bool showAction;
  final String actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            animation,
            width: MediaQuery.of(context).size.width * 0.8,
          ),
          const SizedBox(height: ESizes.defaultSpace),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ESizes.defaultSpace),
          if (showAction)
            SizedBox(
              width: 250,
              child: OutlinedButton(
                onPressed: onActionPressed,
                style: OutlinedButton.styleFrom(
                  backgroundColor: EColor.dark,
                ),
                child: Text(
                  actionText,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: EColor.light),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
