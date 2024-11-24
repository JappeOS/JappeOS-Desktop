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

part of jappeos_desktop.base;

class DesktopMenuController {
  static const kMenuAnimationDuration = Duration(milliseconds: 100);

  DesktopMenuController(this.rebuildCallback);

  final Function(void Function()?) rebuildCallback;
  DesktopMenu? _currentMenu;
  Offset? _currentMenuPosition;
  Size _currentMenuChildSize = Size.zero;
  Size _currentStackWSize = Size.zero;
  bool _currentMenuIsInitialBuild = true;

  void openMenu(DesktopMenu menu, {Offset? position, void Function()? closeCallback}) {
    _currentMenu = menu;
    _currentMenuPosition = position;
    _currentMenuIsInitialBuild = true;
    rebuildCallback(null);
    menu.onOpen.broadcast();

    if (closeCallback != null) {
      menu.onClose.subscribe((_) => closeCallback());
    }
  }

  void closeMenu() {
    _currentMenu!.onClose.broadcast();
    _currentMenu!.onOpen.unsubscribeAll();
    _currentMenu!.onClose.unsubscribeAll();
    _currentMenu = null;
    _currentMenuPosition = null;
    rebuildCallback(null);
  }

  AnimatedPositioned? getWidget() {
    final double pad = _currentMenu is FullscreenDesktopMenu ? 0 : BPPresets.small;

    LayoutBuilder base() {
      return LayoutBuilder(
        builder: (context, constraints) {
          bool wasInitialBuild = false;

          if (_currentMenuIsInitialBuild) {
            wasInitialBuild = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _currentStackWSize = MediaQuery.of(context).size;

              final renderBox = context.findRenderObject() as RenderBox;
              _currentMenuChildSize = renderBox.size;

              // Ensure the menu is correctly positioned within the stack
              rebuildCallback(() {
                var minX = pad;
                var maxX = _currentStackWSize.width - _currentMenuChildSize.width - pad;

                if (maxX < minX) {
                  maxX = minX;
                }

                var minY = DSKTP_UI_LAYER_TOPBAR_HEIGHT + pad;
                var maxY = _currentStackWSize.height - _currentMenuChildSize.height - pad;

                if (maxY < minY) {
                  maxY = minY;
                }

                _currentMenuPosition = Offset(
                  _currentMenuPosition!.dx - _currentMenuChildSize.width / 2,
                  _currentMenuPosition!.dy - _currentMenuChildSize.height / 2,
                );

                _currentMenuPosition = Offset(
                  _currentMenuPosition!.dx.clamp(minX, maxX),
                  _currentMenuPosition!.dy.clamp(minY, maxY),
                );
              });
            });
          }

          _currentMenuIsInitialBuild = false;

          return TapRegion(
            onTapOutside: (_) => closeMenu(),
            child: AnimatedOpacity(
              opacity: wasInitialBuild ? 0.3 : 1,
              duration: kMenuAnimationDuration,
              child: RepaintBoundary(
                child: AnimatedScale(
                  curve: Curves.easeIn,
                  duration: kMenuAnimationDuration,
                  scale: wasInitialBuild ? 0 : 1,
                  alignment: Alignment.topLeft,
                  child: () {
                    if (_currentMenu is FullscreenDesktopMenu) {
                      return ShadeContainer.transparent(
                        width: _currentStackWSize.width,
                        height: (_currentStackWSize.height - DSKTP_UI_LAYER_TOPBAR_HEIGHT).clamp(0, double.infinity),
                        backgroundBlur: true,
                        padding: const EdgeInsets.all(BPPresets.small),
                        child: _currentMenu as Widget,
                      );
                    }

                    return _currentMenu as Widget;
                  }(),
                ),
              ),
            ),
          );
        },
      );
    }

    return _currentMenu != null
        ? AnimatedPositioned(
            left: _currentMenuPosition!.dx,
            top: _currentMenuPosition!.dy,
            curve: Curves.easeIn,
            duration: _currentMenuIsInitialBuild ? Duration.zero : kMenuAnimationDuration,
            child: base(),
          )
        : null;
  }
}

abstract class DesktopMenu extends StatefulWidget {
  final onOpen = Event();
  final onClose = Event();

  DesktopMenu({super.key});
}

abstract class FullscreenDesktopMenu extends DesktopMenu {
  FullscreenDesktopMenu({super.key});
}
