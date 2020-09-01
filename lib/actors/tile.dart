import 'dart:ui';

import 'package:birdTD/actors/actor.dart';
import 'package:birdTD/bird-td-game.dart';
import 'package:birdTD/tile-map.dart';
import 'package:flame/sprite.dart';

class Tile implements Actor {
  final BirdTDGame game;
  Sprite _sprite = Sprite('grass.png');
  Rect _rect;
  bool _isBuildable;
  void Function(Rect) _onTapUp;

  Tile(this._rect, TileType tileType, this._onTapUp, this.game) {
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
      game.money -= BirdTDGame.TOWER_COSTS;
      _onTapUp.call(_rect);
    }
  }

  void onTapDown() {}
}
