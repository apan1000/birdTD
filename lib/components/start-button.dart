import 'dart:ui';
import 'package:birdTD/bird-td-game.dart';
import 'package:birdTD/view.dart';
import 'package:flame/sprite.dart';

class StartButton {
  final BirdTDGame game;
  Rect rect;
  Sprite sprite;

  StartButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 1.5,
      (game.screenSize.height * .75) - (game.tileSize * 1.5),
      game.tileSize * 4,
      game.tileSize * 2,
    );
    sprite = Sprite('start-button.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  void onTapUp() {
    game.activeView = View.playing;
  }
}
