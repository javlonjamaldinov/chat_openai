import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


const num FIGMA_DESIGN_WIDTH = 414;
const num FIGMA_DESIGN_HEIGHT = 896;
const num FIGMA_DESIGN_STATUS_BAR = 44;
double getVerticalSize(double px) {
  return ((px * height) / (FIGMA_DESIGN_HEIGHT - FIGMA_DESIGN_STATUS_BAR));
}

uint8ListToBase64(Uint8List data) {
  return base64.encode(data);
}

Uint8List base64ToUint8List(String base64String) {
  final decodedBytes = base64.decode(base64String);
  return Uint8List.fromList(decodedBytes);
}
Size size = WidgetsBinding.instance.window.physicalSize /
    WidgetsBinding.instance.window.devicePixelRatio;

get width {
  return size.width;
}

get height {
  num statusBar =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).viewPadding.top;
  num bottomBar = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
      .viewPadding
      .bottom;
  num screenHeight = size.height - statusBar - bottomBar;
  return screenHeight;
}

EdgeInsetsGeometry getPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  return getMarginOrPadding(
    all: all,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

EdgeInsetsGeometry getMarginOrPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  if (all != null) {
    left = all;
    top = all;
    right = all;
    bottom = all;
  }
  return EdgeInsets.only(
    left: getHorizontalSize(
      left ?? 0,
    ),
    top: getVerticalSize(
      top ?? 0,
    ),
    right: getHorizontalSize(
      right ?? 0,
    ),
    bottom: getVerticalSize(
      bottom ?? 0,
    ),
  );
}

double getHorizontalSize(double px) {
  return ((px * width) / FIGMA_DESIGN_WIDTH);
}

double getSize(double px) {
  var height = getVerticalSize(px);
  var width = getHorizontalSize(px);
  if (height < width) {
    return height.toInt().toDouble();
  } else {
    return width.toInt().toDouble();
  }
}

EdgeInsetsGeometry getMargin({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  return getMarginOrPadding(
    all: all,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}


