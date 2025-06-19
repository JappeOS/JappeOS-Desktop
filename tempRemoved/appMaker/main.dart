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
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/dart.dart';
import 'package:jappeos_desktop/application.dart';
import 'package:jappeos_desktop/base/base.dart';
import 'package:shade_ui/widgets/shade_menu_strip.dart';
import '../../window_manager/window_manager.dart';

class AppMaker extends Application {
  AppMaker() : super("App Maker", "app-maker", null);

  @override
  void app$launch() {
    PageController controller = PageController(initialPage: 1);
    _Content contentWidg = _Content(controller);

    void setPage(int page) {
      controller.animateToPage(page, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }

    DesktopState.getWmController()?.wm$spawnGuiWindow(
        NormalWindow("Untitled* - App Maker", null, WMWindowSize(const Size(550, 300), const Size(550, 450)), false, contentWidg, [
      SegmentedButton<int>(
        segments: const <ButtonSegment<int>>[
          ButtonSegment<int>(value: 0, label: Text('Widget Editor'), icon: Icon(Icons.calendar_view_day)),
          ButtonSegment<int>(value: 1, label: Text('Code Editor'), icon: Icon(Icons.calendar_view_week)),
          ButtonSegment<int>(value: 2, label: Text('Project'), icon: Icon(Icons.calendar_view_month)),
        ],
        selected: const <int>{2},
        onSelectionChanged: (Set<int> newSelection) {
          switch (newSelection.first) {
            case 0:
              {
                viewportShowCode(false);
                setPage(0);
              }
            case 1:
              {
                viewportShowCode(true);
                setPage(0);
              }
            case 2:
              {
                setPage(1);
              }
          }
        },
      ),
    ]));
  }
}

late Function(bool) viewportShowCode;

// ignore: must_be_immutable
class _Content extends StatefulWidget {
  final PageController _controller;

  const _Content(this._controller);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final controller = CodeController(
    text: 'void main(List<String> args) {\n\t\n}',
    language: dart,
  );

  double _codeZoomLevel = 0.05;
  bool _showCode = false;

  @override
  void initState() {
    super.initState();

    viewportShowCode = (p0) => setState(
          () => _showCode = p0,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageView(
        controller: widget._controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          editorPage(),
          projectSettingsPage(),
        ],
      ),
    );
  }

