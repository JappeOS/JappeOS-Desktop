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

/// A simple dialog window with text.
class DialogWindow extends WMWindowType {
  final String title;
  final String content;
  final List<DialogWindowAction> actions;
  final void Function() dialogCloseCallback;
  final Window? parent;
  final int primaryAction;

  DialogWindow(this.title, this.content, this.actions, this.dialogCloseCallback, [this.parent, this.primaryAction = 0]) {
    // Wait till window set!
    Future.doWhile(() async {
      if (windowSet) {
        parent?.onWindowDraggedEvent.subscribe((args) => _parentDragged(args));
        theWindow.onWindowDraggedEvent.subscribe((args) => _thisDragged(args));

        _parentDragged(WindowDragEventArgs(0, 0));
        return false;
      }
      return true;
    });
  }

  void _parentDragged(WindowDragEventArgs? wdea) {
    parent?.cancelSendToTop = true;
    theWindow.setPos((parent!.getPos().dx + wdea!.dx) + parent!.w / 2 - 200, parent!.getPos().dy + wdea.dy + 35);
    //parent?.setPos(parent!.getPos().dx, parent!.getPos().dy);
  }

  void _thisDragged(WindowDragEventArgs? wdea) {
    parent?.setPos((theWindow.getPos().dx + wdea!.dx) - parent!.w / 2 + 200, theWindow.getPos().dy + wdea.dy - 35);
    //theWindow.setPos(theWindow.getPos().dx, theWindow.getPos().dy);
  }

  @override
  List<Widget> getWindow() {
    List<Widget> actionsWidg = [];

    for (DialogWindowAction dwa in actions) {
      actionsWidg.add(actions.indexOf(dwa) == primaryAction ? FilledButton(
        onPressed: dwa.act,
        child: Text(dwa.name),
      ) : OutlinedButton(onPressed: dwa.act, child: Text(dwa.name)));
      actionsWidg.add(const SizedBox(
        width: 5,
      ));
    }

    actionsWidg.add(TextButton(
      child: const Text("Close"),
      onPressed: () {
        dialogCloseCallback();
        theWindow.onCloseButtonClicked!();
      },
    ));

    return [
      Positioned(
        top: /*WMWindowDragAreaProperties.getDefaultH() +*/ 1,
        left: 10,
        bottom: 10,
        right: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actionsWidg,
            ),
            Expanded(child: Text(content)),
          ],
        ),
      ),
      Positioned(
        top: 6,
        left: 10,
        child: DeuiText(isTitle: false, text: title),
      ),
    ];
  }

  @override
  bool applyBlur() {
    return true;
  }

  @override
  bool isResizable() {
    return false;
  }

  @override
  WMWindowDragAreaProperties? getDragAreaProperties() {
    WMWindowDragAreaProperties a = WMWindowDragAreaProperties()..setFilled();

    return a;
  }

  @override
  WMWindowSize getSizeProperties() {
    return WMWindowSize(const Size(400, 200), const Size(400, 200));
  }

  @override
  bool hasControlButtons() {
    return false;
  }
}

class DialogWindowAction {
  String name;
  void Function()? act;

  DialogWindowAction(this.name, this.act);
}