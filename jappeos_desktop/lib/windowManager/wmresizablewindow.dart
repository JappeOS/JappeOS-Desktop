//  JappeOS-Desktop, The desktop environment for JappeOS.
//  Copyright (C) 2022  Jappe02
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

// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jappeos_desktop/windowManager/windowTypes/wm_window_general.dart';
import 'package:jappeos_desktop_ui/widgets/blur_container.dart';
import 'package:jappeos_desktop_ui/widgets/solid_container.dart';
import 'package:provider/provider.dart';
import 'package:shade_theming/main.dart';

/// This is the window [Widget] that every application can instantiate.
class Window extends StatefulWidget {
  // Window Properties & Info
  late List<Widget> window;
  late bool applyBlur;
  late bool isResizable;
  late bool hasControlButtons;
  late bool close;
  late WMWindowSize windowSizeProp;
  WMWindowDragAreaProperties? dragAreaProperties;

  // Current Window States
  double x = 0, y = 0;
  double prevX = 0, prevY = 0;
  double w = 0, h = 0;
  double prevW = 0, prevH = 0;
  bool isMaximized = false;

  Function(double, double)? onWindowDragged;
  VoidCallback? onCloseButtonClicked;

  final WMWindowType windowType;

  Window(this.windowType) : super(key: UniqueKey()) {
    window = windowType.getWindow();
    applyBlur = windowType.applyBlur();
    isResizable = windowType.isResizable();
    hasControlButtons = windowType.hasControlButtons();
    dragAreaProperties = windowType.getDragAreaProperties();
    windowSizeProp = windowType.getSizeProperties();

    w = windowSizeProp.defaultSize.width;
    h = windowSizeProp.defaultSize.height;

    _closeTimer();
  }

  // ignore: unused_field
  late Timer _timer; // TODO Use something better than a timer for this; timer = laggy.
  void _closeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      close = windowType.close();
      if (close) onCloseButtonClicked!();
      _closeTimer();
    });
  }

  @override
  WindowState createState() => WindowState();
}

class WindowState extends State<Window> {
  @override
  Widget build(BuildContext context) {
    // Width and height
    if (widget.w < widget.windowSizeProp.minimumSize.width) {
      widget.w = widget.windowSizeProp.minimumSize.width;
    } else if (widget.h < widget.windowSizeProp.minimumSize.height) {
      widget.h = widget.windowSizeProp.minimumSize.height;
    }

    List<Widget> baseChildren = [];

    Widget base(Widget child) {
      if (widget.applyBlur) {
        return DeuiBlurContainer(
          reducedRadius: true,
          gradient: true,
          bordered: !widget.isMaximized,
          width: widget.w,
          height: widget.h,
          radiusSides: !widget.isMaximized ? BorderRadiusSides(true, true, true, true) : BorderRadiusSides(false, false, false, false),
          child: child,
        );
      } else {
        return DeuiSolidContainer(
          reducedRadius: true,
          bordered: !widget.isMaximized,
          width: widget.w,
          height: widget.h,
          radiusSides: !widget.isMaximized ? BorderRadiusSides(true, true, true, true) : BorderRadiusSides(false, false, false, false),
          child: child,
        );
      }
    }

    baseChildren.addAll(widget.window);

    // Drag area
    if (widget.dragAreaProperties != null) {
      baseChildren.add(_getDragArea());
    }

    // Window controls
    baseChildren.add(
      Positioned(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: widget.hasControlButtons
              ? [
                  _getWindowControlButton(context, Icons.minimize, () {}),
                  if (widget.isResizable)
                    _getWindowControlButton(context, !widget.isMaximized ? Icons.crop_square : Icons.fullscreen_exit, () {
                      if (widget.isMaximized) {
                        _statefuncOnRestore();
                      } else {
                        _statefuncOnMaximize();
                      }
                    }),
                  _getWindowControlButton(context, Icons.close, () {
                    widget.onCloseButtonClicked!();
                  }),
                  const SizedBox(
                    width: 5,
                  ),
                ]
              : [],
        ),
      ),
    );

