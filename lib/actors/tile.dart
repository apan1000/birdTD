import 'dart:ui';

import 'package:birdTD/actors/actor.dart';
import 'package:birdTD/tile-map.dart';
import 'package:flame/sprite.dart';

class Tile implements Actor {
  Sprite _sprite = Sprite('grass.png');
  Rect _rect;
  bool _isBuildable;
  void Function(Rect) _onTapUp;

  Tile(this._rect, TileType tileType, this._onTapUp) {
    switch (tileType) {
      case TileType.dirt:
        _isBuildable = false;
        _sprite = Sprite('dirt.png');
        break;
      case TileType.grass:
        _isBuildable = true;
        _sprite = Sprite('grass.png');
        break;
    }
  }

  Rect get rect => _rect;

  void render(Canvas canvas) {
    _sprite.renderRect(canvas, _rect);
  }

  void update(double t) {}

  bool contains(Offset offset) {
    return _rect.contains(offset);
  }

  void onTapCancel() {}

  void onTapUp() {
    if (_isBuildable) {
      _onTapUp.call(_rect);
    }
  }

  void onTapDown() {}
}
