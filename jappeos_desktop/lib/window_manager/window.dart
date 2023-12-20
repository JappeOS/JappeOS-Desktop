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

part of window_manager;

class Window {
  Window._() {
    onTitleChanged.subscribe((args) => onEvent.broadcast(args));
    onFocusChanged.subscribe((args) => onEvent.broadcast(args));
    onResizableChanged.subscribe((args) => onEvent.broadcast(args));
    onBackgroundRenderModeChanged.subscribe((args) => onEvent.broadcast(args));
    onPosChanged.subscribe((args) => onEvent.broadcast(args));
    onSizeChanged.subscribe((args) => onEvent.broadcast(args));
    onMinSizeChanged.subscribe((args) => onEvent.broadcast(args));
    onStateChanged.subscribe((args) => onEvent.broadcast(args));
    onNewRender.subscribe((args) => onEvent.broadcast(args));
  }

  void _dispose() {
    onTitleChanged.unsubscribeAll();
    onFocusChanged.unsubscribeAll();
    onResizableChanged.unsubscribeAll();
    onBackgroundRenderModeChanged.unsubscribeAll();
    onPosChanged.unsubscribeAll();
    onSizeChanged.unsubscribeAll();
    onMinSizeChanged.unsubscribeAll();
    onStateChanged.unsubscribeAll();
    onNewRender.unsubscribeAll();

    onEvent.unsubscribeAll();
  }

  // Variable store and getters

  String _title = "";
  String get title => _title;

  bool _isFocused = false;
  bool get isFocused => _isFocused;

  bool _isResizable = false;
  bool get isResizable => _isResizable;

  BackgroundMode _bgRenderMode = BackgroundMode.normal;
  BackgroundMode get bgRenderMode => _bgRenderMode;

  Vector2 _pos = Vector2.zero();
  Vector2 get pos => _pos;

  Vector2 _size = Vector2.zero();
  Vector2 get size => _size;

  Vector2 _minSize = Vector2.zero();
  Vector2 get minSize => _minSize;

  WindowState _state = WindowState.normal;
  WindowState get state => _state;

  Uint8List? _render;
  Uint8List? get render => _render;

  // Controller callbacks

  late Function() _close;

  // Functions

  void setTitle(String title) {
    _title = title;
    onTitleChanged.broadcast(WindowEvent._("onTitleChanged", this.title));
  }

  void setFocus(bool hasFocus) {
    _isFocused = hasFocus;
    onFocusChanged.broadcast(WindowEvent._("onFocusChanged", isFocused));
  }

  void setResizable(bool isResizable) {
    _isResizable = isResizable;
    onResizableChanged.broadcast(WindowEvent._("onResizableChanged", this.isResizable));
  }

  void setBgRenderMode(BackgroundMode mode) {
    _bgRenderMode = mode;
    onBackgroundRenderModeChanged.broadcast(WindowEvent._("onBackgroundRenderModeChanged", bgRenderMode));
  }

  void setPos(Vector2 pos) {
    setState(WindowState.normal);
    _pos = pos;
    onPosChanged.broadcast(WindowEvent._("onPosChanged", this.pos));
  }

  void setSize(Vector2 size, [bool forceSetSize = false]) {
    if (!isResizable && !forceSetSize) return;
    setState(WindowState.normal);
    _size = size;
    onSizeChanged.broadcast(WindowEvent._("onSizeChanged", this.size));
  }

  void setMinSize(Vector2 size) {
    _minSize = size;
    onMinSizeChanged.broadcast(WindowEvent._("onMinSizeChanged", minSize));
  }

  void setState(WindowState state) {
    _state = state;
    onStateChanged.broadcast(WindowEvent._("onStateChanged", this.state));
  }

  void setRender(Uint8List tex) {
    _render = tex;
    onNewRender.broadcast(WindowEvent._("onNewRender", render ?? Uint8List(0)));
  }

  // Events

  var onTitleChanged = Event<WindowEvent<String>>();
  var onFocusChanged = Event<WindowEvent<bool>>();
  var onResizableChanged = Event<WindowEvent<bool>>();
  var onBackgroundRenderModeChanged = Event<WindowEvent<BackgroundMode>>();
  var onPosChanged = Event<WindowEvent<Vector2>>();
  var onSizeChanged = Event<WindowEvent<Vector2>>();
  var onMinSizeChanged = Event<WindowEvent<Vector2>>();
  var onStateChanged = Event<WindowEvent<WindowState>>();
  var onNewRender = Event<WindowEvent<Uint8List>>();

  var onEvent = Event<WindowEvent>();
}

enum WindowState { normal, maximized, minimized }

enum BackgroundMode { normal, blurredTransp }

class WindowEvent<T> extends EventArgs {
  final String id;
  final T value;

  WindowEvent._(this.id, this.value);
}
