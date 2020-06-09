import 'package:birdTD/actors/enemy.dart';
import 'package:birdTD/bird-td-game.dart';
import 'package:flame/sprite.dart';



class Spider extends Enemy {
  Spider(BirdTDGame game, double x, double y) : super(game, x, y) {
    enemySprite = List<Sprite>();
    enemySprite.add(Sprite('spider-walk1.png'));
    enemySprite.add(Sprite('spider-walk2.png'));
    deadSprite = Sprite('spider-dead.png');
  }
}