    // Resize areas
    if (widget.isResizable && !widget.isMaximized) {
      baseChildren.addAll([
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: GestureDetector(
            onHorizontalDragUpdate: _resizefuncOnHorizontalDragRight,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              opaque: true,
              child: Container(
                width: 4,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: GestureDetector(
            onHorizontalDragUpdate: _resizefuncOnHorizontalDragLeft,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              opaque: true,
              child: Container(
                width: 4,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: GestureDetector(
            onVerticalDragUpdate: _resizefuncOnHorizontalDragTop,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeUpDown,
              opaque: true,
              child: Container(
                height: 4,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onVerticalDragUpdate: _resizefuncOnHorizontalDragBottom,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeUpDown,
              opaque: true,
              child: Container(
                height: 4,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onPanUpdate: _resizefuncOnHorizontalDragBottomRight,
            child: const MouseRegion(
              cursor: SystemMouseCursors.resizeUpLeftDownRight,
              opaque: true,
              child: SizedBox(
                height: 6,
                width: 6,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: GestureDetector(
            onPanUpdate: _resizefuncOnHorizontalDragBottomLeft,
            child: const MouseRegion(
              cursor: SystemMouseCursors.resizeUpRightDownLeft,
              opaque: true,
              child: SizedBox(
                height: 6,
                width: 6,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onPanUpdate: _resizefuncOnHorizontalDragTopRight,
            child: const MouseRegion(
              cursor: SystemMouseCursors.resizeUpRightDownLeft,
              opaque: true,
              child: SizedBox(
                height: 6,
                width: 6,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: GestureDetector(
            onPanUpdate: _resizefuncOnHorizontalDragTopLeft,
            child: const MouseRegion(
              cursor: SystemMouseCursors.resizeUpLeftDownRight,
              opaque: true,
              child: SizedBox(
                height: 6,
                width: 6,
              ),
            ),
          ),
        ),
      ]);
    }

    return SizedBox(
      child: base(
        Stack(
          children: baseChildren,
        ),
      ),
    );
  }

  Widget _getDragArea() {
    return Positioned(
      left: widget.dragAreaProperties!.x,
      top: widget.dragAreaProperties!.y,
      width: widget.dragAreaProperties!.w == -1 ? widget.w - widget.dragAreaProperties!.x : widget.dragAreaProperties!.w,
      height: widget.dragAreaProperties!.h == -1 ? WMWindowDragAreaProperties.getDefaultH() : widget.dragAreaProperties!.h,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          if (widget.isMaximized) {
            _statefuncOnRestore();
          } else {
            widget.onWindowDragged!(tapInfo.delta.dx, tapInfo.delta.dy);

            if (widget.y < 5) {
              widget.y = 5;
            }
          }
        },
        onTap: () {
          widget.onWindowDragged!(0, 0);
        },
      ),
    );
  }

  Widget _getWindowControlButton(BuildContext context, IconData icon, Function()? onPress) {
    return Container(
      width: 33,
      height: 33,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: onPress,
            child: Icon(
              icon,
              color: context.watch<ShadeThemeProvider>().getCurrentThemeProperties().normalTextColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  // FUNCTIONS
  void _resizefuncOnHorizontalDragLeft(DragUpdateDetails details) {
    bool maximized = widget.isMaximized;
    setState(() {
      if (maximized) _statefuncOnRestore();
      widget.w -= details.delta.dx;
      if (widget.w < widget.windowSizeProp.minimumSize.width) {
        widget.w = widget.windowSizeProp.minimumSize.width;
      } else {
        widget.onWindowDragged!(details.delta.dx, 0);
      }
    });
  }

  void _resizefuncOnHorizontalDragRight(DragUpdateDetails details) {
    bool maximized = widget.isMaximized;
    setState(() {
      if (maximized) _statefuncOnRestore();
      widget.w += details.delta.dx;
      if (widget.w < widget.windowSizeProp.minimumSize.width) {
        widget.w = widget.windowSizeProp.minimumSize.width;
      }
    });
  }

  void _resizefuncOnHorizontalDragBottom(DragUpdateDetails details) {
    bool maximized = widget.isMaximized;
    setState(() {
      if (maximized) _statefuncOnRestore();
      widget.h += details.delta.dy;
      if (widget.h < widget.windowSizeProp.minimumSize.height) {
        widget.h = widget.windowSizeProp.minimumSize.height;
      }
    });
  }

  void _resizefuncOnHorizontalDragTop(DragUpdateDetails details) {
    bool maximized = widget.isMaximized;
    setState(() {
      if (maximized) _statefuncOnRestore();
      widget.h -= details.delta.dy;
      if (widget.h < widget.windowSizeProp.minimumSize.height) {
        widget.h = widget.windowSizeProp.minimumSize.height;
      } else {
        widget.onWindowDragged!(0, details.delta.dy);
      }
    });
  }

  void _resizefuncOnHorizontalDragBottomRight(DragUpdateDetails details) {
    _resizefuncOnHorizontalDragRight(details);
    _resizefuncOnHorizontalDragBottom(details);
  }

  void _resizefuncOnHorizontalDragBottomLeft(DragUpdateDetails details) {
    _resizefuncOnHorizontalDragLeft(details);
    _resizefuncOnHorizontalDragBottom(details);
  }

  void _resizefuncOnHorizontalDragTopRight(DragUpdateDetails details) {
    _resizefuncOnHorizontalDragRight(details);
    _resizefuncOnHorizontalDragTop(details);
  }

  void _resizefuncOnHorizontalDragTopLeft(DragUpdateDetails details) {
    _resizefuncOnHorizontalDragLeft(details);
    _resizefuncOnHorizontalDragTop(details);
  }

  void _statefuncOnMaximize() {
    if (!widget.isResizable) return;
    setState(() {
      widget.prevW = widget.w;
      widget.prevH = widget.h;
      widget.prevX = widget.x;
      widget.prevY = widget.y;
      widget.w = MediaQueryData.fromView(WidgetsBinding.instance.window).size.width + 2;
      widget.h = MediaQueryData.fromView(WidgetsBinding.instance.window).size.height - 30 + 2;
      widget.x = -1;
      widget.y = -1;
      widget.onWindowDragged!(0, 30);
      widget.isMaximized = true;
    });
  }

  void _statefuncOnRestore() {
    if (!widget.isResizable) return;
    setState(() {
      widget.w = widget.prevW;
      widget.h = widget.prevH;
      widget.x = widget.prevX;
      widget.y = widget.prevY;
      widget.onWindowDragged!(0, 0);
      widget.isMaximized = false;
    });
  }
}