  Widget editorPage() {
    Widget viewport() {
      if (_showCode) {
        return CodeTheme(
          data: CodeThemeData(),
          child: SingleChildScrollView(
            child: CodeField(
              controller: controller,
            ),
          ),
        );
      } else {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: 500,
                height: 300,
                color: Colors.blue,
                child: OutlinedButton(
                  child: const Text("Hello!"),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );
      }
    }

    return Column(
      children: [
        ShadeMenuStrip(
          items: [
            ShadeMenuStripItem("File", null, [
              ShadeMenuStripItem("New", () {}, null),
              ShadeMenuStripItem("Open", () {}, null),
              ShadeMenuStripItem("Save", () {}, null),
              ShadeMenuStripItem("Save As...", () {}, null),
              ShadeMenuStripItem("Quit", () {}, null),
            ]),
            ShadeMenuStripItem("Edit", null, [
              ShadeMenuStripItem("Undo", () {}, null),
              ShadeMenuStripItem("Redo", () {}, null),
              ShadeMenuStripItem.separator(),
              ShadeMenuStripItem("Cut", () {}, null),
              ShadeMenuStripItem("Copy", () {}, null),
              ShadeMenuStripItem("Paste", () {}, null),
              ShadeMenuStripItem.separator(),
              ShadeMenuStripItem("Find", () {}, null),
              ShadeMenuStripItem("Replace", () {}, null),
            ]),
            ShadeMenuStripItem("Help", null, [
              ShadeMenuStripItem("About", () {}, null),
            ]),
          ],
        ),
        Expanded(
            child: Stack(
          children: [
            const _FreeWindow(
              title: "Project",
              position: Offset(-1, -1),
              size: Size(250, 0),
              zero: 2,
              child: [] /*TODO Tree View*/,
            ),
            const _FreeWindow(
              title: "Properties",
              position: Offset(-1, -1),
              size: Size(250, 0),
              zero: 2,
              align: _FreeWindowAlignment.topRight,
              child: [Text("TODO: Read widget properties or set them manually for each widget based on their types.")],
            ),
            Positioned(
              top: 0,
              left: 250,
              bottom: 0,
              right: 250,
              child: Column(
                children: [
                  Expanded(child: viewport()),
                  Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(_showCode ? "[Code Editor]" : "[Widget Editor]")),
                      if (_showCode) const Text("Zoom: "),
                      if (_showCode) Slider(value: _codeZoomLevel, onChanged: (val) => setState(() => _codeZoomLevel = val)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ))
      ],
    );
  }

  Widget projectSettingsPage() {
    return Column(
      children: [
        Text(
          "Pubspec",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit), tooltip: "Edit As Text"),
            IconButton(onPressed: () {}, icon: const Icon(Icons.get_app), tooltip: "Get Packages"),
            IconButton(onPressed: () {}, icon: const Icon(Icons.upgrade), tooltip: "Upgrade Packages"),
          ],
        ),
        const Row(
          children: [Text("Name: "), SizedBox(width: 300, child: TextField())],
        ),
        const Row(
          children: [Text("Description: "), SizedBox(width: 300, child: TextField())],
        ),
        const Row(
          children: [Text("Version: "), SizedBox(width: 300, child: TextField())],
        ),
        const Row(
          children: [Text("Dependencies: ")],
        ),
        Row(
          children: [
            const SizedBox(width: 50),
            SegmentedButton<int>(
              segments: const <ButtonSegment<int>>[
                ButtonSegment<int>(value: 0, label: Text('Pub')),
                ButtonSegment<int>(value: 1, label: Text('Git')),
              ],
              selected: const <int>{0},
              onSelectionChanged: (Set<int> newSelection) {},
            ),
            const SizedBox(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(label: Text("Name")),
                )),
            const SizedBox(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(label: Text("Version")),
                )),
          ],
        )
      ],
    );
  }
}

class _FreeWindow extends StatefulWidget {
  final String title;
  final List<Widget> child;
  final Offset position;
  final Size size;
  final _FreeWindowAlignment align;
  final int zero;

  const _FreeWindow(
      {required this.title,
      required this.position,
      required this.size,
      this.align = _FreeWindowAlignment.topLeft,
      this.zero = -1,
      required this.child});

  @override
  _FreeWindowState createState() => _FreeWindowState();
}

class _FreeWindowState extends State<_FreeWindow> {
  @override
  Widget build(BuildContext context) {
    bool top = widget.align == _FreeWindowAlignment.topLeft || widget.align == _FreeWindowAlignment.topRight,
        left = widget.align == _FreeWindowAlignment.topLeft || widget.align == _FreeWindowAlignment.bottomLeft,
        bottom = widget.align == _FreeWindowAlignment.bottomLeft || widget.align == _FreeWindowAlignment.bottomRight,
        right = widget.align == _FreeWindowAlignment.topRight || widget.align == _FreeWindowAlignment.bottomRight;

    return Positioned(
      top: top ? widget.position.dy : (widget.zero == 0 ? 0.0 : null),
      left: left ? widget.position.dx : (widget.zero == 1 ? 0.0 : null),
      bottom: bottom ? widget.position.dy : (widget.zero == 2 ? 0.0 : null),
      right: right ? widget.position.dx : (widget.zero == 3 ? 0.0 : null),
      width: widget.zero == 1 || widget.zero == 3 ? null : widget.size.width,
      height: widget.zero == 0 || widget.zero == 2 ? null : widget.size.height,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background, border: Border.all(color: Theme.of(context).dividerColor, width: 1)),
        child: Column(
          children: [
            Text(widget.title),
            Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
            ...widget.child,
          ],
        ),
      ),
    );
  }
}

enum _FreeWindowAlignment { topLeft, topRight, bottomLeft, bottomRight }
