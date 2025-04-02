import 'package:flutter/material.dart';
import '../../config/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final Widget? leading;
  final Widget? titleWidget;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.leading,
    this.titleWidget,
    this.centerTitle = true,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? Text(title),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppTheme.primaryColor,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: elevation,
      shadowColor: Colors.black.withOpacity(0.2),
      automaticallyImplyLeading: showBackButton,
      leading:
          !showBackButton ? null : (leading ?? _defaultBackButton(context)),
      actions: actions,
      bottom: bottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppTheme.borderRadiusSmall),
        ),
      ),
    );
  }

  Widget _defaultBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios, size: 20),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}

// App bar with search
class SearchAppBar extends CustomAppBar {
  final TextEditingController searchController;
  final Function(String) onSearch;
  final String hintText;
  final VoidCallback? onClear;

  SearchAppBar({
    Key? key,
    required this.searchController,
    required this.onSearch,
    this.hintText = 'Search...',
    this.onClear,
    String title = '',
    bool showBackButton = true,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? foregroundColor,
    double elevation = 0,
  }) : super(
          key: key,
          title: title,
          showBackButton: showBackButton,
          actions: actions,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation,
          titleWidget: _buildSearchField(
            searchController,
            onSearch,
            hintText,
            onClear,
            foregroundColor ?? Colors.white,
            backgroundColor ?? AppTheme.primaryColor,
          ),
          centerTitle: false,
        );

  static Widget _buildSearchField(
    TextEditingController controller,
    Function(String) onSearch,
    String hintText,
    VoidCallback? onClear,
    Color foregroundColor,
    Color backgroundColor,
  ) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: TextField(
        controller: controller,
        onChanged: onSearch,
        style: TextStyle(color: foregroundColor),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: foregroundColor.withOpacity(0.7)),
          prefixIcon: Icon(
            Icons.search,
            color: foregroundColor.withOpacity(0.7),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: foregroundColor.withOpacity(0.7),
                  ),
                  onPressed: () {
                    controller.clear();
                    if (onClear != null) {
                      onClear();
                    } else {
                      onSearch('');
                    }
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}
