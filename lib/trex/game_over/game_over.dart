import 'dart:ui';

import 'package:flame/components.dart';
import 'package:move/trex/game.dart';

import 'config.dart';

class GameOverPanel extends BaseComponent with HasGameRef<TRexGame> {
  GameOverPanel(
    Image spriteImage,
    GameOverConfig config,
  )   : gameOverText = GameOverText(spriteImage, config),
        gameOverRestart = GameOverRestart(spriteImage, config),
        super();

  bool visible = false;

  GameOverText gameOverText;
  GameOverRestart gameOverRestart;

  late final Paint _paint = Paint()..color = const Color.fromARGB(100, 0, 0, 0); //background color

  @override
  Future<void>? onLoad() {
    addChild(gameOverText);
    addChild(gameOverRestart);
    //addChild(gameOverExit);
    return super.onLoad();
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      final rect = Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y);
        canvas.drawRect(rect, _paint);
      super.renderTree(canvas);
    }
  }
}

class GameOverText extends SpriteComponent {
  GameOverText(Image spriteImage, this.config)
      : super(
          size: Vector2(config.textWidth, config.textHeight),
          sprite: Sprite(
            spriteImage,
            srcPosition: Vector2(1183.0, 30.0),
            srcSize: Vector2(
              config.textWidth,
              config.textHeight,
            ),
          ),
        );

  final GameOverConfig config;

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    y = gameSize.y * .25;
    x = (gameSize.x / 2) - config.textWidth / 2;
  }
}

class GameOverRestart extends SpriteComponent {
  GameOverRestart(
    Image spriteImage,
    this.config,
  ) : super(
          size: Vector2(config.restartWidth, config.restartHeight),
          sprite: Sprite(
            spriteImage,
            srcPosition: Vector2(1650.0, 18.0),
            srcSize: Vector2(config.restartWidth, config.restartHeight),
          ),
        );

  final GameOverConfig config;

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    y = gameSize.y / 2 - 20;
    x = (gameSize.x / 2) - config.restartWidth / 2; //game over button
  }
}

class GameOverExit extends SpriteComponent {
  GameOverExit(
      Image exitImage,
      this.config,
      ) : super(
    size: Vector2(config.restartWidth, config.restartHeight),
    sprite: Sprite(
      exitImage,
      srcPosition: Vector2(1532.0, 18.0),
      srcSize: Vector2(config.restartWidth, config.restartHeight),
    ),
  );

  final GameOverConfig config;

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    y = gameSize.y / 2 - 20;
    x = (gameSize.x / 2) - config.restartWidth;
  }
}
