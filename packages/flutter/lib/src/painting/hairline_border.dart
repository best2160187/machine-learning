// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

import 'basic_types.dart';
import 'border_radius.dart';
import 'borders.dart';
import 'box_border.dart';
import 'box_decoration.dart';
import 'edge_insets.dart';
import 'rounded_rectangle_border.dart';
import 'shape_decoration.dart';

/// A rectangular 1px border.
///
/// [Border] has a hidden behavior where it paints a single pixel border when
/// `BorderSide(width: 0.0, style: BorderStyle.solid)`. This method performs
/// the same, but paints faster and is more obvious when being used.
///
/// This is useful for drawing hairline borders, which are 1px wide regardless
/// of the device pixel ratio.
///
/// The four sides can be independently specified. They are painted in the order
/// top, right, bottom, left. This is only notable if they overlap (e.g. if
/// top and right are specified, with different colors).
///
/// See also:
///
///  * [RoundedRectangleBorder], which is used for a border with customizable side width.
///  * [Border], which can also describe a rectangle.
class HairlineBorder extends BoxBorder {
  /// Creates a rectangular 1px border.
  /// If a color is not specified or null, nothing is painted.
  const HairlineBorder({
    this.topColor,
    this.rightColor,
    this.bottomColor,
    this.leftColor,
  });

  /// The top 1px side of this border, if specified.
  final Color? topColor;

  /// The right 1px side of this borderm, if specified.
  final Color? rightColor;

  /// The bottom 1px side of this border, if specified.
  final Color? bottomColor;

  /// The left 1px side of this border, if specified.
  final Color? leftColor;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is HairlineBorder) {
      return HairlineBorder(
        topColor: Color.lerp(a.topColor, topColor, t),
        rightColor: Color.lerp(a.rightColor, rightColor, t),
        bottomColor: Color.lerp(a.bottomColor, bottomColor, t),
        leftColor: Color.lerp(a.leftColor, leftColor, t),
      );
    }
    if (a is RoundedRectangleBorder) {
      final Color color = topColor ?? rightColor ?? bottomColor ?? leftColor ?? const Color(0x00000000);
      return RoundedRectangleBorder(
        side: BorderSide.lerp(a.side, BorderSide(width: 0, color: color), t),
      );
    }
    if (a is Border) {
      const Color transparentColor = Color(0x00000000);
      return Border(
        top: BorderSide.lerp(a.top, BorderSide(color: topColor ?? transparentColor), t),
        right: BorderSide.lerp(a.right, BorderSide(color: rightColor ?? transparentColor), t),
        bottom: BorderSide.lerp(a.bottom, BorderSide(color: bottomColor ?? transparentColor), t),
        left: BorderSide.lerp(a.left, BorderSide(color: leftColor ?? transparentColor), t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is HairlineBorder) {
      return HairlineBorder(
        topColor: Color.lerp(topColor, b.topColor, t),
        rightColor: Color.lerp(rightColor, b.rightColor, t),
        bottomColor: Color.lerp(bottomColor, b.bottomColor, t),
        leftColor: Color.lerp(leftColor, b.leftColor, t),
      );
    }
    if (b is RoundedRectangleBorder) {
      final Color color = topColor ?? rightColor ?? bottomColor ?? leftColor ?? const Color(0x00000000);
      return RoundedRectangleBorder(
        side: BorderSide.lerp(BorderSide(width: 0, color: color), b.side, t),
      );
    }
    if (b is Border) {
      const Color transparentColor = Color(0x00000000);
      return Border(
        top: BorderSide.lerp(BorderSide(color: topColor ?? transparentColor), b.top, t),
        right: BorderSide.lerp(BorderSide(color: rightColor ?? transparentColor), b.right, t),
        bottom: BorderSide.lerp(BorderSide(color: bottomColor ?? transparentColor), b.bottom, t),
        left: BorderSide.lerp(BorderSide(color: leftColor ?? transparentColor), b.left, t),
      );
    }
    return super.lerpTo(b, t);
  }

  /// Returns a copy of this [HairlineBorder] with the given fields
  /// replaced with the new values.
  HairlineBorder copyWith({
    Color? topColor,
    Color? rightColor,
    Color? bottomColor,
    Color? leftColor,
  }) {
    return HairlineBorder(
      topColor: topColor ?? this.topColor,
      rightColor: rightColor ?? this.rightColor,
      bottomColor: bottomColor ?? this.bottomColor,
      leftColor: leftColor ?? this.leftColor,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return HairlineBorder(
      topColor: topColor,
      bottomColor: bottomColor,
      leftColor: leftColor,
      rightColor: rightColor,
    );
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection? textDirection }) {
    return Path()
      ..addRect(rect);
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection? textDirection }) {
    return Path()
      ..addRect(rect);
  }

  @override
  void paintInterior(Canvas canvas, Rect rect, Paint paint, { TextDirection? textDirection }) {
    canvas.drawRect(rect, paint);
  }

  @override
  bool get preferPaintInterior => true;

  @override
  void paint(Canvas canvas, Rect rect, { BorderRadius? borderRadius, BoxShape? shape, TextDirection? textDirection }) {
    final Paint paint = Paint()
      ..strokeWidth = 0.0;

    if (topColor != null) {
      paint.color = topColor!;
      canvas.drawLine(Offset(rect.left, rect.top), Offset(rect.right, rect.top), paint);
    }
    if (rightColor != null) {
      paint.color = rightColor!;
      canvas.drawLine(Offset(rect.right, rect.top), Offset(rect.right, rect.bottom), paint);
    }
    if (bottomColor != null) {
      paint.color = bottomColor!;
      canvas.drawLine(Offset(rect.left, rect.bottom), Offset(rect.right, rect.bottom), paint);
    }
    if (leftColor != null) {
      paint.color = leftColor!;
      canvas.drawLine(Offset(rect.left, rect.top), Offset(rect.left, rect.bottom), paint);
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is HairlineBorder
        && other.topColor == topColor
        && other.rightColor == rightColor
        && other.bottomColor == bottomColor
        && other.leftColor == leftColor;
  }

  @override
  int get hashCode => Object.hash(topColor, rightColor, bottomColor, leftColor);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'HairlineBorder')}($topColor, $rightColor, $bottomColor, $leftColor)';
  }

  /// This is unused, but is required by the [BoxBorder] interface, so it works
  /// with both [BoxDecoration] and [ShapeDecoration].
  @override
  BorderSide get bottom => BorderSide.none;

  /// This is unused, but is required by the [BoxBorder] interface, so it works
  /// with both [BoxDecoration] and [ShapeDecoration].
  @override
  bool get isUniform => false;

  /// This is unused, but is required by the [BoxBorder] interface, so it works
  /// with both [BoxDecoration] and [ShapeDecoration].
  @override
  BorderSide get top => BorderSide.none;
}
