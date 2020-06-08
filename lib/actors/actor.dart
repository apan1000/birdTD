import 'dart:ui';

abstract class Actor {
  void render(Canvas canvas) {}

  void update(double t) {}

  void onTapDown() {}

  void onTapUp() {}

  void onTapCancel() {}

  bool contains(Offset offset) {}
}
