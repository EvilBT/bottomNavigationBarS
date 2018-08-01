// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show Color;

import 'package:flutter/material.dart';

const int _dBadgeColor = 0xFFF44336;

/// An interactive button within either material's [BottomNavigationBar]
/// or the iOS themed [CupertinoTabBar] with an icon and title.
///
/// This class is rarely used in isolation. Commonly embedded in one of the
/// bottom navigation widgets above.
///
/// See also:
///
///  * [BottomNavigationBarS]
///  * <https://material.google.com/components/bottom-navigation.html>
///  * [CupertinoTabBar]
///  * <https://developer.apple.com/ios/human-interface-guidelines/bars/tab-bars>
class BottomNavigationBarItemS {
  /// Creates an item that is used with [BottomNavigationBarS.items].
  ///
  /// The arguments [icon] and [title] should not be null.
  BottomNavigationBarItemS({
    @required this.icon,
    @required this.title,
    this.backgroundColor,
    // new Add
    Color badgeBackgroundColor,
    this.badgeCount: 0
  }) : assert(icon != null),
        //assert(title != null), can be null
      badgeBackgroundColor = badgeBackgroundColor ?? const Color(_dBadgeColor);

  /// The icon of the item.
  ///
  /// Typically the icon is an [Icon] or an [ImageIcon] widget. If another type
  /// of widget is provided then it should configure itself to match the current
  /// [IconTheme] size and color.
  final Widget icon;

  /// The title of the item.
  final Widget title;

  /// The color of the background radial animation for material [BottomNavigationBarS].
  ///
  /// If the navigation bar's type is [BottomNavigationBarTypeS.shifting], then
  /// the entire bar is flooded with the [backgroundColor] when this item is
  /// tapped.
  ///
  /// Not used for [CupertinoTabBar]. Control the invariant bar color directly
  /// via [CupertinoTabBar.backgroundColor].
  ///
  /// See also:
  ///
  ///  * [Icon.color] and [ImageIcon.color] to control the foreground color of
  ///     the icons themselves.
  final Color backgroundColor;

  ///
  final Color badgeBackgroundColor;

  ///
  int badgeCount;
}