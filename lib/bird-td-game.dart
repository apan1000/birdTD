import 'dart:ui';

import 'package:birdTD/tile-map.dart';
import 'package:birdTD/view.dart';
import 'package:birdTD/views/home-view.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/start-button.dart';

class BirdTDGame extends Game with TapDetector {
  Size screenSize;
  double tileSize = 50;

  View activeView = View.home;
  HomeView homeView;
  StartButton startButton;

  BirdTDGame() {
    init();
  }

  void init() async {
    resize(await Flame.util.initialDimensions());

    homeView = HomeView(this);
    startButton = StartButton(this);
  }

  TileMap tiles = TileMap(
      [1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1]
          .map((e) => TileType.values[e])
          .toList(),
      3);

  Paint paint = Paint();

  void render(Canvas canvas) {
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    for (int x = 0; x < tiles.width; x++) {
      for (int y = 0; y < tiles.height; y++) {
        var width = screenWidth / tiles.width;
        var height = screenHeight / tiles.height;
        Rect rect = Rect.fromLTWH(x * width, y * height, width, height);
        paint.color = getTileColor(tiles.get(x, y));
        canvas.drawRect(rect, paint);
      }
    }
    if (activeView == View.home) homeView.render(canvas);

    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
    }
  }

  void update(double t) {}

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
  }

  void onTapDown(TapDownDetails details) {
    bool isHandled = false;

    if (!isHandled && startButton.rect.contains(details.globalPosition) &&
        (activeView == View.home || activeView == View.lost)
    ) {
      startButton.onTapDown();
      isHandled = true;
    }

    if (!isHandled) {
      //TODO handle here the game action
//      flies.forEach((Fly fly) {
//        if (fly.flyRect.contains(details.globalPosition)) {
//          fly.onTapDown();
//          isHandled = true;
//        }
//      });
    }

    print(
        "Tap down: ${details.globalPosition.dx}, ${details.globalPosition.dy}");
  }

  void onTapUp(TapUpDetails details) {
    print("Tap up: ${details.globalPosition.dx}, ${details.globalPosition.dy}");
  }

  void onTapCancel() {
    print("Tap cancel");
  }

  Color getTileColor(TileType tileType) {
    switch (tileType) {
      case TileType.dirt:
        return Color(0xff886633);
      case TileType.grass:
        return Color(0xff558833);
    }
    return Color(0xff000000);
  }
}
