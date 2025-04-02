import 'package:flutter/material.dart';
import '../../config/theme.dart';

enum ButtonSize { small, medium, large }

enum ButtonVariant { filled, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonSize size;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.filled,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine padding based on size
    final EdgeInsets padding = _getPadding();

    // Determine text style based on size
    final TextStyle textStyle = _getTextStyle(context);

    // Build the button based on variant
    switch (variant) {
      case ButtonVariant.filled:
        return _buildFilledButton(context, padding, textStyle);
      case ButtonVariant.outlined:
        return _buildOutlinedButton(context, padding, textStyle);
      case ButtonVariant.text:
        return _buildTextButton(context, padding, textStyle);
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMedium,
          vertical: AppTheme.spacingSmall,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingXLarge,
          vertical: AppTheme.spacingMedium,
        );
      case ButtonSize.medium:
      default:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLarge,
          vertical: AppTheme.spacingMedium,
        );
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    final TextStyle baseStyle = switch (size) {
      ButtonSize.small => Theme.of(context).textTheme.bodyMedium!,
      ButtonSize.medium => Theme.of(context).textTheme.bodyLarge!,
      ButtonSize.large => Theme.of(context).textTheme.titleMedium!,
    };

    return baseStyle.copyWith(
      fontWeight: FontWeight.w600,
    );
  }

  Widget _buildFilledButton(
    BuildContext context,
    EdgeInsets padding,
    TextStyle textStyle,
  ) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.primaryColor,
          foregroundColor: textColor ?? Colors.white,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          ),
          elevation: AppTheme.elevationSmall,
        ),
        child: _buildButtonContent(textStyle),
      ),
    );
  }

  Widget _buildOutlinedButton(
    BuildContext context,
    EdgeInsets padding,
    TextStyle textStyle,
  ) {
    final Color color = backgroundColor ?? AppTheme.primaryColor;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? color,
          padding: padding,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          ),
        ),
        child: _buildButtonContent(textStyle),
      ),
    );
  }

  Widget _buildTextButton(
    BuildContext context,
    EdgeInsets padding,
    TextStyle textStyle,
  ) {
    final Color color = backgroundColor ?? AppTheme.primaryColor;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: textColor ?? color,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          ),
        ),
        child: _buildButtonContent(textStyle),
      ),
    );
  }

  Widget _buildButtonContent(TextStyle textStyle) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == ButtonVariant.filled
                ? Colors.white
                : AppTheme.primaryColor,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: AppTheme.spacingSmall),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(text, style: textStyle);
  }
}
