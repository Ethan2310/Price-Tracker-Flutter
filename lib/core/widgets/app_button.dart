import 'package:flutter/material.dart';

enum AppButtonVariant { primary, outline }

/// A standardised button used throughout the app.
///
/// - [variant] switches between a filled primary button and a bordered outline button.
/// - Set [isLoading] to `true` to replace the label with a spinner (and disable taps).
/// - Supply an optional [icon] to show a leading icon beside the label.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: variant == AppButtonVariant.primary
                  ? colorScheme.onPrimary
                  : colorScheme.primary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
      AppButtonVariant.outline => OutlinedButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
    };

    if (width != null) {
      button = SizedBox(width: width, child: button);
    }

    return button;
  }
}
