import 'package:dodge_the_blocks/components/obstacles.dart';
import 'package:dodge_the_blocks/components/player.dart';
import 'package:dodge_the_blocks/dodge_the_blocks.dart';
import 'package:flame/components.dart';
import 'dart:math';

class ObstacleGroundCollision extends PositionComponent{
  ObstacleGroundCollision({
    super.position,
    super.size
  }) {
    debugMode = true;
  }
}

class ObstacleSpawners extends PositionComponent{
  ObstacleSpawners({
    super.position,
    super.size
  }){debugMode = true;}
}

class ObstacleSpawnManager extends Component with HasGameRef<dodge_the_blocks>{
  late Timer timer;
  ObstacleGroundCollision ground = ObstacleGroundCollision();


  ObstacleSpawnManager(): super(){
    timer = Timer(1, onTick: _spawnObstacles, repeat: true);
  }

  Player player = Player();
  List<ObstacleSpawners> spawnPoints = [];
  List<String> obstacleSprites = ["obstacle_1.png", "obstacle_2.png"];


void _spawnObstacles(){

  Random random = Random();
  String spriteName = obstacleSprites[random.nextInt(obstacleSprites.length)];
  ObstacleSpawners spawner = spawnPoints[random.nextInt(spawnPoints.length)];

  Obstacle obstacle = Obstacle(
    obstacleName: spriteName,
    player: player,
    position: spawner.position,
    size: Vector2(70,70),
    speed: 400
  );
  obstacle.ground = ground;

  add(obstacle);
}

  @override
  void onMount() {
    super.onMount();
    timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
  }

}