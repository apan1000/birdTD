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

  int hp = 100;

  Enemy(this.game, double x, double y) {
    enemyRect = Rect.fromLTWH(x, y, 30, 30);

    rnd = Random();
  }

  Rect get rect => enemyRect;

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

      if (enemyRect.top < game.xStartPosition) {
        enemyRect = enemyRect.translate(0, game.tileSize * speed * t);
      } else if (enemyRect.top == game.yStartPosition &&
          enemyRect.topLeft.dx > game.xStartPosition) {
        enemyRect = enemyRect.translate(-(game.tileSize * speed * t), 0);
      } else {
        enemyRect = enemyRect.translate(0, game.tileSize * speed * t);
      }

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

  /// Returns whether this enemy has 0 hp after the attack or not.
  bool onAttacked(int damage) {
    game.money += BirdTDGame.MONEY_EARNT_BY_HIT ;
    hp = max(0, hp - damage);
    bool isDead = hp == 0;
    if (hp < 20 && hp > 0) {
      isWalking = false;
    }else if (isDead) {
      game.enemies.remove(this);
    }
    return isDead;
  }
}
