import 'dart:async';

import 'package:dodge_the_blocks/components/level_01.dart';
import 'package:dodge_the_blocks/components/obstacle_manager.dart';
import 'package:dodge_the_blocks/components/ui.dart';
import 'package:dodge_the_blocks/main.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:dodge_the_blocks/components/player.dart';


// ignore: camel_case_types
class dodge_the_blocks extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  
  @override
  Color backgroundColor() => const Color.fromARGB(255, 28, 27, 43);
  late final CameraComponent cam;
  Player player = Player();
  final data = Data(); //score and health
  ObstacleSpawnManager spawnManager = ObstacleSpawnManager();  
  int lives = 3;
  int score = 0;
  Hud hud = Hud();
  late BuildContext context;

  dodge_the_blocks(this.context);
  

  @override
  FutureOr<void> onLoad() async{
    
    data.lives.addListener((){
       
      if (data.lives.value == 0) {
        restartGameWidget();
        data.lives.value = 3;
        data.score.value = 0;
        
      }
       });
    //loads images into cache
    await images.loadAllImages();

    final world = Level01(player, spawnManager);

    cam = CameraComponent.withFixedResolution(world: world, width: 1920, height: 1080);
    cam.viewfinder.anchor = Anchor.topLeft;

    player = Player();
    hud = Hud(lives: lives, priority: 1);
    
    addAll([cam, world, hud ]);

    return super.onLoad();
    }
  Future<void> gameOver() async{
    await Future.delayed(Duration(seconds: 1));
    restartGameWidget();
    removeAll(children);
    await Future.delayed(Duration(seconds: 1));
    onLoad();

}
void restartGameWidget( ) {
  removeAll(children);
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => GamePage()),
  );
}


}


