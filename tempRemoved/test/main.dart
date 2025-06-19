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

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jappeos_desktop/application.dart';
import 'package:jappeos_desktop/base/base.dart';
import 'package:jappeos_desktop/window_manager/window_manager.dart';

class Test extends Application {
  Test() : super("Test App", "testapp", null);

  late NormalWindow nw;

  @override
  void app$launch() {
    nw = NormalWindow("Test App", null, WMWindowSize(const Size(400, 300), const Size(400, 300)), true, const _Content());

    DesktopState.getWmController()?.wm$spawnGuiWindow(nw);
    DesktopState.getWmController()?.wm$spawnGuiWindow(DialogWindow(
      "Dialog",
      "Dialog content.",
      [DialogWindowAction("Action", () {})],
      () {},
      nw.theWindow
    ));
  }
}

// The content of the app
class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const MyWidget();
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => MyWidgetState();
}

// ignore: must_be_immutable
class MyWidgetState extends State<MyWidget> {
  double _theta = 10;
  double _phi = 10;

  @override
  Widget build(BuildContext context) {
    CubePainter cp = CubePainter(paintt: Paint(), center: const Offset(300, 200), theta: _theta, phi: _phi);
    cp.theta = _theta;
    cp.phi = _phi;
    //print(_phi.toString() + " , " + _theta.toString());
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: (details) => setState(() => _theta += details.primaryDelta! / 10),
      onVerticalDragUpdate: (details) => setState(() => _phi += details.primaryDelta! / 10),
      child: CustomPaint(
        painter: cp,
      ),
    );
  }
}

// Custom paint
class CubePainter extends CustomPainter {
  final Paint paintt;
  final Offset center;
  double theta;
  double phi;

  CubePainter({
    required this.paintt,
    required this.center,
    required this.theta,
    required this.phi,
  });

  Offset projection(Offset point) {
    final cosPhi = cos(phi);
    final sinPhi = sin(phi);
    final cosTheta = cos(theta);
    final sinTheta = sin(theta);

    final x1 = point.dx - center.dx;
    final y1 = point.dy - center.dy;
    const z1 = 0.0;

    final x2 = cosPhi * x1 + sinPhi * z1;
    final y2 = y1;
    final z2 = -sinPhi * x1 + cosPhi * z1;

    final x3 = cosTheta * x2 + sinTheta * y2;
    final y3 = -sinTheta * x2 + cosTheta * y2;
    final z3 = z2;

    final scaleFactor = 200 / (200 - z3);
    final x4 = scaleFactor * x3;
    final y4 = scaleFactor * y3;

    return Offset(x4, y4);
  }

  Offset transform(Offset point) {
    final projectedPoint = projection(point);
    return Offset(
      projectedPoint.dx + center.dx,
      projectedPoint.dy + center.dy,
    );
  }

  void drawCube(Canvas canvas) {
    final cube = [
      // front face
      [const Offset(-100, -100), const Offset(100, -100), const Offset(100, 100), const Offset(-100, 100)],
      // back face
      [const Offset(-100, -100), const Offset(100, -100), const Offset(100, 100), const Offset(-100, 100)],
    ];

    canvas.drawPath(
      Path()
        ..addPolygon(cube[0].map(transform).toList(), true) // front face
        ..addPolygon(cube[1].map(transform).toList(), true) // back face
        // connecting edges
        ..addPolygon([
          transform(cube[0][0]),
          transform(cube[1][0]),
          transform(cube[1][1]),
          transform(cube[0][1]),
        ], true)
        ..addPolygon([
          transform(cube[0][1]),
          transform(cube[1][1]),
          transform(cube[1][2]),
          transform(cube[0][2]),
        ], true)
        ..addPolygon([
          transform(cube[0][2]),
          transform(cube[1][2]),
          transform(cube[1][3]),
          transform(cube[0][3]),
        ], true)
        ..addPolygon([
          transform(cube[0][3]),
          transform(cube[1][3]),
          transform(cube[1][0]),
          transform(cube[0][0]),
        ], true),
      paintt,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawCube(canvas);
  }

  @override
  bool shouldRepaint(CubePainter oldDelegate) {
    return oldDelegate.theta != theta || oldDelegate.phi != phi;
  }
}
