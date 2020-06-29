import 'dart:math';
import 'dart:ui';

import 'package:birdTD/actors/actor.dart';
import 'package:birdTD/actors/enemy.dart';
import 'package:birdTD/actors/spider.dart';
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
import 'tile-map.dart';
import 'views/lost_view.dart';

class BirdTDGame extends Game with TapDetector {
  Size screenSize;
  double tileSize = 54;
  int tileColumnSize = 6;
  int tileRowSize = 9;
  Random random;

  View activeView = View.home;
  HomeView homeView;
  StartButton startButton;
  LostView lostView;
  TileMap tileMap;

  List<Enemy> enemies;
  List<Actor> actors = [];
  List<Tile> tiles = [];

  List<double> xStartPositions = [];
  List<double> yStartPositions = [];

  double createEnemiesTimer = 0.0;

  double width = 0;
  double height = 0;

  BirdTDGame() {
    init();
  }

  void init() async {

    tileMap = TileMap([
      1, 1, 0, 1, 1, 1,
      1, 1, 0, 1, 1, 1,
      1, 1, 0, 0, 0, 0,
      1, 1, 0, 1, 1, 1,
      1, 1, 0, 1, 1, 1,
      1, 1, 0, 0, 0, 0,
      1, 1, 0, 1, 1, 1,
      1, 1, 0, 1, 1, 1,
      1, 1, 0, 1, 1, 1
    ].map((e) => TileType.values[e]).toList(), tileColumnSize);

    random = Random();
    enemies = List<Enemy>();
    resize(await Flame.util.initialDimensions());

    homeView = HomeView(this);
    startButton = StartButton(this);
    lostView = LostView(this);

    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    for (int x = 0; x < tileMap.width; x++) {
      for (int y = 0; y < tileMap.height; y++) {
        width = screenWidth / (tileMap.width);
        height = screenHeight / (tileMap.height);
        Rect rect = Rect.fromLTWH((x) * width, (y) * height, width, height);
        Tile tile = Tile(rect, tileMap.get(x, y), (Rect rect) {
          actors.add(Tower(rect));
        });
        tiles.add(tile);
        if (y == 0 && tileMap.get(x, y) == TileType.dirt) {
          if (!xStartPositions.contains(x * width + (width / 3))) {
            xStartPositions.add(x * width + (width / 3));
          }
        }
        if (x == tileMap.width-1 && tileMap.get(x, y) == TileType.dirt) {
          if (!yStartPositions.contains(y * height + (height / 3))) {
            yStartPositions.add(y * height + (height / 3));
          }
        }
      }
    }
  }

  void render(Canvas canvas) {
    switch (activeView) {
      case View.home:
        {
          for (Tile tile in tiles) {
            tile.render(canvas);
          }
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
          for (Tile tile in tiles) {
            tile.render(canvas);
          }
          actors.clear();
          enemies.clear();
          lostView.render(canvas);
          startButton.render(canvas);
          break;
        }
    }
  }

  void update(double t) {
    createEnemiesTimer += t;

    if (createEnemiesTimer >= 2) {
      createEnemiesTimer = 0.0;
      spawnEnemies();
    }

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
    if (random.nextDouble() > 0.5) {
      enemies.add(
          Spider(
              this,
              xStartPositions[random.nextInt(xStartPositions.length)],
              0 - height
          )
      );
    } else {
      enemies.add(
          Spider(
              this,
              screenSize.width + width,
              yStartPositions[random.nextInt(yStartPositions.length)]
          )
      );
    }
  }

  void onTapDown(TapDownDetails details) {
    bool isHandled = false;

    if (activeView == View.home || activeView == View.lost) {
      isHandled = true;
    }

    if (!isHandled) {
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
