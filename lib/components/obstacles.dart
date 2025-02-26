
import 'dart:async';

import 'package:dodge_the_blocks/components/obstacle_manager.dart';
import 'package:dodge_the_blocks/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:dodge_the_blocks/dodge_the_blocks.dart';

class Obstacle extends SpriteComponent with HasGameRef<dodge_the_blocks>, CollisionCallbacks {
  double speed = 0.0;
  String obstacleName = "";
  late ObstacleGroundCollision ground;
  late Player player = Player();
  Obstacle({this.obstacleName = "obstacle_1.png", required this.player, super.position, super.size, this.speed = 300});


  @override
  FutureOr<void> onLoad() async {
    sprite = await gameRef.loadSprite(obstacleName);
    debugMode = true;
    return super.onLoad();
  }
  

  @override
  void update(double dt) {
    position.y += dt * speed;

    if (ground.position.y - position.y <= 10) {
      print("hit the ground");
      _destroyObstacle();

      gameRef.data.score.value += 150;


    }
    if ((((player.position.y-32) - position.y).abs()  <= 100) && (player.position.x - position.x).abs() <= 100 ) {
      print("hit Player");

      _destroyObstacle();

      gameRef.data.lives.value --;

      
    }

    super.update(dt);
  }
 
  
  void _destroyObstacle() {
    
    removeFromParent(); 

  }

}