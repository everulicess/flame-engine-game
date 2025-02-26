import 'dart:async';

import 'package:dodge_the_blocks/dodge_the_blocks.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

class Hud extends Component with HasGameRef<dodge_the_blocks>{
  int lives = 0;
  Hud({super.children, super.priority, this.lives = 0}) : super();
  Vector2 hudposition = Vector2(250,64);


  @override
  FutureOr<void> onLoad() {
    final scoreTextComponent = TextComponent(text:"Score: 0", position: hudposition);
    add(scoreTextComponent);

    final HealthManager health = HealthManager(numberoflives: lives);
    add(health);

    gameRef.data.score.addListener(() {scoreTextComponent.text = "Score: ${gameRef.data.score.value}";});
    //gameRef.data.lives.addListener(() { health.updatehearts();});
    
    return super.onLoad();
  }
}

class Data{
  final score = ValueNotifier<int>(0);
  final lives = ValueNotifier<int>(3);
}

class HealthManager extends PositionComponent with HasGameRef<dodge_the_blocks>{
  int numberoflives = 0;
  Vector2 startingposition = Vector2.zero();
  HealthManager({this.numberoflives = 0, super.position}) : super();
  List<Lives> hearts = [];
  int currentHearts = 3;


  @override
  FutureOr<void> onLoad() {
    startingposition = position;
    startingposition.x += 64;
    for (var i = 0; i < numberoflives; i++) {
      Lives heart = Lives(state: HeartState.full);
      heart.position = startingposition;
      startingposition.x += 32;
      add(heart);
      hearts.add(heart);

      currentHearts = numberoflives;
      gameRef.data.lives.addListener(() {updatehearts();});
      
    }
    return super.onLoad();
  }
  void updatehearts(){
    print("updating heart ${currentHearts}");
    if (hearts.isNotEmpty) {
      currentHearts = gameRef.data.lives.value;
      Lives heart = hearts[hearts.length-1];
      remove(hearts[currentHearts]);
      hearts.remove(heart);
    }
    

  }

}

class Lives extends SpriteComponent with HasGameRef<dodge_the_blocks>{
  HeartState state;
  Lives({ this.state = HeartState.full, super.position}) : super();
  late Sprite fullSprite;
  late Sprite emptySprite;
  String fullSpriteName = "full_heart_32px.png";
  String emptySpriteName = "empty_heart_32px.png";
  


 
 @override
  FutureOr<void> onLoad() async {
    fullSprite = await gameRef.loadSprite(fullSpriteName);
    emptySprite = await gameRef.loadSprite(emptySpriteName);
    sprite = fullSprite;

    return super.onLoad();
  }

  void _changeState() async{
    sprite = emptySprite;
  }
  

}
enum HeartState{
  full,
  empty
}