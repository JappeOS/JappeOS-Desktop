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

void main() {
  runApp(const AppCenterHome());
}

class AppCenterHome extends StatelessWidget {
  const AppCenterHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app center',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(title: 'App center'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [/*
          Container( // Custom appBar
            height: 50,
            color: Colors.green,
            child: Stack(
              children: [
                Positioned(
                  left: 10,
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          padding: EdgeInsets.all(0),
                          onPressed: () {

                          },
                          child: Icon(Icons.menu, color: Colors.white,),
                        ),
                      ),
                      Container(width: 10,),
                      Container(
                        child: Text(
                          'App center',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
              
                ),
                Positioned(
                  top: 10,
                  left: 200,
                  right: 200,
                  height: 30,
                  child: Container(
                    child: FlatButton(
                      hoverColor: Colors.black.withOpacity(0.0),
                      onPressed: () {

                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                     child: Stack(
                       children: [
                          Positioned(
                            left: 0,
                            height: 30,
                            width: 30,
                            child: Icon(Icons.search, color: Colors.white,),
                          ),
                          Positioned(
                            top: 5,
                            left: 60,
                            right: 40,
                            height: 30,
                            child: Text(
                              'Search for apps, games, extensions, and more!',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            height: 30,
                            width: 30,
                            child: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.green[800],
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  child: Row(
                    children: [
                      Container(
                        width: 180,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          padding: EdgeInsets.all(0),
                          onPressed: () {

                          },
                          child: Container(
                            width: 180,
                            height: 35,
                            child: Stack(
                              children: [
                                Positioned(
                                  width: 40,
                                  right: 0,
                                  child: Icon(Icons.account_circle, color: Colors.white, size: 35,),
                                ),
                                Positioned(
                                  left: 10,
                                  top: 7,
                                  right: 45,
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned( // Tab bar
            top: 50,
            left: 0,
            right: 0,
            height: 30,
            child: Container(
              color: Colors.green,
              child: ListView(
                scrollDirection: Axis.horizontal,

              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
