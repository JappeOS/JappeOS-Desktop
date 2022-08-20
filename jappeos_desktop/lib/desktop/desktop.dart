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

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:jappeos_desktop/applications/settings/main.dart';
import 'package:jappeos_desktop/applications/terminal/main.dart';
import 'package:jappeos_desktop/applications/widgetTesting/main.dart';
import 'package:jappeos_desktop/desktop/desktopMenuManager/dMenuController.dart';
import 'package:jappeos_desktop/desktop/desktopMenuManager/dMenuManager.dart';
import 'package:jappeos_desktop/system/appSystem/applications.dart';
import 'package:jappeos_desktop/system/desktopCfg.dart';
import 'package:jappeos_desktop/system/widgets/basic/textField/normalTextFields.dart';

import '../windowManager/wmcontroller.dart';
import '../windowManager/wmmanager.dart';

/// The stateful widget for the base desktop UI.
///
/// Made by Jappe. (2022)
class Desktop extends StatefulWidget {
  Desktop({Key? key}) : super(key: key);

  @override
  DesktopState createState() => DesktopState();
}

/// This is the public class for the JappeOS Desktop, the `wmController` object can be accessed for using the windowing system.
///
/// See [WmController] for more information on the windowing system.
///
/// Made by Jappe. (2022)
class DesktopState extends State<Desktop> {
  // Create a new instance of [WmController].
  static WmController? _wmController;
  static WmController? getWmController() {
    return _wmController;
  }

  // Create a new instance of [DesktopMenu$Controller].
  static DesktopMenu$Controller? _desktopMenuController;

  // The padding on the left and right side of the TopBar element.
  final double _TOP_BAR_sidePadding = 5;

  // The icon size for Icons on the TopBar buttons.
  final double _TOP_BAR_buttonIconSize = 17;

  // The icon/text color for TopBar buttons.
  //final Color _TOP_BAR_buttonOverlayColor = Colors.white;

  // The default border radius for _blurContainer elements.
  final double _G_borderRadius = 10;

  @override
  void initState() {
    super.initState();

    _wmController = WmController(() {
      setState(() {});
    });

    _desktopMenuController = DesktopMenu$Controller(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TopBar item content color.
    Color _topBarItemContentColor = DesktopCfg.DESKTOPCFG_INSTANCE.isDarkMode(context)
        ? DesktopCfg.DESKTOPCFG_INSTANCE.dsktp_TEXT_COLOR_DARK
        : DesktopCfg.DESKTOPCFG_INSTANCE.dsktp_TEXT_COLOR_LIGHT;

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            // The desktop background image.
            image: AssetImage(DesktopCfg.DESKTOPCFG_INSTANCE.dsktpWallpaper),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // The window layer of the desktop UI.
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                child: Stack(
                  children: [
                    WmManager(
                      wmController: _wmController,
                    ),
                  ],
                ),
              ),
            ),

