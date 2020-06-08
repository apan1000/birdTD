import 'package:birdTD/bird-td-game.dart';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setPortraitUpOnly();

  Flame.images.loadAll([
    'dash-front.png',
    'lose-splash.png',
    'title.png',
    'dialog-credits.png',
    'dialog-help.png',
    'start-button.png',
  ]);

  BirdTDGame game = BirdTDGame();
  runApp(game.widget);
}
