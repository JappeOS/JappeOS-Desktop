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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jappeos_desktop/system/desktop_cfg.dart';
import 'package:provider/provider.dart';

class DesktopMenu$UI extends StatefulWidget {
  double w;
  double h;
  double x;
  double y;
  bool fill;
  AlignmentGeometry align;
  Widget? body;

  DesktopMenu$UI(this.body, this.x, this.y, this.w, this.h, this.fill, this.align) : super(key: UniqueKey()) {}

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<DesktopMenu$UI> {
  static MenuState I = MenuState();

  // The border radius of the window
  final double _borderRadius = 10.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.align,
      decoration: BoxDecoration(
        borderRadius: widget.fill ? BorderRadius.zero : BorderRadius.all(Radius.circular(_borderRadius)),
      ),
      child: ClipRRect(
        borderRadius: widget.fill ? BorderRadius.zero : BorderRadius.all(Radius.circular(_borderRadius)),
        child: Stack(
          children: [
            Column(
              children: [_getBody()],
            ),
          ],
        ),
      ),
    );
  }

  // The body of the window.
  _getBody() {
    return Container(
      width: widget.fill ? MediaQuery.of(context).size.width : widget.w,
      height: widget.fill ? MediaQuery.of(context).size.height - 30 : widget.h,
      color: Colors.transparent,
      child: blurContainer(
        widget.body!,
      ),
    );
  }

  // Blur effects
  /// A blurry container widget that can be used to render background blur on the window.
  ///
  /// Parameters:
  /// ```dart
  /// - Widget child // The widget inside this widget.
  /// ```
  Widget blurContainer(Widget child) {
    final themeColorGetters = Provider.of<DesktopCfg$ThemeColorGetters>(context);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
        child: Container(
          width: widget.w,
          height: widget.h,
          color: themeColorGetters.getBackgroundColor(context, DesktopCfg$BackgroundColorType.normal),
          child: child,
        ),
      ),
    );
  }
}