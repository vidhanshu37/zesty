import 'package:rive/rive.dart';

class RiveUtils {
  static StateMachineController getRiveController(Artboard artboard, {stateMachineController = "State Machine 1"}) {
    StateMachineController? controller =
    StateMachineController.fromArtboard(artboard, stateMachineController);
    artboard.addController(controller!);
    return controller;
  }
}