//  JappeOS-Desktop, The desktop environment for JappeOS.
//  Copyright (C) 2025  Jappe02
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

part of jappeos_desktop.base;

class NotificationMenu extends DesktopMenu {
  NotificationMenu({Key? key}) : super(key: key);

  @override
  _NotificationMenuState createState() => _NotificationMenuState();
}

class _NotificationMenuState extends State<NotificationMenu> {
  static const kDefaultPadding = BPPresets.medium;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DOverlayContainer(
          width: 400,
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Material(
            color: Colors.transparent,
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(9000),
              onDateChanged: (p0) {},
            ),
          ),
        ),
        const SizedBox(height: kDefaultPadding),
        DOverlayContainer(
          width: 400,
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: BPPresets.small,
            children: [
              _NotificationCard.media(title: "YouTube", contentText: "YouTube Video\nYouTube Channel\nSomething"),
              _NotificationCard.basic(title: "Notification", contentText: "Hello, World!", actions: [("Dismiss", () {}), ("Do Something", () {})]),
              OutlinedButton(onPressed: () {}, child: const Text("Clear All")),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotificationCard extends StatefulWidget {
  final String source;
  final String contentText;
  final bool isMedia;
  final List<(String, void Function())> actions;

  factory _NotificationCard.basic({required String title, required String contentText, List<(String, void Function())> actions = const []}) {
    return _NotificationCard._(source: title, contentText: contentText, actions: actions);
  }

  factory _NotificationCard.media({required String title, required String contentText}) {
    return _NotificationCard._(source: title, contentText: contentText, isMedia: true);
  }

  const _NotificationCard._({required this.source, required this.contentText, this.isMedia = false, this.actions = const []});

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard> {
  bool _hovered = false;
  bool _expanded = false;

  Widget _iconButton(IconData icon, void Function() onPressed) => IconButton(
    onPressed: onPressed,
    icon: _hovered ? Icon(icon) : const SizedBox.shrink(),
    iconSize: 20,
    visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
  );

  Widget _arrowIconButton(void Function() onPressed) => IconButton(
    onPressed: onPressed,
    icon: _hovered ?
      AnimatedRotation(
        turns: _expanded ? 0.5 : 0, // 180° rotation
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: const Icon(Icons.keyboard_arrow_down),
      ) :
      const SizedBox.shrink(),
    iconSize: 20,
    visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
  );

  @override
  Widget build(BuildContext context) {
    final bool isExpandable = widget.actions.isNotEmpty;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
        });
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: FilledButton(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: BPPresets.medium, vertical: BPPresets.medium * 1.1),
            shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant), borderRadius: BorderRadius.circular(BPPresets.small)),
          ),
          onPressed: () {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: BPPresets.small,
            children: [
              SizedBox(
                height: kButtonHeight / 1.25,
                child: Row(
                  spacing: BPPresets.small,
                  children: [
                    Icon(Icons.settings, size: 20, color: Theme.of(context).iconTheme.color?.dim()),
                    Expanded(child: Text(widget.source, style: Theme.of(context).textTheme.bodyMedium?.dim())),
                    if (isExpandable) _arrowIconButton(() => setState(() => _expanded = !_expanded)),
                    if (!widget.isMedia) _iconButton(Icons.close, () {}),
                  ],
                ),
              ),
              Row(
                spacing: BPPresets.small,
                children: [
                  SizedBox.square(dimension: 50, child: Container(color: Colors.black)),
                  Expanded(
                    child: Text(
                      widget.contentText,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  if (widget.isMedia) ... [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.skip_previous)),
                    IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.play_arrow)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.skip_next)),
                  ],
                ],
              ),
              if (_expanded) Row(
                spacing: BPPresets.small,
                children: List.generate(widget.actions.length, (index) => Expanded(
                  child: TextButton(
                    onPressed: widget.actions[index].$2,
                    child: Text(widget.actions[index].$1),
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}