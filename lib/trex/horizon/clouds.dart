import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:move/trex/game_over/config.dart';
import '../custom/util.dart';
import '../game.dart';
import 'config.dart';

class Cloud extends PositionComponent with HasGameRef<TRexGame> {
  late final cloudSprite = Sprite(
    gameRef.spriteImage,
    srcPosition: Vector2(380.0, 10.0),
    srcSize: Vector2(575, 50),
  );


  late final cloudGround = HorizonCloud(cloudSprite);

  @override
  void onMount() {
    addChild(cloudGround);
    super.onMount();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    y = gameSize.y * 0.2 - 10;
    x = 10;
  }

  @override
  void update(double dt) {
    super.update(dt);
    cloudGround.x -= 1;
  }

  void reset() {
    cloudGround.x = 10;
    cloudGround.y = 10;
  }
}

class HorizonCloud extends SpriteComponent {
  HorizonCloud(Sprite sprite)
    : super(
        size: Vector2(700, 70),
        sprite: sprite,
  );
}