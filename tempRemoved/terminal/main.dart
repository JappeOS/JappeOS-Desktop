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

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jappeos_desktop/application.dart';
import 'package:jappeos_desktop/base/base.dart';
import 'package:jappeos_desktop/window_manager/window_manager.dart';

class Terminal extends Application {
  Terminal() : super("Terminal", "terminal", null);

  @override
  void app$launch() {
    DesktopState.getWmController()
        ?.wm$spawnGuiWindow(CustomWindow(blur: true, useDecorationExtent: true, body: _Content()));
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: ShadeTabSystem(),
    );
  }
}

//--

class TabsConfig {
  static List<String> tabs = [];
  static int selectedTabIndex = 0;
}

class ShadeTabSystemTab extends StatefulWidget {
  final int index;
  final VoidCallback updateFunc;
  final String text;

  const ShadeTabSystemTab({Key? key, required this.index, required this.updateFunc, required this.text}) : super(key: key);

  @override
  State<ShadeTabSystemTab> createState() => _ShadeTabSystemTabState();
}

class _ShadeTabSystemTabState extends State<ShadeTabSystemTab> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: WMWindowDragAreaProperties.getDefaultH() + 10 - 5,
      width: 180,
      child: MouseRegion(
        onEnter: (p0) => setState(() => isHovered = true),
        onExit: (p0) => setState(() => isHovered = false),
        child: Row(
          children: [
            SizedBox(width: 18, height: 18, child: SvgPicture.asset("resources/images/_icontheme/Default/apps/utilities-terminal.svg")),
            const SizedBox(width: 10),
            Expanded(
              child: Text(widget.text),
            ),
            AnimatedOpacity(
              opacity: isHovered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              child: IconButton(
                onPressed: () {
                  TabsConfig.tabs.removeAt(widget.index);
                  widget.updateFunc();
                },
                icon: const Icon(Icons.close),
                iconSize: 18,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShadeTabSystem extends StatefulWidget {
  const ShadeTabSystem({Key? key}) : super(key: key);

  @override
  State<ShadeTabSystem> createState() => _ShadeTabSystemState();
}

class _ShadeTabSystemState extends State<ShadeTabSystem> with TickerProviderStateMixin {
  late TabController controller;
  int lastIndex = 0;

  @override
  void initState() {
    controller = TabController(
      length: TabsConfig.tabs.length,
      vsync: this,
      initialIndex: TabsConfig.selectedTabIndex,
    );
    super.initState();
  }

  void updateTabs([int? select]) {
    try {
      lastIndex = controller.index;
      controller = TabController(
        length: TabsConfig.tabs.length,
        vsync: this,
        initialIndex: TabsConfig.selectedTabIndex,
      );
      if (lastIndex >= controller.length) {
        controller.index = controller.length - 1;
      } else {
        controller.index = lastIndex;
      }

      setState(() {});
      if (select != null) controller.animateTo(select);
    } catch (on) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Flexible(
                  child: TabBar(
                    isScrollable: true,
                    controller: controller,
                    labelColor: Theme.of(context).textTheme.labelMedium!.color,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    unselectedLabelColor: Theme.of(context).hintColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    splashBorderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    indicator: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      color: Theme.of(context).colorScheme.onInverseSurface,
                    ),
                    tabs: List.generate(
                      TabsConfig.tabs.length,
                      (index) => ShadeTabSystemTab(index: index, updateFunc: () => updateTabs(), text: TabsConfig.tabs[index]),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    TabsConfig.tabs.add('New tab ${TabsConfig.tabs.length}');
                    updateTabs(TabsConfig.tabs.length - 1);
                  },
                  icon: const Icon(Icons.add),
                  iconSize: 18,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
                SizedBox(width: WM_UI_WINDOW_RESERVED_CONTROL_BUTTONS_SIZE.width),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller,
                children: List.generate(
                  TabsConfig.tabs.length,
                  (index) => Container(
                    color: Theme.of(context).colorScheme.background,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(height: 40, color: Theme.of(context).colorScheme.onInverseSurface, child: Row(
                          children: [
                            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward)),
                          ],
                        ),),
                        Text("${TabsConfig.tabs[index]}"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}