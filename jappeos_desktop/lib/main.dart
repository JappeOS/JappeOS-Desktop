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

// ignore_for_file: library_private_types_in_public_api, constant_identifier_names

//import 'package:args/args.dart';
import 'package:flutter/material.dart';

import 'base/base.dart';

// TODO: Multiple windows for multiple monitors
Future main(List<String> arguments) async {
  //final parser = ArgParser()..addOption("monitor-id", abbr: 'm', defaultsTo: 0.toString());
  //ArgResults argResults = parser.parse(arguments);
//
  //final monitorID = int.tryParse(argResults.option("monitor-id") ?? 0.toString());

  runApp(const Desktop());
}