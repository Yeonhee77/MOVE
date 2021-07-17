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
    srcPosition: Vector2(530.0, 10.0),
    srcSize: Vector2(420, 50),
  );

  late final cloudSprite1 = Sprite(
    gameRef.spriteImage,
    srcPosition: Vector2(530.0, 10.0),
    srcSize: Vector2(420, 50),
  );

  late final cloudGround = HorizonCloud(cloudSprite);
  late final cloudGround1 = HorizonCloud1(cloudSprite1);

  @override
  void onMount() {
    addChild(cloudGround);
    addChild(cloudGround1);
    super.onMount();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    y = gameSize.y * 0.2;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (cloudGround.x <= -600) cloudGround.x = 600;
    else cloudGround.x -= 0.75;

    if(cloudGround1.x <= -600) cloudGround1.x = 600;
    else cloudGround1.x -= 0.75;

  }

}

class HorizonCloud extends SpriteComponent {
  HorizonCloud(Sprite sprite)
    : super(
        size: Vector2(600, 60),  //cloud sprite size
        sprite: sprite,
        position: Vector2(25, 15)
  );
}

class HorizonCloud1 extends SpriteComponent {
  HorizonCloud1(Sprite sprite)
      : super(
      size: Vector2(600, 60),  //cloud sprite size
      sprite: sprite,
      position: Vector2(600, 15)
  );
}