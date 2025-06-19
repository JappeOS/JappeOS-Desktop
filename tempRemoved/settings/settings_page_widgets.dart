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

class SettingsPageItem extends StatefulWidget {
  final String title;
  final List<Widget> content;

  const SettingsPageItem({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  _SettingsPageItemState createState() => _SettingsPageItemState();
}

class _SettingsPageItemState extends State<SettingsPageItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(
        top: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          ...widget.content,
        ],
      ),
    );
  }
}

class SettingsPageSetting extends StatefulWidget {
  final String name;
  final List<Widget> controls;

  const SettingsPageSetting({Key? key, required this.name, required this.controls}) : super(key: key);

  @override
  _SettingsPageSettingState createState() => _SettingsPageSettingState();
}

class _SettingsPageSettingState extends State<SettingsPageSetting> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              widget.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 19),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 8), // Add spacing between the Text and controls
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.controls,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
