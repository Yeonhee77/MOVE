import 'dart:ui' as ui;
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:move/trex/game_over/config.dart';
import 'package:move/trex/horizon/horizon.dart';
import 'package:move/trex/game_config.dart';
import 'package:move/trex/game_over/game_over.dart';
import 'package:move/trex/obstacle/obstacle.dart';
import 'package:move/trex/t_rex/t_rex.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'collision/collision_utils.dart';

class Bg extends Component with HasGameRef {
  Vector2 size = Vector2.zero();

  late final ui.Paint _paint = ui.Paint()..color = const ui.Color(0xffffffff);

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
  ui.Color backgroundColor() => const ui.Color(0xFFFFFFFF);

  final ui.Image spriteImage;

  /// children
  late final tRex = TRex();
  late final horizon = Horizon();
  late final gameOverPanel = GameOverPanel(spriteImage, GameOverConfig());

  @override
  Future<void> onLoad() async {
    add(Bg());
    add(horizon);
    add(tRex);
    add(gameOverPanel);
  }

  // state
  late TRexGameStatus status = TRexGameStatus.waiting;
  late double currentSpeed = 0.0;
  late double timePlaying = 0.0;

  bool get playing => status == TRexGameStatus.playing;
  bool get gameOver => status == TRexGameStatus.gameOver;

  var result;

  //bluetooth services
  List<BluetoothService>? bluetoothServices;
  final StreamController<int> _streamController = StreamController<int>();
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  String gesture = "";
  int gesture_num = 0;

  @override
  void dispose(){
    _streamController.close();
  }

  Future<List<ButtonTheme>> _buildReadWriteNotifyButton(BluetoothCharacteristic characteristic) async {
    // ignore: deprecated_member_use
    List<ButtonTheme> buttons = [];
    if (characteristic.properties.notify) {
      characteristic.value.listen((value) {
        readValues[characteristic.uuid] = value;
      });
      await characteristic.setNotifyValue(true);
    }
    if (characteristic.properties.read && characteristic.properties.notify) {
      setnum(characteristic);
    }
    return buttons;
  }

  Future<void> setnum(characteristic) async {
    var sub = characteristic.value.listen((value) {
        readValues[characteristic.uuid] = value;
        gesture = value.toString();
        gesture_num = int.parse(gesture[1]);
    });

    await characteristic.read();
    sub.cancel();

    callAction ();
  }

  void callAction () {
    if (gesture_num == 3)
    {
      onAction();
      print('gesture nu : ' + gesture_num.toString());
    }

  }

  void onAction() {
    if (gameOver) {
      restart();
      return;
    }

     tRex.startJump(currentSpeed);
  }

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
