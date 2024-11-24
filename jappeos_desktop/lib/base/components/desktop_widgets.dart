//  JappeOS-Desktop, The desktop environment for JappeOS.
//  Copyright (C) 2024  Jappe02
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

// ignore_for_file: library_private_types_in_public_api

part of jappeos_desktop.base;

/// A basic widget that has the logo of an app and also the name below.
class DApplicationItem extends StatefulWidget {
  final SvgPicture image;
  final String? title;
  final void Function()? onPress;

  const DApplicationItem._({
    Key? key,
    required this.image,
    this.title,
    this.onPress,
  }) : super(key: key);

  factory DApplicationItem.icon({required SvgPicture image, void Function()? onPress}) {
    return DApplicationItem._(image: image, onPress: onPress);
  }

  factory DApplicationItem.iconWithTitle({required SvgPicture image, required String? title, void Function()? onPress}) {
    return DApplicationItem._(image: image, title: title, onPress: onPress);
  }

  @override
  _DApplicationItemState createState() => _DApplicationItemState();
}

class _DApplicationItemState extends State<DApplicationItem> {
  bool isHovered = false, isPressed = false;
  //final borderRad = BorderRadius.circular(BPPresets.small);
  //final borderWidth = 1.0;
//
  //late final width = widget.title != null ? 90.0 : 80.0;
  //late final height = widget.title != null ? 100.0 : 80.0;

