import 'dart:ui';

import 'package:flame/components.dart';
import 'package:move/trex/game_over/config.dart';
import '../custom/util.dart';
import '../game.dart';
import 'config.dart';

class Cloud extends SpriteComponent {
  Cloud(Image spriteImage)
    : super(
        size: Vector2(575, 50),
        sprite: Sprite(
          spriteImage,
          srcPosition: Vector2(380.0, 10.0),
          srcSize: Vector2(
            575,
            50,
          ),
        ),
  );

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    y = gameSize.y * 0.2 - 10;
    x = 20;
  }
}