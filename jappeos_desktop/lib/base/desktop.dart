//  JappeOS-Desktop, The desktop environment for JappeOS.
//  Copyright (C) 2023  Jappe02
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

// ignore_for_file: constant_identifier_names, non_constant_identifier_names

part of jappeos_desktop.base;

/// The stateful widget for the base desktop UI.
class Desktop extends StatefulWidget {
  const Desktop({Key? key}) : super(key: key);

  @override
  DesktopState createState() => DesktopState();
}

/// This is the public class for the JappeOS Desktop, the `wmController` object can be accessed for using the windowing system.
///
/// See [WmController] for more information on the windowing system.
class DesktopState extends State<Desktop> {
  static WindowStackController? _wmController;
  static WindowStackController? getWmController() => _wmController;

  /// Whether to render GUI on the desktop or not, if false, only the WM windows will be rendered.
  static bool renderGUI = true;

  late final DesktopMenuController _menuController;

  bool dockIsShown = true;

  final shortcuts = <LogicalKeySet, Intent>{
    LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.tab): const SwitchWindowIntent(),
  };

  final actions = const <Type, Action<Intent>>{};

  @override
  void initState() {
    super.initState();
    _menuController = DesktopMenuController((x) => setState(x ?? () {}));
  }

  @override
  Widget build(BuildContext context) {
    /*TODO: Remove*/ print("DESKTOP REBUILD");

    final windowLayer = _DesktopWindowLayer(onWmController: (p) => _wmController = p);

    // This is the dock, it is shown in the bottom of the screen.
    Widget buildDock() {
      Widget base(List<Widget> children) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            children: children,
          ),
        );
      }

      if (dockIsShown) {
        return base([
          Positioned(
            child: MouseRegion(
              onExit: (event) => setState(() {
                dockIsShown = false;
              }),
              child: Container(
                height: DSKTP_UI_LAYER_DOCK_HEIGHT,
                margin: const EdgeInsets.only(bottom: 10),
                child: IntrinsicWidth(
                  child: DOverlayContainer(
                    child: Row(
                      children: [
                        DApplicationItem.icon(
                            image: SvgPicture.asset("resources/images/_icontheme/Default/apps/development-appmaker.svg"), onPress: () {}),
                        DApplicationItem.icon(
                            image: SvgPicture.asset("resources/images/_icontheme/Default/apps/accessories-calculator.svg"), onPress: () {}),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]);
      } else {
        return base([
          Positioned(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 3,
              child: MouseRegion(
                onEnter: (event) => setState(() => dockIsShown = true),
              ),
            ),
          ),
        ]);
      }
    }

    // The topBar is shown in the top of the screen. It can be used to launch apps, or using the quickSettings menu.
    Widget buildTopBar() => Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: DSKTP_UI_LAYER_TOPBAR_HEIGHT,
      child: ShadeContainer.transparent(
        border: ShadeContainerBorder.none,
        backgroundBlur: true,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // The items on the TopBar on the left side.
                children: [
                  DTopbarButton.icon(icon: Icons.apps, menuControllerRef: _menuController, menu: LauncherMenu()),
                  DTopbarButton.icon(icon: Icons.search, menuControllerRef: _menuController, menu: SearchMenu()),
                  DTopbarButton.icon(icon: Icons.menu_open, menuControllerRef: _menuController, menu: OpenWindowsMenu()),
                  //// TaskView button.
                  //_LocalDesktopWidgets._topBarItem(null, _LocalDesktopWidgets._topBarItemIcon(context, Icons.menu_open), true, () {}),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                // The items on the TopBar on the right side.
                children: [
                  DTopbarButton.icons(icons: const [Icons.mic, Icons.camera], menuControllerRef: _menuController, menu: PermissionsMenu()),
                  DTopbarButton.icons(icons: const [Icons.wifi, Icons.volume_mute, Icons.battery_full], menuControllerRef: _menuController, menu: ControlCenterMenu()),
                  DTopbarButton.textAndIcon(icon: Icons.notifications, text: "19:00", menuControllerRef: _menuController, menu: NotificationMenu()),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    List<Widget> buildDesktopLayersUI() {
      List<Widget> widgets = [
        windowLayer,
        buildDock(),
        buildTopBar(),
      ];

      // The desktop-menu layer of the desktop.
      if (_menuController.getWidget() != null) {
        widgets.add(_menuController.getWidget() as Widget);
      }

      return widgets;
    }

    Widget buildBase() {
      // ignore: curly_braces_in_flow_control_structures
      if (!renderGUI) return windowLayer;
      // ignore: curly_braces_in_flow_control_structures
      else return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              // The desktop background image.
              image: AssetImage(DSKTP_UI_LAYER_BACKGROUND_WALLPAPER_DIR),
              fit: BoxFit.cover,
            ),
          ),
          child: Shortcuts(
            shortcuts: shortcuts,
            child: Actions(
              actions: actions,
              child: Builder(
                builder: (context) => Stack(
                  children: buildDesktopLayersUI(),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Desktop UI.
    return ShadeApp(
      title: 'jappeos_desktop',
      debugShowCheckedModeBanner: false,
      customThemeProperties: ShadeCustomThemeProperties(ThemeMode.dark, Color.fromARGB(255, 146, 20, 196), true),
      home: buildBase(),
    );
  }
}

/// The layer of the desktop where windows can be moved around.
class _DesktopWindowLayer extends StatefulWidget {
  const _DesktopWindowLayer({Key? key, required this.onWmController}) : super(key: key);

  final void Function(WindowStackController) onWmController;

  @override
  _DesktopWindowLayerState createState() => _DesktopWindowLayerState();
}

class _DesktopWindowLayerState extends State<_DesktopWindowLayer> {
  // Create a new instance of [WmController].
  // TODO: remove
  static WindowStackController? _wmController;

  @override
  void initState() {
    super.initState();
    assert(_wmController == null, "_wmController was not null in _DesktopWindowLayerState:initState");
    _wmController = WindowStackController(() => setState(() {}));
    widget.onWmController(_wmController!);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: WindowStack(
        wmController: _wmController,
        insets: const EdgeInsets.only(top: DSKTP_UI_LAYER_TOPBAR_HEIGHT),
      ),
    );
  }
}