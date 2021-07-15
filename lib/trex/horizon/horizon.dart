import 'package:flame/components.dart';

import '../game.dart';
import 'horizon_line.dart';

class Horizon extends PositionComponent with HasGameRef<TRexGame> {
  late final horizonLine = HorizonLine();

  @override
  Future<void>? onLoad() {
    addChild(horizonLine);
  }

  @override
  void update(double dt) {
    y = gameRef.size.y / 1.2; //sand height
    super.update(dt);
  }

  void reset() {
    horizonLine.reset();
  }
}
