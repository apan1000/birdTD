import 'dart:ui';

import 'package:birdTD/actors/actor.dart';
import 'package:flame/sprite.dart';

class Tower implements Actor {
  Sprite _sprite = Sprite('dash-front.png');
  Rect _rect;

  Tower(this._rect);

  void render(Canvas canvas) {
    _sprite.renderRect(canvas, _rect);
  }

  void update(double t) {
    // TODO: implement update
  }

  void onTapDown() {
    print("onTapDown Tower");
  }

  void onTapUp() {
    // TODO: implement onTapUp
  }

  void onTapCancel() {
    // TODO: implement onTapCancel
  }

  bool contains(Offset offset) {
    return _rect.contains(offset);
  }
}