  @override
  Widget build(BuildContext context) {
    //return Container(
    //  height: 100,
    //  width: 90,
    //  decoration: BoxDecoration(
    //    borderRadius: BorderRadius.circular(JappeOsDesktopUI.getDefaultBorderRadiusRedc()),
    //    // Only show border when hovering.
    //    border: isHovering
    //        ? Border.all(
    //            width: JappeOsDesktopUI.theme_defaultBorderSize(),
    //            color: JappeOsDesktopUI.theme_customBorderColor(context),
    //          )
    //        : null,
    //    //color: SHUI_THEME_PROPERTIES(ctx).backgroundColor1.withOpacity(SHUI_OPTIMAL_ELEMENT_OPACITY),
    //  ),
    //  child: Material(
    //    color: Colors.transparent,
    //    child: InkWell(
    //      mouseCursor: SystemMouseCursors.alias,
    //      hoverColor: Theme.of(context).colorScheme.background.withOpacity(0.1),
    //      splashColor: Theme.of(context).colorScheme.background.withOpacity(0.25),
    //      highlightColor: Theme.of(context).colorScheme.background.withOpacity(0.1),
    //      borderRadius: BorderRadius.circular(JappeOsDesktopUI.getDefaultBorderRadiusRedc()),
    //      onHover: (value) => setState(() => isHovering = value),
    //      onTap: widget.onPress,
    //      child: Padding(
    //        padding: const EdgeInsets.all(5),
    //        child: Column(
    //          children: [
    //            // The image/logo of app.
    //            Expanded(child: widget.image),
    //            // The name of the app.
    //            Text(
    //              widget.title,
    //              style: TextStyle(color: Theme.of(context).textTheme.labelMedium?.color, shadows: const [Shadow(blurRadius: 3)]),
    //            ),
    //          ],
    //        ),
    //      ),
    //    ),
    //  ),
    //);
    /*
    final accentColor = Theme.of(context).colorScheme.primary;
    //final borderColor = Theme.of(context).colorScheme.outline;

    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        //borderRadius: borderRad,
        color: Colors.transparent,
        //border: isHovered ? Border.all(width: borderWidth, color: borderColor) : Border.all(width: borderWidth, color: Colors.transparent),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          mouseCursor: SystemMouseCursors.alias,
          hoverColor: Theme.of(context).textButtonTheme.style!.overlayColor!.resolve({MaterialState.hovered}),
          splashColor: Theme.of(context).textButtonTheme.style!.overlayColor!.resolve({MaterialState.pressed}),
          highlightColor: accentColor.withOpacity(0.1),
          //borderRadius: borderRad,
          onTap: widget.onPress,
          onHover: (value) => setState(() {
            isHovered = value;
          }),
          child: Column(
            children: [
              Expanded(child: widget.image),
              if (widget.title != null) ...[
                const SizedBox(height: BPPresets.small),
                Tooltip(message: widget.title, child: Text(widget.title!, overflow: TextOverflow.ellipsis, maxLines: 1)),
              ]
            ],
          ),
        ),
      ),
    );*/

    return SizedBox(
      width: 80,
      child: MouseRegion(
        onEnter: (p0) => setState(() => isHovered = true),
        onExit: (p0) => setState(() => isHovered = false),
        child: GestureDetector(
          onTap: widget.onPress,
          onTapDown: (p0) => setState(() => isPressed = true),
          onTapUp: (p0) => setState(() => isPressed = false),
          onTapCancel: () => setState(() => isPressed = false),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 75,
                height: 75,
                child: Stack(children: [
                  Positioned.fill(
                    child: AnimatedScale(
                      scale: isHovered ? 1 : 0.75,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 75),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isHovered ? Theme.of(context).colorScheme.onSurface.withOpacity(0.1) : null,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedScale(
                      scale: isPressed ? 0.7 : 0.8,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 75),
                      child: widget.image,
                    ),
                  ),
                ],),
              ),
              if (widget.title != null) ...[
                const SizedBox(height: BPPresets.small),
                Tooltip(message: widget.title, child: Text(widget.title!, overflow: TextOverflow.ellipsis, maxLines: 1)),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

/// A wrapper around [AdvancedContainer] that is used for the overlays and menus of the desktop.
class DOverlayContainer extends StatelessWidget {
  final double? width, height;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const DOverlayContainer({super.key, required this.child, this.width, this.height, this.padding});

  @override
  Widget build(BuildContext context) {
    return AdvancedContainer(
      width: width,
      height: height,
      padding: padding,
      background: AdvancedContainerBackground.transparentBackground,
      borderStyle: AdvancedContainerBorder.double,
      borderRadius: BPPresets.medium,
      blur: true,
      child: child,
    );
  }
}

/// A topbar button that opens a desktop menu.
class DTopbarButton extends StatefulWidget {
  final String? title;
  final List<Widget> children;
  final DesktopMenuController menuControllerRef;
  final DesktopMenu menu;

  final AlignmentGeometry alignment;

  const DTopbarButton._(
      {Key? key, this.title, this.children = const [], required this.menuControllerRef, required this.menu, this.alignment = Alignment.center})
      : super(key: key);

  factory DTopbarButton.text({
    required String text,
    required DesktopMenuController menuControllerRef,
    required DesktopMenu menu,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return DTopbarButton._(
      menuControllerRef: menuControllerRef,
      menu: menu,
      alignment: alignment,
      title: text,
    );
  }

  factory DTopbarButton.icon({
    required IconData icon,
    required DesktopMenuController menuControllerRef,
    required DesktopMenu menu,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return DTopbarButton._(
      menuControllerRef: menuControllerRef,
      menu: menu,
      alignment: alignment,
      children: [Icon(icon)],
    );
  }

  factory DTopbarButton.icons({
    required List<IconData> icons,
    required DesktopMenuController menuControllerRef,
    required DesktopMenu menu,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return DTopbarButton._(
      menuControllerRef: menuControllerRef,
      menu: menu,
      alignment: alignment,
      children: [
        for (var icon in icons) Icon(icon),
      ],
    );
  }

  factory DTopbarButton.textAndIcon({
    required String text,
    required IconData icon,
    required DesktopMenuController menuControllerRef,
    required DesktopMenu menu,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return DTopbarButton._(
      menuControllerRef: menuControllerRef,
      menu: menu,
      alignment: alignment,
      title: text,
      children: [Icon(icon)],
    );
  }

  @override
  _DTopbarButtonState createState() => _DTopbarButtonState();
}

class _DTopbarButtonState extends State<DTopbarButton> {
  Offset globalPosition = Offset.zero;

  bool hovering = false;
  final borderRad = BorderRadius.circular(100);
  final borderWidth = 1.0;

  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.primary;
    final borderColor = Theme.of(context).colorScheme.outline;
    final splashColor = accentColor.withOpacity(0.25);

    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, top: 2),
      alignment: widget.alignment,
      height: 26,
      decoration: BoxDecoration(
        borderRadius: borderRad,
        color: Colors.transparent,
        border:
            hovering || isMenuOpen ? Border.all(width: borderWidth, color: borderColor) : Border.all(width: borderWidth, color: Colors.transparent),
      ),
      child: RepaintBoundary(
        child: Builder(
          builder: (context) {
            // Add a post frame callback to ensure the widget has been laid out
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Get the RenderBox of the widget
              final renderBox = context.findRenderObject() as RenderBox;

              // Get the global position of the widget
              final global = renderBox.localToGlobal(Offset.zero);
              globalPosition = Offset(global.dx + renderBox.size.width / 2, global.dy);
            });

            return Material(
              color: isMenuOpen ? splashColor : Colors.transparent,
              borderRadius: borderRad,
              child: InkWell(
                mouseCursor: SystemMouseCursors.alias,
                hoverColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
                splashColor: splashColor,
                highlightColor: accentColor.withOpacity(0.1),
                overlayColor: WidgetStatePropertyAll(splashColor.withOpacity(0.175)),
                borderRadius: borderRad,
                onTap: () {
                  setState(() => isMenuOpen = true);
                  widget.menuControllerRef.openMenu(
                    widget.menu,
                    position: globalPosition,
                    closeCallback: () {
                      setState(() => isMenuOpen = false);
                    },
                  );
                },
                onHover: (value) => setState(() {
                  hovering = value;
                }),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.title != null) Text(widget.title!),
                      ...widget.children,
                    ],
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

/// A background widget for desktop menus.
class DMenuBackground extends StatelessWidget {
  final Widget child;
  final double? width, height;

  const DMenuBackground({Key? key, required this.child, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdvancedContainer(
      width: width,
      height: height,
      borderStyle: AdvancedContainerBorder.double,
      background: AdvancedContainerBackground.transparentBackground,
      blur: true,
      borderRadius: BPPresets.medium,
      child: child,
    );
  }
}

/// A pressable widget that shows a window's contents along with it's title.
class DWindowView extends StatefulWidget {
  final String title;
  final bool isHighlighted;
  final Image? image;
  final double aspectRatio;
  final double height;
  final void Function()? onPress;
  final bool isTitleEditable;
  final void Function(String)? onTitleEdited;
  final Widget Function(bool isHovered)? child;

  const DWindowView({
    Key? key,
    required this.title,
    this.isHighlighted = false,
    this.image,
    this.aspectRatio = 250 / 170,
    this.height = 170,
    this.onPress,
    this.isTitleEditable = false,
    this.onTitleEdited,
    this.child,
  }) : super(key: key);

  @override
  _DWindowViewState createState() => _DWindowViewState();
}

class _DWindowViewState extends State<DWindowView> {
  static const kBorderRadius = BPPresets.medium;

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final width = widget.height * widget.aspectRatio;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: width,
          height: widget.height,
          child: ShadeSelectionBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            onHover: (p0) => setState(() => isHovered = p0),
            isHighlighted: widget.isHighlighted,
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              child: InkWell(
                mouseCursor: SystemMouseCursors.alias,
                splashColor: Theme.of(context).splashColor,
                onTap: widget.onPress,
                child: widget.child?.call(isHovered),
              ),
            ),
          ),
        ),
        const SizedBox(height: BPPresets.small),
        if (widget.isTitleEditable)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width,
            ),
            child: IntrinsicWidth(child: ShadeEditableTextWidget(initialText: widget.title, onEditingComplete: widget.onTitleEdited, hintText: "Type Something...")),
          )
        else ...[
          const SizedBox(height: 11 / 2),
          Text(widget.title, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 11 / 2),
        ]
      ],
    );
  }
}
