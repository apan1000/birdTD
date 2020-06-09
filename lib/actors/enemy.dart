import 'dart:math';
import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:birdTD/actors/actor.dart';
import 'package:birdTD/bird-td-game.dart';
import 'package:birdTD/view.dart';

class Enemy implements Actor {
  final BirdTDGame game;
  Random rnd;
  Rect enemyRect;
  bool isWalking = true;
  double speed = 1;
  bool isOffScreen = false;
  int deadCounter = 0;
  List<Sprite> enemySprite;
  Sprite deadSprite;
  double enemySpriteIndex = 0;

  Enemy(this.game, double x, double y) {
    enemyRect = Rect.fromLTWH(x, y, 30, 30);

    rnd = Random();
  }

  void death() {
    isWalking = false;

    game.spawnEnemies();
  }

  @override
  void onTapCancel() {
    // TODO: implement onTapCancel
  }

  @override
  void onTapDown() {
    // TODO: implement onTapDown
  }

  @override
  void onTapUp() {
    // TODO: implement onTapUp
  }

  @override
  void render(Canvas canvas) {
    if (isWalking) {
      enemySprite[enemySpriteIndex.toInt()].renderRect(canvas, enemyRect.inflate(2));
    } else {
      deadSprite.renderRect(canvas, enemyRect.inflate(2));
    }
  }

  @override
  void update(double t) {
    if (isWalking) {
      speed = rnd.nextDouble();
      enemySpriteIndex = speed > 0.5 ? 1 : 0;
      enemyRect = enemyRect.translate(0, game.tileSize * speed * t);

      if (enemyRect.top > game.screenSize.height) {
        isOffScreen = true;
        game.activeView = View.lost;
      }
    } else if (!isWalking) {
      enemyRect = enemyRect.translate(0, 0);
      deadCounter++;
    }
  }

  @override
  bool contains(Offset offset) {
    return enemyRect.contains(offset);
  }
}
