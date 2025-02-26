
import 'package:dodge_the_blocks/dodge_the_blocks.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  

  //dodge_the_blocks mygame = dodge_the_blocks();
  //runApp(GameWidget(game: kDebugMode ? dodge_the_blocks() : mygame));
  runApp(MaterialApp(
    home: GamePage(),
  ));
  //GameWidget(game: dodge_the_blocks())
}
class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: dodge_the_blocks(context)),
    );
  }
}