import 'dart:ui';
import 'package:birdTD/bird-td-game.dart';
import 'package:flame/sprite.dart';

class LostView {
  final BirdTDGame game;
  Rect rect;
  Sprite sprite;

  LostView(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize,
      (game.screenSize.height / 2) - (game.tileSize * 5),
      game.tileSize * 5,
      game.tileSize * 3,
    );
    sprite = Sprite('lose-splash.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}
}