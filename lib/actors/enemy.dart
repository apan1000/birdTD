import 'dart:math';
import 'dart:ui';

import 'package:birdTD/actors/actor.dart';
import 'package:birdTD/bird-td-game.dart';

class Enemy implements Actor {
  final BirdTDGame game;
  Random rnd;
  Rect enemyRect;
  Paint enemyPaint;
  bool isWalking = true;
  double speed = 1;
  bool isOffScreen = false;
  int deadCounter = 0;

  Enemy(this.game, double x, double y) {
    enemyRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);

    enemyPaint = Paint();
    enemyPaint.color = Color(0xff6ab04c);

    rnd = Random();
  }

  void death() {
    isWalking = false;
    enemyPaint.color = Color(0xffff4757);

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
    canvas.drawRect(enemyRect, enemyPaint);
  }

  @override
  void update(double t) {
    if (isWalking) {
      speed = rnd.nextDouble();
      enemyRect = enemyRect.translate(0, game.tileSize * speed * t);

      if (enemyRect.top > game.screenSize.height) {
        isOffScreen = true;
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
