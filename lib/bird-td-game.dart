import 'dart:math';
import 'dart:ui';

import 'package:birdTD/actors/actor.dart';
import 'package:birdTD/actors/enemy.dart';
import 'package:birdTD/actors/tower.dart';
import 'package:birdTD/tile-map.dart';
import 'package:birdTD/view.dart';
import 'package:birdTD/views/home-view.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'actors/tile.dart';
import 'actors/tower.dart';
import 'components/start-button.dart';
import 'views/lost_view.dart';

class BirdTDGame extends Game with TapDetector {
  Size screenSize;
  double tileSize = 50;
  Random random;

  View activeView = View.home;
  HomeView homeView;
  StartButton startButton;
  LostView lostView;

  List<Enemy> enemies;
  List<Actor> actors = [];
  List<Tile> tiles = [];

  BirdTDGame() {
    init();
  }

  void init() async {
    random = Random();
    enemies = List<Enemy>();
    resize(await Flame.util.initialDimensions());

    homeView = HomeView(this);
    startButton = StartButton(this);
    lostView = LostView(this);

    spawnEnemies();

    TileMap tileMap = TileMap([
      1, 1, 0, 1, 1, 1,
      1, 1, 0, 1, 1, 1,
      1, 1, 0, 1, 1, 1,
      1, 1, 0, 1, 1, 1,
      1, 1, 0, 0, 0, 0,
      1, 1, 0, 1, 1, 1,
      1, 1, 0, 1, 1, 1,
      1, 1, 0, 1, 1, 1,
      1, 1, 0, 1, 1, 1
    ].map((e) => TileType.values[e]).toList(), 6);

    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    for (int x = 0; x < tileMap.width; x++) {
      for (int y = 0; y < tileMap.height; y++) {
        var width = screenWidth / tileMap.width;
        var height = screenHeight / tileMap.height;
        Rect rect = Rect.fromLTWH(x * width, y * height, width, height);
        Tile tile = Tile(rect, tileMap.get(x, y), (Rect rect) {
          actors.add(Tower(rect));
        });
        tiles.add(tile);
      }
    }
  }

  void render(Canvas canvas) {
    switch (activeView) {
      case View.home:
        {
          homeView.render(canvas);
          startButton.render(canvas);
          break;
        }
      case View.playing:
        {
          tiles.forEach((tile) => tile.render(canvas));
          actors.forEach((actor) => actor.render(canvas));
          enemies.forEach((enemy) => enemy.render(canvas));
          break;
        }
      case View.lost:
        {
          lostView.render(canvas);
          startButton.render(canvas);
          break;
        }
    }
  }

  void update(double t) {
    enemies.forEach((enemy) => enemy.update(t));
    enemies.removeWhere((enemy) => enemy.isOffScreen);

    actors.forEach((actor) => actor.update(t));

    tiles.forEach((tile) => tile.update(t));
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
  }

  void spawnEnemies() {
    double x = random.nextDouble() * (screenSize.width - tiles.length);
    double y = -50;
    enemies.add(Enemy(this, x, y));
  }

  void onTapDown(TapDownDetails details) {
    bool isHandled = false;

    if (activeView == View.home || activeView == View.lost) {
      isHandled = true;
    }

    if (!isHandled) {
      spawnEnemies();

      for (Actor actor in actors) {
        if (actor.contains(details.globalPosition)) {
          actor.onTapDown();
          isHandled = true;
          break;
        }
      }

      if (!isHandled) {
        for (Tile tile in tiles) {
          if (tile.contains(details.globalPosition)) {
            tile.onTapDown();
            isHandled = true;
            break;
          }
        }
      }

      if (activeView == View.playing && !isHandled) {
        activeView = View.lost;
      }
    }
  }

  void onTapUp(TapUpDetails details) {
    bool isHandled = false;

    if (activeView == View.home || activeView == View.lost) {
      if (startButton.rect.contains(details.globalPosition)) {
        startButton.onTapUp();
      }
      isHandled = true;
    }

    if (!isHandled) {
      for (Actor actor in actors) {
        if (actor.contains(details.globalPosition)) {
          actor.onTapUp();
          isHandled = true;
          break;
        }
      }
    }

    if (!isHandled) {
      for (Tile tile in tiles) {
        if (tile.contains(details.globalPosition)) {
          tile.onTapUp();
          isHandled = true;
          break;
        }
      }
    }
  }

  void onTapCancel() {
    print("Tap cancel");
  }
}
