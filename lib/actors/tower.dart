import 'dart:ui';

import 'package:birdTD/actors/actor.dart';
import 'package:flame/sprite.dart';

class Tower implements Actor {
  List<Sprite> _sprites = List(5);
  Rect _rect;
  int _spriteIndex = 0;
  int _spriteCount = 5;
  int _spriteIncrementer = 1;
  double _spriteTimer = 0.0;

  Tower(this._rect) {
    for (int i = 0; i < _spriteCount; i++) {
      _sprites[i] = Sprite('bird$i.png');
    }
  }

  void render(Canvas canvas) {
    _sprites[_spriteIndex].renderRect(canvas, _rect);
  }

  void update(double t) {
    _spriteTimer += t;
    if (_spriteTimer > 0.048) {
      _spriteIndex += _spriteIncrementer;
      if (_spriteIndex == 0) {
        _spriteIncrementer = 1;
      } else if (_spriteIndex == _spriteCount - 1) {
        _spriteIncrementer = -1;
      }
      _spriteTimer = 0.0;
    }
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
