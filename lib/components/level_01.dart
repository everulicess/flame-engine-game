
import 'dart:async';

import 'package:dodge_the_blocks/components/collisions.dart';
import 'package:dodge_the_blocks/components/obstacle_manager.dart';
import 'package:dodge_the_blocks/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level01 extends World{
  String levelName = "level 0.tmx";
  String backgroundmusicfilename = "background.mp3";
  final Player player;
  final ObstacleSpawnManager spawnManager;
  Level01(this.player, this.spawnManager);
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];
  ObstacleGroundCollision obstacleGroundBlock = ObstacleGroundCollision();
  List<ObstacleSpawners> spawnPoints = [];
  @override
  FutureOr<void> onLoad() async{
    level = await TiledComponent.load(levelName, Vector2.all(32));


    add(level);
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>("Spawnpoint");

    if (spawnPointLayer != null) {
      for (final spawnpoint in spawnPointLayer.objects){
        switch (spawnpoint.class_) {
          case "Player":
            player.position = Vector2(spawnpoint.x, spawnpoint.y);
            add(player);
            break;
          default:
        }
      }
    }


    final collisionsLayer =  level.tileMap.getLayer<ObjectGroup>("Collisions");

   if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
      
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        
      }
    }


    add(spawnManager);
    
    final obstaclesLayer = level.tileMap.getLayer<ObjectGroup>("Enemies");

    if (obstaclesLayer != null) {
      for (final element in obstaclesLayer.objects) {
        switch (element.class_) {
          case "Spawner":
          final spawn = ObstacleSpawners(
            position: element.position,
            size: Vector2(element.width, element.height)
          );
          spawnPoints.add(spawn);
          add(spawn);
            
            break;
          case "Ground":
          final ground = ObstacleGroundCollision(
            position: element.position,
            size: Vector2(element.width, element.height)
          );
            obstacleGroundBlock = ground;
            add(ground);
            break;
          default:
        }
        
      }
      
    }

    spawnManager.player= player;
    spawnManager.spawnPoints = spawnPoints;
    spawnManager.ground = obstacleGroundBlock;

    player.collisionBlocks = collisionBlocks;
    

     
    return super.onLoad();

  }
  
}