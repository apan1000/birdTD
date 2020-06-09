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
    'bird0.png',
    'bird1.png',
    'bird2.png',
    'bird3.png',
    'bird4.png',
    'grass.png',
    'dirt.png',
    'lose-splash.png',
    'title.png',
    'dialog-credits.png',
    'dialog-help.png',
    'start-button.png',
    'spider-dead.png',
    'spider-walk1.png',
    'spider-walk2.png',
    'spider-hit.png'
  ]);

  BirdTDGame game = BirdTDGame();
  runApp(game.widget);
}
