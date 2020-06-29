import 'dart:ui';

abstract class Actor {
  Rect get rect;

  void render(Canvas canvas) {}

  void update(double t) {}

  void onTapDown() {}

  void onTapUp() {}

  void onTapCancel() {}

  bool contains(Offset offset) {
    return false;
  }
}
