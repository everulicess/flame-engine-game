import 'dart:async';

import 'package:dodge_the_blocks/components/collisions.dart';
import 'package:dodge_the_blocks/components/utils.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:dodge_the_blocks/dodge_the_blocks.dart';

enum PlayerState {
  idle,
  running,
  damaged
}

class Player extends SpriteAnimationGroupComponent with HasGameRef<dodge_the_blocks>, KeyboardHandler, CollisionCallbacks {

  //constructor
  Player({super.position});

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation damagedAnimation;

  final double stepTime = 0.15;

  //references for the images witht he animations
  final String idleAnimationName = "player_idle.png";
  final String runningAnimationName = "player_running.png";
  final String damagedAnimationName = "player_damaged.png";

  double horizontalMovement = 0;
  double moveSpeed = 300;
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async{
    _loadAllAnimations();
    
    return super.onLoad();
  }


  @override
void update(double dt) {
    _updatePlayerState(null);
    _updatePlayerMovement(dt);
    _checkHorizontalCollisions();
    super.update(dt);
}
  
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight);
    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    return super.onKeyEvent(event, keysPressed);
  }


void _loadAllAnimations() {
    //IDLE Animation
    idleAnimation = _spriteAnimation(idleAnimationName, 1, Vector2(96,128));

    //RUNNING Animation
    runningAnimation = _spriteAnimation(runningAnimationName, 3, Vector2(96,128));

    //DAMAGED Animation
    damagedAnimation = _spriteAnimation(damagedAnimationName, 1, Vector2(96,128));

    //List of the animations for each state
    animations = {
      PlayerState.idle : idleAnimation,
      PlayerState.running : runningAnimation,
      PlayerState.damaged : damagedAnimation
      };
    //Set current animation
    current = PlayerState.idle;


  }

  SpriteAnimation _spriteAnimation(String spritename, int framesamount, Vector2 texturesize ){
    return  SpriteAnimation.fromFrameData(
      game.images.fromCache(spritename),
    SpriteAnimationData.sequenced(
      amount: framesamount, //number of images in the animation
      stepTime: stepTime, 
      textureSize: texturesize //images size
      )
    );


  }
  
void _updatePlayerMovement(double dt) {

  velocity.x = horizontalMovement * moveSpeed;
  position.x += velocity.x * dt;
}
  
void _updatePlayerState(PlayerState? state) {
  PlayerState playerState = PlayerState.idle;
  if (velocity.x < 0 && scale.x > 0) {
    flipHorizontallyAroundCenter();
  } else if (velocity.x > 0 && scale.x < 0){
    flipHorizontallyAroundCenter();
  }

  if (velocity.x > 0 || velocity.x < 0) {
    playerState = PlayerState.running;
  }
  

  current =  playerState;
}

 void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (checkCollision(this, block)) {
        if (velocity.x > 0) {
          velocity.x = 0;
          position.x = block.x - width;
        }
        if (velocity.x < 0) {
          velocity.x = 0;
          position.x = block.x + block.width + width;
        }
      }
    }
  }
 
 
}

