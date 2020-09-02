import 'dart:math';
import 'dart:ui';

import 'package:birdTD/actors/actor.dart';
import 'package:birdTD/actors/tower.dart';
import 'package:birdTD/bird-td-game.dart';
import 'package:flame/sprite.dart';

import 'enemy.dart';

class Bullet implements Actor {
  // region variable
  final BirdTDGame game;
  Sprite _sprite = Sprite('nut.png');
  Rect bulletRect;
  void Function(Rect) _onTapUp;

  double bulletSize = 50.0;
  double speed = 0.1;
  double xStartPosition = 0;
  double yStartPosition = 0;

  double xChange;
  double yChange;

  Enemy target;
  // endregion

  Bullet( this.game, Tower tower, this.target) {
    xStartPosition = tower.rect.center.dx-bulletSize/2;
    yStartPosition = tower.rect.center.dy-20-bulletSize/2;
    bulletRect = Rect.fromLTWH(
        xStartPosition,
        yStartPosition,
        bulletSize,
        bulletSize
    );

    print("Bullet create t: X:$xStartPosition & y:$yStartPosition "
        "target: ${target.rect.center.dx}");
  }

  Rect get rect => bulletRect;

  void render(Canvas canvas) {
    _sprite.renderRect(canvas, bulletRect);
  }

  bool isInRange() {
    Offset center = bulletRect.center;
    Rect rect = target.rect;

    double closestX = center.dx.clamp(rect.left, rect.right);
    double closestY = center.dy.clamp(rect.top, rect.bottom);

    double distanceX = center.dx - closestX;
    double distanceY = center.dy - closestY;

    double distanceSquared = pow(distanceX, 2) + pow(distanceY, 2);
    return distanceSquared < pow(40, 2);
  }

  void update(double t) {
    print("Bullet update t: $t  xStart: $xStartPosition och "
        "targetX: ${target.rect.center.dx} && "
        "yStart: $yStartPosition och targetY: ${target.rect.center.dy}");

    xChange = (xStartPosition + target.rect.center.dx) / t * speed * 0.01;
    yChange = (yStartPosition + target.rect.center.dy) / t * speed * 0.01;

    if (isInRange()) {
      //TODO fix that the bullet destroy
    }

    if (xStartPosition > target.rect.center.dx &&
        yStartPosition > target.rect.center.dy ) {
      xChange = -(xChange);
      yChange = -(yChange);
    } else if (xStartPosition < target.rect.center.dx &&
        yStartPosition < target.rect.center.dy) {
      xChange = xChange;
      yChange = yChange;
    } else if (xStartPosition < target.rect.center.dx &&
        yStartPosition > target.rect.center.dy) {
      xChange = xChange;
      yChange = -yChange;
    } else if (xStartPosition > target.rect.center.dx &&
        yStartPosition < target.rect.center.dy) {
      xChange = -xChange;
      yChange = yChange;
    }

    bulletRect = bulletRect.translate(
        xChange,
        yChange
    );
  }

  void deleteThis() {
    if (target.isDead) {
      game.bullets.remove(this);
    }
  }

  bool contains(Offset offset) {
    return bulletRect.contains(offset);
  }

  void onTapCancel() {}

  void onTapUp() {}

  void onTapDown() {}
}
