import 'dart:math';
import 'dart:ui';

import 'package:birdTD/actors/actor.dart';
import 'package:birdTD/actors/bullet.dart';
import 'package:birdTD/actors/enemy.dart';
import 'package:birdTD/bird-td-game.dart';
import 'package:flame/sprite.dart';

class Tower implements Actor {
  final BirdTDGame _game;
  Rect _rect;

  List<Sprite> _sprites = List(5);
  int _spriteIndex = 0;
  int _spriteCount = 5;
  int _spriteIncrementer = 1;
  double _spriteTimer = 0.0;

  double _attackRange = 80.0;
  int _attackPower = 10;
  double _attackSpeed = 0.4; /// In seconds
  double _attackTimer = 0.0;

  Enemy _target;

  Tower(this._game, this._rect) {
    for (int i = 0; i < _spriteCount; i++) {
      _sprites[i] = Sprite('bird$i.png');
    }
  }

  Rect get rect => _rect;

  void render(Canvas canvas) {
    _sprites[_spriteIndex].renderRect(canvas, _rect);
  }

  void update(double t) {
    updateSprite(t);
    updateEnemyDetection();
    attack(t);
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

  bool isInRange(Actor actor) {
    Offset center = _rect.center;
    Rect rect = actor.rect;

    double closestX = center.dx.clamp(rect.left, rect.right);
    double closestY = center.dy.clamp(rect.top, rect.bottom);

    double distanceX = center.dx - closestX;
    double distanceY = center.dy - closestY;

    double distanceSquared = pow(distanceX, 2) + pow(distanceY, 2);
    return distanceSquared < pow(_attackRange, 2);
  }

  void updateSprite(double t) {
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

  void updateEnemyDetection() {
    if (_target != null) {
      if (!isInRange(_target)) {
        _target = null;
      }
    } else {
      for (Enemy enemy in _game.enemies) {
        if (isInRange(enemy)) {
          _target = enemy;
          break;
        }
      }
    }
  }

  void attack(double t) {
    if (_target == null) return;

    _attackTimer += t;
    if (_attackTimer > _attackSpeed) {
      bool targetIsDead = _target.onAttacked(_attackPower);

      if (targetIsDead) {
        _target = null;
      } else {
        Bullet bullet = Bullet(_game, this, _target);
        _game.bullets.add(bullet);
      }
      _attackTimer = 0.0;
    }
  }
}
