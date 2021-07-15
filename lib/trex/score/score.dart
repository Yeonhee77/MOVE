import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:move/trex/game.dart';
import 'package:move/trex/trex_main.dart';
import 'package:flame/components.dart';
import 'config.dart';


class ScorePanel extends BaseComponent with HasGameRef<TRexGame> {
  ScorePanel(
      Image spriteImage,
      ScoreConfig config,
      )   : scoreText = ScoreText(spriteImage, config),
        super();

  bool visible = false;

  ScoreText scoreText;

  @override
  Future<void>? onLoad() {
    addChild(scoreText);
    return super.onLoad();
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}

class ScoreText extends SpriteComponent {
  ScoreText(Image spriteImage, this.config)
      : super(
    size: Vector2(config.scoreWidth, config.scoreHeight),
    sprite: Sprite(
      spriteImage,
      srcPosition: Vector2(955.0, 0.0),
      srcSize: Vector2(
        config.scoreWidth,
        config.scoreHeight,
      ),
    ),
  );

  final ScoreConfig config;

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    y = gameSize.y * .25;
    x = (gameSize.x / 2) - config.scoreWidth / 2;
  }
}
