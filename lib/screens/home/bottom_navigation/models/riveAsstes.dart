import 'package:rive/rive.dart';

class RiveAssets {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAssets(this.src,
      {required this.artboard,
        required this.stateMachineName,
        required this.title,
        this.input});

  set setInput(SMIBool status) {
    input = status;
  }
}

List<RiveAssets> bottomNavs = [
  RiveAssets('assets/icons/anim_icon.riv',
      artboard: "HOME", stateMachineName: "HOME_Interactivity", title: "Home"),
  RiveAssets('assets/icons/anim_icon.riv',
      artboard: "SEARCH",
      stateMachineName: "SEARCH_Interactivity",
      title: "Search"),
  RiveAssets('assets/icons/anim_icon.riv',
      artboard: "CHAT", stateMachineName: "CHAT_Interactivity", title: "Chat"),
  RiveAssets('assets/icons/anim_icon.riv',
      artboard: "USER",
      stateMachineName: "USER_Interactivity",
      title: "Profile"),
];
