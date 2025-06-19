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
import 'package:flutter/services.dart';
import 'package:jappeos_desktop/application.dart';
import 'package:http/http.dart' as http;
import 'package:vector_math/vector_math.dart' hide Colors;

import '../../jappeos_desktop/lib/base/base.dart';
import '../../jappeos_desktop/lib/window_manager/window_manager.dart';

class WidgetTesting extends Application {
  WidgetTesting() : super("WidgetTesting", "widget-testing", null);

  @override
  void app$launch() {
    var window = DesktopState.getWmController()!.createWindow()
    ..setSize(Vector2(400, 400), true)
    ..setMinSize(Vector2(400, 400))
    ..setResizable(true)
    ..setBgRenderMode(BackgroundMode.blurredTransp);
    /*TODO: Remove*/ print("WidgetTesting window created. Size: ${window.size}");
    _image().then((value) => window.setRender(value));
  }

  Future<Uint8List> _image() async {
    const imageUrl = "https://miro.medium.com/v2/resize:fit:505/1*QxLJhfnx-8Lx_FuuXVu5Uw.png";
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }
}

class _Content extends StatefulWidget {
  final Window window;

  const _Content(this.window);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  double _sliderVal = 0.05;

  @override
  Widget build(BuildContext context) {
    Widget colorW(String propName, Color clr) {
      return Container(
        width: 150,
        height: 40,
        decoration: BoxDecoration(
          color: clr,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
            child: Text(propName,
                style: TextStyle(fontWeight: FontWeight.bold, color: clr.withBlue(1 - clr.blue).withGreen(1 - clr.green).withRed(1 - clr.red)))),
      );
    }

    return SizedBox(
      width: widget.window.size.x,
      height: widget.window.size.y,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 5,
              direction: Axis.horizontal,
              children: [
                ShadeMenuStrip(items: [
                  ShadeMenuStripItem("File", () {}, [
                    ShadeMenuStripItem("New", () {}, []),
                    ShadeMenuStripItem("Open", () {}, []),
                    ShadeMenuStripItem("Save", () {}, []),
                    ShadeMenuStripItem("Exit", () {}, [])
                  ])
                ]),
                TextButton(
                  child: Text('TextButton'),
                  onPressed: () {},
                ),
                OutlinedButton(
                  child: Text('OutlinedButton'),
                  onPressed: () {},
                ),
                FilledButton(
                  child: Text('FilledButton'),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: Text('ElevatedButton'),
                  onPressed: () {},
                ),
                Container(
                  width: 35,
                  height: 35,
                  color: Colors.red,
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                const DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 1, label: "Item 1"),
                    DropdownMenuEntry(value: 2, label: "Item 2"),
                    DropdownMenuEntry(value: 3, label: "Item 3"),
                  ],
                  initialSelection: 1,
                ),
                SegmentedButton<int>(
                  segments: const <ButtonSegment<int>>[
                    ButtonSegment<int>(value: 0, label: Text('Item 1')),
                    ButtonSegment<int>(value: 1, label: Text('Item 2')),
                    ButtonSegment<int>(value: 2, label: Text('Item 3')),
                  ],
                  selected: const <int>{0},
                  onSelectionChanged: (Set<int> newSelection) {},
                ),
                const TextField(
                    decoration: InputDecoration(
                  hintText: 'Type something...',
                )),
                const TextField(
                    decoration: InputDecoration(
                  labelText: 'This is a label!',
                )),
                const Text('text'),
                const Icon(Icons.logo_dev),
                Switch(
                  value: true,
                  onChanged: (value) {},
                ),
                SizedBox(
                  width: 300,
                  child: Slider(value: _sliderVal, onChanged: (d) => _sliderVal = d),
                ),
                const SizedBox(width: double.infinity),

                // Color palette
                colorW("primary", Theme.of(context).colorScheme.primary),
                colorW("onPrimary", Theme.of(context).colorScheme.onPrimary),
                colorW("inversePrimary", Theme.of(context).colorScheme.inversePrimary),
                colorW("primaryContainer", Theme.of(context).colorScheme.primaryContainer),
                colorW("onPrimaryContainer", Theme.of(context).colorScheme.onPrimaryContainer),
                colorW("secondary", Theme.of(context).colorScheme.secondary),
                colorW("onSecondary", Theme.of(context).colorScheme.onSecondary),
                colorW("secondaryContainer", Theme.of(context).colorScheme.secondaryContainer),
                colorW("onSecondaryContainer", Theme.of(context).colorScheme.onSecondaryContainer),
                colorW("tertiary", Theme.of(context).colorScheme.tertiary),
                colorW("onTertiary", Theme.of(context).colorScheme.onTertiary),
                colorW("tertiaryContainer", Theme.of(context).colorScheme.tertiaryContainer),
                colorW("onTertiaryContainer", Theme.of(context).colorScheme.onTertiaryContainer),

                colorW("background", Theme.of(context).colorScheme.background),
                colorW("onBackground", Theme.of(context).colorScheme.onBackground),
                colorW("surface", Theme.of(context).colorScheme.surface),
                colorW("onSurface", Theme.of(context).colorScheme.onSurface),
                colorW("surfaceTint", Theme.of(context).colorScheme.surfaceTint),
                colorW("surfaceVariant", Theme.of(context).colorScheme.surfaceVariant),
                colorW("onSurfaceVariant", Theme.of(context).colorScheme.onSurfaceVariant),
                colorW("inverseSurface", Theme.of(context).colorScheme.inverseSurface),
                colorW("onInverseSurface", Theme.of(context).colorScheme.onInverseSurface),

                colorW("outline", Theme.of(context).colorScheme.outline),
                colorW("outlineVariant", Theme.of(context).colorScheme.outlineVariant),
              ],
            )
          ],
        ),
      ),
    );
  }
}
