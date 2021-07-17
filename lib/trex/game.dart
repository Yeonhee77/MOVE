import 'dart:ui' as ui;
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:move/trex/game_over/config.dart';
import 'package:move/trex/horizon/horizon.dart';
import 'package:move/trex/game_config.dart';
import 'package:move/trex/game_over/game_over.dart';
import 'package:move/trex/obstacle/obstacle.dart';
import 'package:move/trex/t_rex/t_rex.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'collision/collision_utils.dart';
import 'horizon/clouds.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'horizon/config.dart';

class Bg extends Component with HasGameRef {
  Vector2 size = Vector2.zero();

  late final ui.Paint _paint = ui.Paint()..color = const ui.Color.fromARGB(250, 255, 255, 255); //background color

  @override
  void render(ui.Canvas c) {
    final rect = ui.Rect.fromLTWH(0, 0, size.x, size.y);
    c.drawRect(rect, _paint);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    size = gameSize;
  }
}

enum TRexGameStatus { playing, waiting, gameOver }

class TRexGame extends BaseGame with TapDetector {

  TRexGame( {
    required this.spriteImage,
  }) : super();

  late final config = GameConfig();

  @override
  ui.Color backgroundColor() => const ui.Color.fromARGB(250, 255, 255, 255);

  final ui.Image spriteImage;

  /// children
  late final tRex = TRex();
  late final horizon = Horizon();
  late final gameOverPanel = GameOverPanel(spriteImage, GameOverConfig());
  late final cloud = Cloud();
  SpriteComponent sun = SpriteComponent();
  SpriteComponent back = SpriteComponent();

  @override
  Future<void> onLoad() async {
    add(Bg());
    back
      ..sprite = await loadSprite('dino_bg.png')
      ..size = Vector2(650, 375)
      ..x = 0
      ..y = 0;
    add(back);
    add(cloud);
    add(horizon);
    add(tRex);
    add(gameOverPanel);
    sun
      ..sprite = await loadSprite('sun.png')
      ..size = Vector2(40.0, 30.0)
      ..x = 475
      ..y = 65;
    add(sun);
  }

  // state
  late TRexGameStatus status = TRexGameStatus.waiting;
  late double currentSpeed = 0.0;
  late double timePlaying = 0.0;
  late int score = -1;

  bool get playing => status == TRexGameStatus.playing;
  bool get gameOver => status == TRexGameStatus.gameOver;

  var result;
  late int final_score = 0;
  late int temp = 0;

  //bluetooth services
  final StreamController<int> _streamController = StreamController<int>();
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();


  @override
  void dispose(){
    _streamController.close();
  }

  void onAction(int gesture_num) {
    if (gameOver) {
      restart();
    }

    if(gesture_num == 2 && !gameOver) {
      this.score += 1;
      tRex.startJump(currentSpeed);
    }
  }

  int returnScore() {
    this.final_score = this.score;
    return this.score;
  }

  int getFinalScore() {
    if (gameOver)
      return this.final_score;
    else
      return -1;
  }

  //
  // int getFinalScore() {
  //   if (gameOver)
  //     return this.final_score;
  //   else
  //     return -1;
  // }

  void startGame() {
    tRex.status = TRexStatus.running;
    status = TRexGameStatus.playing;
    tRex.hasPlayedIntro = true;
    currentSpeed = config.speed;
  }

  void doGameOver() {
    gameOverPanel.visible = true;
    status = TRexGameStatus.gameOver;
    tRex.status = TRexStatus.crashed;
    currentSpeed = 0.0;
  }

  void restart() {
    status = TRexGameStatus.playing;
    tRex.reset();
    horizon.reset();
    currentSpeed = config.speed;
    gameOverPanel.visible = false;
    timePlaying = 0.0;
    this.score = 0;
    this.final_score = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameOver) {
      return;
    }

    if (tRex.playingIntro && tRex.x >= tRex.config.startXPos) {
      startGame();
    } else if (tRex.playingIntro) {}

    if (playing) {
      timePlaying += dt;

      final obstacles = horizon.horizonLine.obstacleManager.children;
      final hasCollision = obstacles.isNotEmpty &&
          checkForCollision(obstacles.first as Obstacle, tRex);
      if (!hasCollision) {
        if (currentSpeed < config.maxSpeed) {
          currentSpeed += config.acceleration;
        }
      } else {
        doGameOver();
      }
    }
  }

}