import 'dart:math';
import 'package:flutter/material.dart';
import 'wmresizablewindow.dart';

class WmController {
  WmController(this._onUpdate);

  // Resizable window
  List<ResizableWindow> _resizablewindows = List.empty(growable: true);
  List<ResizableWindow> get resizablewindows => _resizablewindows;

  VoidCallback _onUpdate;

  // Jappeos window spawner
  void gui_spawn_sysapp_window(String title, Widget sysappwidget) {
    _createNewWindowedApp(title, sysappwidget);
  }

  void addWindow() {
    addWindowContent();
  }

  void addWindowContent() {
    _createNewWindowedApp(
        "Title",
        Container(
          color: Colors.black.withOpacity(0.5),
        ));
  }

  void _createNewWindowedApp(String title, Widget app) {
    ResizableWindow resizableWindow = ResizableWindow(title, app);

    //Set initial position
    var rng = new Random();
    resizableWindow.x = rng.nextDouble() * 500;
    resizableWindow.y = rng.nextDouble() * 500;

    //Init onWindowDragged
    resizableWindow.onWindowDragged = (dx, dy) {
      resizableWindow.x += dx;
      resizableWindow.y += dy;

      //Put on top of stack
      _resizablewindows.remove(resizableWindow);
      _resizablewindows.add(resizableWindow);

      _onUpdate();
    };

    //Init onCloseButtonClicked
    resizableWindow.onCloseButtonClicked = () {
      _resizablewindows.remove(resizableWindow);
      _onUpdate();
    };

    //Add Window to List
    _resizablewindows.add(resizableWindow);

    // Update Widgets after adding the new App
    _onUpdate();
  }
}