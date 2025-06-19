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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jappeos_desktop/base/base.dart';
import 'package:jappeos_desktop/application.dart';
import 'package:jappeos_desktop/window_manager/window_manager.dart';

import 'settings_page_widgets.dart';

late WindowOld _settingsWindow;

class Settings extends Application {
  Settings() : super("Settings", "settings", null);

  @override
  void app$launch() {
    _settingsWindow = DesktopState.getWmController()!
        .wm$spawnGuiWindow(NormalWindow("Settings", null, WMWindowSize(const Size(400, 300), const Size(400, 300)), true, _Content(), [
      const SizedBox(
        width: 300,
        height: 35,
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search',
          ),
        ),
      )
    ]));
  }

  static double sidebarWidth = 300;
}

class _Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final PageController _pageController = PageController();

  Widget gap = const SizedBox(
    width: 5.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ShadeSidebarLayout<SettingsPageItem>(
        items: [
          ShadeSidebarLayoutItem(text: "Wi-Fi", icon: Icons.wifi, content: [
            SettingsPageItem(
              title: "Connect to the Internet",
              content: [
                SettingsPageSetting(
                  name: 'Select Wi-Fi network',
                  controls: [
                    OutlinedButton(
                      child: const Text("Network1"),
                      onPressed: () {},
                    ),
                    gap,
                    FilledButton(
                      child: const Text("Disconnect"),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ]),
          const ShadeSidebarLayoutItem(text: "Bluetooth", icon: Icons.bluetooth, content: []),
          ShadeSidebarLayoutItem(text: "Appearance", icon: Icons.edit, content: [
            SettingsPageItem(
              title: "Desktop Wallpaper",
              content: [
                SettingsPageSetting(
                  name: 'Select a wallpaper',
                  controls: [
                    IconButton(
                      icon: const Icon(Icons.folder),
                      onPressed: () {},
                    )
                  ],
                ),
              ],
            ),
            SettingsPageItem(
              title: "Theme",
              content: [
                SettingsPageSetting(
                  name: 'Enable dark theme',
                  controls: [
                    Switch(
                      onChanged: (bool value) {}, value: false,
                      //value: Theme.of(context).brightness != 0,
                      //onChanged: (value) {
                      //  setState(() {
                      //    Theme.of(context).brightness = value == true ? 1 : 0;
                      //  });
                      //},
                    )
                  ],
                ),
                SettingsPageSetting(
                  name: 'Accent color',
                  controls: [
                    IconButton(
                      icon: const Icon(Icons.colorize),
                      onPressed: () {},
                    )
                  ],
                ),
              ],
            ),
            SettingsPageItem(
              title: "Performance",
              content: [
                SettingsPageSetting(
                  name: 'Blur settings',
                  controls: [
                    SegmentedButton<int>(
                      segments: const <ButtonSegment<int>>[
                        ButtonSegment<int>(value: 0, label: Text('All Windows')),
                        ButtonSegment<int>(value: 1, label: Text('Focused Only')),
                        ButtonSegment<int>(value: 2, label: Text('No Blur')),
                      ],
                      selected: const <int>{1},
                      onSelectionChanged: (Set<int> newSelection) {},
                    ),
                  ],
                ),
                SettingsPageSetting(
                  name: 'Transparency settings',
                  controls: [
                    SegmentedButton<int>(
                      segments: const <ButtonSegment<int>>[
                        ButtonSegment<int>(value: 0, label: Text("Same as 'Blur settings'")),
                        ButtonSegment<int>(value: 1, label: Text('All Windows')),
                        ButtonSegment<int>(value: 2, label: Text('Focused Only')),
                        ButtonSegment<int>(value: 3, label: Text('Disabled')),
                      ],
                      selected: const <int>{0},
                      onSelectionChanged: (Set<int> newSelection) {},
                    ),
                  ],
                ),
                SettingsPageSetting(
                  name: 'Reduced framerates on unfocused windows',
                  controls: [
                    Switch(
                      value: true,
                      onChanged: (p0) {},
                    )
                  ],
                ),
              ],
            ),
          ]),
          ShadeSidebarLayoutItem(text: "Notifications", icon: Icons.notifications, content: [
            SettingsPageItem(
              title: "Do not Disturb",
              content: [
                SettingsPageSetting(
                  name: 'Enable Do-not-Disturb mode',
                  controls: [
                    Switch(
                      value: false,
                      onChanged: (p0) {},
                    )
                  ],
                ),
                SettingsPageSetting(
                  name: 'Auto-disable Do-not-Disturb mode after',
                  controls: [
                    Switch(
                      value: false,
                      onChanged: (p0) {},
                    ),
                    const SizedBox(
                      width: 100,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Time",
                        ),
                      ),
                    ),
                    OutlinedButton(
                      child: const Text("Coming Soon"),
                      onPressed: () {},
                    )
                  ],
                ),
              ],
            ),
          ]),
          ShadeSidebarLayoutItem(text: "Updates", icon: Icons.update, content: [
            SettingsPageItem(
              title: "System Updates",
              content: [
                SettingsPageSetting(
                  name: 'Current Version',
                  controls: [
                    Text(style: Theme.of(context).textTheme.bodyMedium, "1.0.0"),
                    gap,
                    FilledButton(
                      child: const Text("Check For Updates..."),
                      onPressed: () {},
                    )
                  ],
                ),
                SettingsPageSetting(
                  name: 'Update Available!',
                  controls: [
                    ElevatedButton(
                      child: const Text("Update Now! (1.0.1)"),
                      onPressed: () {},
                    )
                  ],
                ),
              ],
            ),
          ]),
          ShadeSidebarLayoutItem(text: "Region & Language", icon: Icons.language, content: [
            SettingsPageItem(
              title: "Language",
              content: [
                SettingsPageSetting(
                  name: 'System Language',
                  controls: [
                    DropdownButton<int>(
                      value: 0,
                      onChanged: (p0) {},
                      items: const [
                        DropdownMenuItem(
                          value: 0,
                          child: Text("Item 1"),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text("Item 2"),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text("Item 3"),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            SettingsPageItem(
              title: "Keyboard Layout",
              content: [
                SettingsPageSetting(
                  name: 'Current Layout',
                  controls: [
                    DropdownButton<int>(
                      value: 0,
                      onChanged: (p0) {},
                      items: const [
                        DropdownMenuItem(
                          value: 0,
                          child: Text("Item 1"),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text("Item 2"),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text("Item 3"),
                        ),
                      ],
                    ),
                    gap,
                    OutlinedButton(
                      child: const Text("Detect Automatically..."),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            SettingsPageItem(
              title: "Timezone",
              content: [
                SettingsPageSetting(
                  name: 'Current Timezone',
                  controls: [
                    const SizedBox(
                        width: 100,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "UTC",
                          ),
                        )),
                    gap,
                    OutlinedButton(
                      child: const Text("Detect Automatically"),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ]),
          const ShadeSidebarLayoutItem(text: "Accounts", icon: Icons.account_circle, content: []),
          const ShadeSidebarLayoutItem(text: "Security", icon: Icons.security, content: []),
          ShadeSidebarLayoutItem(text: "Sound", icon: Icons.speaker, content: [
            SettingsPageItem(
              title: "Output",
              content: [
                SettingsPageSetting(
                  name: 'Device',
                  controls: [
                    DropdownButton<int>(
                      value: 0,
                      onChanged: (p0) {},
                      items: const [
                        DropdownMenuItem(
                          value: 0,
                          child: Text("Item 1"),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text("Item 2"),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text("Item 3"),
                        ),
                      ],
                    )
                  ],
                ),
                SettingsPageSetting(
                  name: 'Master volume',
                  controls: [
                    Slider(
                      value: 0.01,
                      onChanged: (p0) {},
                    )
                  ],
                ),
              ],
            ),
            SettingsPageItem(
              title: "Input",
              content: [
                SettingsPageSetting(
                  name: 'Device',
                  controls: [
                    DropdownButton<int>(
                      value: 0,
                      onChanged: (p0) {},
                      items: const [
                        DropdownMenuItem(
                          value: 0,
                          child: Text("Item 1"),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text("Item 2"),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text("Item 3"),
                        ),
                      ],
                    )
                  ],
                ),
                SettingsPageSetting(
                  name: 'Master volume',
                  controls: [
                    Slider(
                      value: 0.01,
                      onChanged: (p0) {},
                    )
                  ],
                ),
              ],
            ),
          ]),
          const ShadeSidebarLayoutItem(text: "Power", icon: Icons.power, content: []),
          ShadeSidebarLayoutItem(text: "About", icon: Icons.info, content: [
            SettingsPageItem(
              title: "System '{sysname}'",
              content: [
                Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                        width: 400, height: 400, child: SvgPicture.asset("resources/images/_icontheme/Default/apps/utilities-terminal.svg"))),
                const Divider(),
                SettingsPageSetting(
                  name: 'Device Name',
                  controls: [Text(style: Theme.of(context).textTheme.bodyMedium, "text")],
                ),
                const Divider(),
                SettingsPageSetting(
                  name: 'Memory',
                  controls: [Text(style: Theme.of(context).textTheme.bodyMedium, "1GiB")],
                ),
                SettingsPageSetting(
                  name: 'Processor',
                  controls: [Text(style: Theme.of(context).textTheme.bodyMedium, "N/A")],
                ),
                SettingsPageSetting(
                  name: 'Graphics',
                  controls: [Text(style: Theme.of(context).textTheme.bodyMedium, "N/A")],
                ),
                SettingsPageSetting(
                  name: 'Disk Capacity (Total)',
                  controls: [Text(style: Theme.of(context).textTheme.bodyMedium, "1GiB")],
                ),
                const Divider(),
                SettingsPageSetting(
                  name: 'OS Name',
                  controls: [Text(style: Theme.of(context).textTheme.bodyMedium, "JappeOS 1.0.0")],
                ),
                SettingsPageSetting(
                  name: 'OS Type',
                  controls: [Text(style: Theme.of(context).textTheme.bodyMedium, "64bit")],
                ),
                SettingsPageSetting(
                  name: 'Desktop Environment',
                  controls: [Text(style: Theme.of(context).textTheme.bodyMedium, "JappeOS Desktop 1.0.0")],
                ),
                SettingsPageSetting(
                  name: 'Compositor',
                  controls: [Text(style: Theme.of(context).textTheme.bodyMedium, "X11")],
                ),
                SettingsPageSetting(
                  name: 'Virtualization',
                  controls: [Text(style: Theme.of(context).textTheme.bodyMedium, "None")],
                ),
                const Divider(),
                SettingsPageSetting(
                  name: 'Other',
                  controls: [
                    OutlinedButton(onPressed: () {}, child: const Text("Licenses")),
                    OutlinedButton(
                        onPressed: () => DesktopState.getWmController()
                            ?.wm$spawnGuiWindow(DialogWindow("About Settings", "Ver: 1.0.0", [], () {}, _settingsWindow)),
                        child: const Text("About 'Settings'"))
                  ],
                ),
              ],
            ),
          ]),
        ],
        controller: _pageController,
      ),
    );
  }
}

// class _Content extends StatefulWidget {
//   @override
//   _ContentState createState() => _ContentState();
// }
//
// class _ContentState extends State<_Content> {
//   int _selectedPage = 0;
//   Widget _page = const Placeholder();
//
//   @override
//   Widget build(BuildContext context) {
//     final BorderRadius br = BorderRadius.circular(30);
//
//     Widget sidebarItem(int index, String text, IconData icon, List<SettingsPageItem> items) {
//       return Container(
//         height: 35,
//         margin: const EdgeInsets.only(bottom: 5),
//         decoration: BoxDecoration(
//           borderRadius: br,
//           color: _selectedPage == index ? context.watch<ShadeThemeProvider>().getCurrentThemeProperties().transparentFillColor : null,
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             mouseCursor: SystemMouseCursors.alias,
//             borderRadius: br,
//             hoverColor: context.watch<ShadeThemeProvider>().getCurrentThemeProperties().darkerTextColor.withOpacity(0.2),
//             onTap: () {
//               setState(() {
//                 _selectedPage = index;
//                 _page = SettingsPage(title: text, content: items);
//               });
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(5),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Row(
//                   children: [
//                     Icon(
//                       icon,
//                       color: _selectedPage == index
//                           ? SHUI_THEME_PROPERTIES(context).accentColor
//                           : SHUI_THEME_PROPERTIES(context).normalTextColor.withOpacity(0.8),
//                     ),
//                     const SizedBox(
//                       width: 7,
//                     ),
//                     Text(
//                       text,
//                       style: TextStyle(
//                         color: _selectedPage == index
//                             ? SHUI_THEME_PROPERTIES(context).accentColor
//                             : SHUI_THEME_PROPERTIES(context).normalTextColor.withOpacity(0.8),
//                         fontSize: 15,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             bottom: 0,
//             width: Settings.sidebarWidth,
//             child: ListView(
//               padding: const EdgeInsets.all(5),
//               children: [
//                 sidebarItem(0, "Wi-Fi", Icons.wifi, [
//                   SettingsPageItem(
//                     title: "Connect to the Internet",
//                     content: [
//                       SettingsPageSetting(
//                         name: 'Select Wi-Fi network',
//                         controls: [
//                           ShadeButton(
//                             text: "Hello!",
//                             onPress: () {},
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ]),
//                 sidebarItem(1, "Bluetooth", Icons.bluetooth, []),
//                 sidebarItem(2, "Appearance", Icons.edit, [
//                   SettingsPageItem(
//                     title: "Desktop Wallpaper",
//                     content: [
//                       SettingsPageSetting(
//                         name: 'Select a wallpaper',
//                         controls: [
//                           ShadeButton(
//                             icon: Icons.folder,
//                             onPress: () {},
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   SettingsPageItem(
//                     title: "Theme",
//                     content: [
//                       SettingsPageSetting(
//                         name: 'Enable dark theme',
//                         controls: [
//                           ShadeSwitch(
//                             value: context.watch<ShadeThemeProvider>().getTheme() != 0,
//                             onChanged: (value) {
//                               setState(() {
//                                 Provider.of<ShadeThemeProvider>(context, listen: false).setTheme(value == true ? 1 : 0);
//                               });
//                             },
//                           )
//                         ],
//                       ),
//                       SettingsPageSetting(
//                         name: 'Accent color',
//                         controls: [
//                           ShadeButton(
//                             icon: Icons.colorize,
//                             onPress: () {},
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   SettingsPageItem(
//                     title: "Performance",
//                     content: [
//                       SettingsPageSetting(
//                         name: 'Blur settings',
//                         controls: [
//                           ShadeButtonBar([
//                             ShadeButtonBarItem(text: "All Windows", action: () {}),
//                             ShadeButtonBarItem(text: "Focused Only", action: () {}),
//                             ShadeButtonBarItem(text: "No Blur", action: () {}),
//                           ], 1)
//                         ],
//                       ),
//                       SettingsPageSetting(
//                         name: 'Transparency settings',
//                         controls: [
//                           ShadeButtonBar([
//                             ShadeButtonBarItem(text: "Same as 'Blur settings'", action: () {}),
//                             ShadeButtonBarItem(text: "All Windows", action: () {}),
//                             ShadeButtonBarItem(text: "Focused Only", action: () {}),
//                             ShadeButtonBarItem(text: "Disabled", action: () {}),
//                           ])
//                         ],
//                       ),
//                       SettingsPageSetting(
//                         name: 'Reduced framerates on unfocused windows',
//                         controls: [
//                           ShadeSwitch(
//                             value: true,
//                             onChanged: (p0) {},
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ]),
//                 sidebarItem(3, "Notifications", Icons.notifications, [
//                   SettingsPageItem(
//                     title: "Do not Disturb",
//                     content: [
//                       SettingsPageSetting(
//                         name: 'Enable Do-not-Disturb mode',
//                         controls: [
//                           ShadeSwitch(
//                             value: false,
//                             onChanged: (p0) {},
//                           )
//                         ],
//                       ),
//                       SettingsPageSetting(
//                         name: 'Auto-disable Do-not-Disturb mode after',
//                         controls: [
//                           ShadeSwitch(
//                             value: false,
//                             onChanged: (p0) {},
//                           ),
//                           const SizedBox(
//                             width: 100,
//                             child: ShadeTextfield(
//                               hintText: "Time",
//                             ),
//                           ),
//                           ShadeButton(
//                             text: "Coming Soon",
//                             onPress: () {},
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ]),
//                 sidebarItem(4, "Updates", Icons.update, []),
//                 sidebarItem(5, "Region & Language", Icons.language, []),
//                 sidebarItem(6, "Accounts", Icons.account_circle, []),
//                 sidebarItem(7, "Security", Icons.security, []),
//                 sidebarItem(8, "Sound", Icons.speaker, [
//                   SettingsPageItem(
//                     title: "Output",
//                     content: [
//                       SettingsPageSetting(
//                         name: 'Master volume',
//                         controls: [
//                           ShadeSlider(
//                             value: 0.01,
//                             onChanged: (p0) {},
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ]),
//                 sidebarItem(9, "Power", Icons.power, []),
//                 sidebarItem(10, "About", Icons.info, [
//                   SettingsPageItem(
//                     title: "System '{sysname}'",
//                     content: [
//                       SettingsPageSetting(
//                         name: 'Info',
//                         controls: [
//                           ShadeSlider(
//                             value: 0.01,
//                             onChanged: (p0) {},
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ]),
//               ],
//             ),
//           ),
//           Positioned(
//               left: Settings.sidebarWidth,
//               width: 1,
//               top: 5,
//               bottom: 0,
//               child: Container(
//                 width: 1,
//                 color: context.watch<ShadeThemeProvider>().getCurrentThemeProperties().borderColor,
//               )),
//           Positioned(
//             top: 0,
//             left: Settings.sidebarWidth + 1,
//             bottom: 0,
//             right: 0,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(topLeft: Radius.circular(5)),
//                 color: context.watch<ShadeThemeProvider>().getCurrentThemeProperties().backgroundColor1,
//               ),
//               child: ListView(
//                 children: [_page],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class ShadeSidebarLayout<T extends Widget> extends StatefulWidget {
  final List<ShadeSidebarLayoutItem<T>> items;
  final PageController controller;

  final bool disableTitle;
  final bool hasIconizeButton;
  final bool disableContentPadding;
  final bool dynamicPadding;

  const ShadeSidebarLayout({
    Key? key,
    required this.items,
    required this.controller,
    this.disableTitle = false,
    this.hasIconizeButton = true,
    this.disableContentPadding = false,
    this.dynamicPadding = true,
  }) : super(key: key);

  @override
  _ShadeSidebarLayoutState createState() => _ShadeSidebarLayoutState();
}

class _ShadeSidebarLayoutState extends State<ShadeSidebarLayout> {
  static const _sidebarWidth = 300.0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {
        _currentPage = widget.controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const optimalPad = 5.0;
    const textOpacity = 0.9;

    List<Widget> sidebarItems = [];

    for (var i = 0; i < widget.items.length; i++) {
      final BorderRadius br = BorderRadius.circular(30);
      bool isSelected = _currentPage == i;

      sidebarItems.add(Container(
        height: 35,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: br,
          color: isSelected
              ? /* (TODO) ShadeTheme.clr_OnTranspVersion(Theme.of(context).colorScheme.primary)*/ Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.7)
              : null, // << TODO
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            mouseCursor: SystemMouseCursors.alias,
            borderRadius: br,
            hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            onTap: () {
              widget.controller.animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(
                      widget.items[i].icon,
                      color: isSelected
                          ? Theme.of(context).colorScheme.background.withOpacity(textOpacity)
                          : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(textOpacity),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      widget.items[i].text,
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.background.withOpacity(textOpacity)
                            : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(textOpacity),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
    }

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          width: _sidebarWidth,
          child: ListView(
            padding: const EdgeInsets.all(optimalPad),
            children: sidebarItems,
          ),
        ),
        Positioned(
          left: _sidebarWidth,
          width: 1,
          top: 5,
          bottom: 0,
          child: Container(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
        Positioned(
          top: 0,
          left: _sidebarWidth + 1,
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(5)),
              color: Theme.of(context).colorScheme.background,
            ),
            child: PageView.builder(
              controller: widget.controller,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  //final double paddingValue = constraints.maxWidth < 900 ? 10 : constraints.maxWidth * 0.15 - 120;
                  final double paddingValue = constraints.maxWidth < 900 ? 10 : (constraints.maxWidth - 900) / 2 + optimalPad * 2;

                  return ListView(
                    padding: widget.disableContentPadding
                        ? EdgeInsets.zero
                        : (!widget.dynamicPadding
                            ? const EdgeInsets.all(optimalPad)
                            : EdgeInsets.symmetric(horizontal: paddingValue, vertical: optimalPad)),
                    children: [
                      if (!widget.disableTitle)
                        Text(
                          widget.items[index].text,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ...widget.items[index].content,
                    ],
                  );
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ShadeSidebarLayoutItem<T extends Widget> {
  final String text;
  final IconData icon;
  final List<T> content;

  const ShadeSidebarLayoutItem({required this.text, required this.icon, required this.content});
}
