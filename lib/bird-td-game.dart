import 'dart:ui';
import 'package:flame/gestures.dart';

import 'package:flame/game.dart';

class BirdTDGame extends Game {

  Size screenSize;

  void render(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff55aa33);
    canvas.drawRect(bgRect, bgPaint);
  }

  void update(double t) {

  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
  }
}