            // The desktop-menu layer of the desktop.
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                child: Stack(
                  children: [
                    DesktopMenu$Manager(
                      dmController: _desktopMenuController,
                    ),
                  ],
                ),
              ),
            ),

            // The dock shown in the bottom of the dekstop UI.
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[_basicShadow()],
                  borderRadius: BorderRadius.all(Radius.circular(_G_borderRadius)),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: IntrinsicWidth(
                  child: _blurContainer(
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,

                        // The items shown in the dock.
                        children: [
                          _dockItem(null, null, false, () {
                            Applications.sys$runProcess(new Settings());
                          }),
                          _dockItem(null, null, false, () {
                            Applications.sys$runProcess(new WidgetTesting());
                          }),
                          _dockItem(null, null, false, () {
                            Applications.sys$runProcess(new Terminal());
                          }),
                          _dockItem(null, null, false, () {}),
                        ],
                      ),
                      true),
                ),
              ),
            ),

            // This is the TopBar, it's shown on the top of the desktop UI.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 30,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[_basicShadow()],
                ),
                child: _blurContainer(
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: _TOP_BAR_sidePadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            // The items on the TopBar on the left side.
                            children: [
                              // Launcher button.
                              _topBarItem(
                                null,
                                () {
                                  _desktopMenuController?.openDesktopOverlayMenu(DesktopMenu$Menus.Launcher);
                                },
                                true,
                                new Container(
                                  child: Icon(
                                    Icons.apps,
                                    size: _TOP_BAR_buttonIconSize,
                                    color: _topBarItemContentColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              // TaskView button.
                              _topBarItem(
                                  null,
                                  () {},
                                  true,
                                  new Container(
                                    child: Icon(
                                      Icons.menu_open,
                                      size: _TOP_BAR_buttonIconSize,
                                      color: _topBarItemContentColor,
                                    ),
                                  )),
                              SizedBox(width: 5),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: _TOP_BAR_sidePadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,

                            // The items on the TopBar on the right side.
                            children: [
                              // System tray buttons.
                              _topBarItem(
                                  null,
                                  () {},
                                  true,
                                  new Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.mic,
                                          size: _TOP_BAR_buttonIconSize,
                                          color: _topBarItemContentColor,
                                        ),
                                        SizedBox(width: 3),
                                        Icon(
                                          Icons.camera,
                                          size: _TOP_BAR_buttonIconSize,
                                          color: _topBarItemContentColor,
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(width: 5),
                              // QuickSettings button.
                              _topBarItem(
                                  null,
                                  () {},
                                  true,
                                  new Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.wifi,
                                          size: _TOP_BAR_buttonIconSize,
                                          color: _topBarItemContentColor,
                                        ),
                                        SizedBox(width: 3),
                                        Icon(
                                          Icons.volume_mute,
                                          size: _TOP_BAR_buttonIconSize,
                                          color: _topBarItemContentColor,
                                        ),
                                        SizedBox(width: 3),
                                        Icon(
                                          Icons.battery_full,
                                          size: _TOP_BAR_buttonIconSize,
                                          color: _topBarItemContentColor,
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(width: 5),
                              // Notifications and Time&Date button.
                              _topBarItem(
                                null,
                                () {},
                                true,
                                new Container(
                                  child: Row(
                                    children: [
                                      Text('19:00',
                                          style: TextStyle(
                                            color: _topBarItemContentColor,
                                          )),
                                      SizedBox(width: 3),
                                      Icon(
                                        Icons.notifications,
                                        size: _TOP_BAR_buttonIconSize,
                                        color: _topBarItemContentColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Blur effects
  Widget _blurContainer(Widget child, bool radius) {
    final BackdropFilter _bf = new BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 4,
        child: child,
        decoration: BoxDecoration(
          color: DesktopCfg.DESKTOPCFG_INSTANCE.isDarkMode(context)
              ? DesktopCfg.DESKTOPCFG_INSTANCE.dsktp_BLUR_COLOR_DARK
              : DesktopCfg.DESKTOPCFG_INSTANCE.dsktp_BLUR_COLOR_LIGHT,
        ),
      ),
    );

    if (radius) {
      return ClipRRect(
        child: _bf,
        borderRadius: BorderRadius.all(Radius.circular(_G_borderRadius)),
      );
    } else {
      return ClipRRect(
        child: _bf,
      );
    }
  }

  // Top Bar Item
  Widget _topBarItem(String? text, Function()? onPressed, bool custom, Widget? customWidget) {
    if (!custom) {
      return Container(
        child: TextButton(
            child: Text(text ?? "",
                style: TextStyle(
                  color: DesktopCfg.DESKTOPCFG_INSTANCE.isDarkMode(context)
                      ? DesktopCfg.DESKTOPCFG_INSTANCE.dsktp_TEXT_COLOR_DARK
                      : DesktopCfg.DESKTOPCFG_INSTANCE.dsktp_TEXT_COLOR_LIGHT,
                )),
            style: TextButton.styleFrom(
              minimumSize: Size(30, 30),
              padding: EdgeInsets.all(6),
              enabledMouseCursor: SystemMouseCursors.alias,
              disabledMouseCursor: SystemMouseCursors.alias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_G_borderRadius),
              ),
            ),
            onPressed: onPressed),
      );
    } else {
      return Container(
        child: TextButton(
            child: customWidget ?? new Container(),
            style: TextButton.styleFrom(
              minimumSize: Size(30, 30),
              padding: EdgeInsets.all(6),
              enabledMouseCursor: SystemMouseCursors.alias,
              disabledMouseCursor: SystemMouseCursors.alias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_G_borderRadius),
              ),
            ),
            onPressed: onPressed),
      );
    }
  }

  // Dock Item
  Widget _dockItem(ImageProvider? img, IconData? icon, bool isIcon, Function() onPressed) {
    if (!isIcon) {
      return _dockItemBase(
          Image(
            image: img ?? AssetImage("lib/images/null.png"),
          ),
          onPressed);
    } else {
      return _dockItemBase(
          Icon(
            icon,
            size: 40,
          ),
          onPressed);
    }
  }

  Widget _dockItemBase(Widget child, Function() onPressed) {
    return Container(
      width: 70,
      height: 70,
      margin: EdgeInsets.all(5),
      child: TextButton(
          child: child,
          onPressed: onPressed,
          style: TextButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.alias,
            disabledMouseCursor: SystemMouseCursors.alias,
            padding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_G_borderRadius),
            ),
          )),
    );
  }

  // Shadow element for TopBar and the Dock.
  BoxShadow _basicShadow() {
    return BoxShadow(
      color: Colors.black,
      offset: Offset(0, 0),
      blurRadius: 10.0,
    );
  }
}

/// Contains the overlay menus for the desktop UI, for example, the launcher.
///
/// Menus:
/// - 0 = Launcher
/// - 1 = TaskView
/// - 2 = QuickSettings
///
/// Made by Jappe. (2022)
class DesktopOverlayMenus extends StatelessWidget {
  DesktopMenu$Menus menu = DesktopMenu$Menus.Launcher;

  DesktopOverlayMenus(DesktopMenu$Menus menu) {
    this.menu = menu;
  }

  late BuildContext uContext;

  @override
  Widget build(BuildContext context) {
    uContext = context;

    switch (this.menu) {
      case DesktopMenu$Menus.Launcher:
        return _launcher();
      case DesktopMenu$Menus.TaskView:
        return _taskView();
      case DesktopMenu$Menus.QuickSettings:
        return _quickSettings();
    }
  }

  // The UI for the launcher.
  Widget _launcher() {
    double width = 1200;

    return new Column(
      children: [
        // Search bar.
        Container(
          width: width,
          height: 50,
          margin: EdgeInsets.only(top: 50),
          padding: EdgeInsets.only(left: 100, right: 100, top: 6),
          color: Colors.red,
          child: UI_NormalTextFields_TextField(
            hintText: "Search apps...",
            autoFocus: true,
          ),
        ),

        // App view.
        Container(
          width: width,
          height: MediaQuery.of(uContext).size.height - 350,
          margin: EdgeInsets.only(top: 25, bottom: 25),
          color: Colors.green,
        ),

        // Buttons.
        Container(
          width: width,
          height: 50,
          color: Colors.blue,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Row(children: [
                OutlinedButton(
                  child: Icon(
                    Icons.power,
                    color: DesktopCfg.DESKTOPCFG_INSTANCE.getCurrentJappeOsAccentColorAsColor(uContext),
                  ),
                  style: OutlinedButton.styleFrom(
                    primary: DesktopCfg.DESKTOPCFG_INSTANCE.getCurrentJappeOsAccentColorAsColor(uContext),
                    backgroundColor: DesktopCfg.DESKTOPCFG_INSTANCE.isDarkMode(uContext) ? DesktopCfg.DESKTOPCFG_INSTANCE.dsktp_BG_COLOR_DARK_SECONDARY.withOpacity(0.5) : DesktopCfg.DESKTOPCFG_INSTANCE.dsktp_BG_COLOR_LIGHT_SECONDARY.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.0, style: BorderStyle.none),
                      borderRadius: BorderRadius.zero,
                    ),
                    enabledMouseCursor: SystemMouseCursors.alias,
                    disabledMouseCursor: SystemMouseCursors.alias,
                  ),
                  onPressed: () {},
                ),
              ],),
            ),
          ),
        ),
      ],
    );
  }

  // The UI for the taskView.
  Widget _taskView() {
    return new Container();
  }

  // The UI for the quickSettings.
  Widget _quickSettings() {
    return new Container();
  }
}
