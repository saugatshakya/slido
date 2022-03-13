import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slido/Presentation/board.dart';
import 'package:slido/Presentation/settings.dart';
import 'package:slido/controller/slido_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with WidgetsBindingObserver {
  late Timer timer;
  List letters = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z"
  ];
  List<Map> letterWidgetProperties = [];
  List<Widget> lettersWidget = [];
  setup() async {
    bool extend = kIsWeb ? kIsWeb : Platform.isWindows;
    for (int i = 0; i < 600; i++) {
      Map property = {
        "letter": letters[Random().nextInt(letters.length)],
        "depth": Random().nextInt(5) + 1,
        "top": (Random().nextInt(200) + 20) * -1.0,
        "left": Random().nextInt((extend
                    ? window.physicalSize.longestSide
                    : window.physicalSize.shortestSide /
                        window.devicePixelRatio)
                .floor()) *
            1.0
      };
      letterWidgetProperties.add(property);
    }
  }

  beginAnim() {
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      for (int i = 0; i < letterWidgetProperties.length; i++) {
        if (letterWidgetProperties[i]["top"] >=
            window.physicalSize.longestSide / window.devicePixelRatio) {
          letterWidgetProperties[i]["left"] = Random().nextInt(
                  (window.physicalSize.shortestSide / window.devicePixelRatio)
                      .floor()) *
              1.0;
          letterWidgetProperties[i]["top"] = (Random().nextInt(80) + 40) * -1.0;
          letterWidgetProperties[i]["depth"] = Random().nextInt(5) + 1;
          letterWidgetProperties[i]["letter"] =
              letters[Random().nextInt(letters.length)];
        }
        letterWidgetProperties[i]["top"] = letterWidgetProperties[i]["top"] +
            (4 * (letterWidgetProperties[i]["depth"] + 1));
        setState(() {});
      }
    });
  }

  bool _isInForeground = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
    _isInForeground
        ? slido.backGroundMusic
            ? slido.resumeBackgroundMusic()
            : null
        : slido.pauseBackgroundMusic();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    slido.init();
    WidgetsBinding.instance!.addObserver(this);
    setup();
    beginAnim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff79a9d1),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                left: (MediaQuery.of(context).size.width / 2) - 100,
                child: Container(
                  color: Colors.white,
                  width: 200,
                  padding: const EdgeInsets.all(8),
                  child: const Center(
                    child: Text(
                      "Slido",
                      style: TextStyle(
                          fontSize: 64,
                          color: Color(0xff79a9d1),
                          shadows: [Shadow(color: Color(0xff7d8ca3))]),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                left: (MediaQuery.of(context).size.width / 2) - 64,
                child: Container(
                  color: Colors.white,
                  width: 128,
                  padding: const EdgeInsets.all(4),
                  child: const Center(
                    child: Text(
                      "Play",
                      style: TextStyle(
                          fontSize: 32,
                          color: Color(0xff79a9d1),
                          shadows: [Shadow(color: Color(0xff7d8ca3))]),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.5,
                left: (MediaQuery.of(context).size.width / 2) - 64,
                child: Container(
                  color: Colors.white,
                  width: 128,
                  padding: const EdgeInsets.all(4),
                  child: const Center(
                    child: Text(
                      "Settings",
                      style: TextStyle(
                          fontSize: 32,
                          color: Color(0xff79a9d1),
                          shadows: [Shadow(color: Color(0xff7d8ca3))]),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.6,
                left: (MediaQuery.of(context).size.width / 2) - 64,
                child: GestureDetector(
                  onTap: () async {
                    slido.buttonSound();
                  },
                  child: Container(
                    color: Colors.white,
                    width: 128,
                    padding: const EdgeInsets.all(4),
                    child: const Center(
                      child: Text(
                        "Scores",
                        style: TextStyle(
                            fontSize: 32,
                            color: Color(0xff79a9d1),
                            shadows: [Shadow(color: Color(0xff7d8ca3))]),
                      ),
                    ),
                  ),
                ),
              ),
              kIsWeb
                  ? const SizedBox()
                  : Positioned(
                      top: MediaQuery.of(context).size.height * 0.7,
                      left: (MediaQuery.of(context).size.width / 2) - 64,
                      child: GestureDetector(
                        onTap: () async {
                          slido.buttonSound();
                        },
                        child: Container(
                          color: Colors.white,
                          width: 128,
                          padding: const EdgeInsets.all(4),
                          child: const Center(
                            child: Text(
                              "Exit",
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Color(0xff79a9d1),
                                  shadows: [Shadow(color: Color(0xff7d8ca3))]),
                            ),
                          ),
                        ),
                      ),
                    ),
              for (int i = 0; i < letterWidgetProperties.length; i++)
                Positioned(
                    top: letterWidgetProperties[i]["top"],
                    left: letterWidgetProperties[i]["left"],
                    child: Transform.rotate(
                      angle: Random().nextInt(12) * 1.0,
                      origin: Offset(
                          Random().nextInt(3) * 1.0, Random().nextInt(3) * 1.0),
                      child: Text(
                        letterWidgetProperties[i]["letter"],
                        style: TextStyle(
                          color: letterWidgetProperties[i]["depth"] == 5
                              ? Colors.white70
                              : letterWidgetProperties[i]["depth"] == 4
                                  ? Colors.white60
                                  : letterWidgetProperties[i]["depth"] == 3
                                      ? Colors.white54
                                      : letterWidgetProperties[i]["depth"] == 2
                                          ? Colors.white38
                                          : letterWidgetProperties[i]
                                                      ["depth"] ==
                                                  1
                                              ? Colors.white30
                                              : Colors.white24,
                          fontSize: letterWidgetProperties[i]["depth"] == 0
                              ? 32
                              : letterWidgetProperties[i]["depth"] * 5 < 10
                                  ? letterWidgetProperties[i]["depth"] * 8.0
                                  : letterWidgetProperties[i]["depth"] * 5.0,
                        ),
                      ),
                    )),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                left: (MediaQuery.of(context).size.width / 2) - 100,
                child: GestureDetector(
                  onTap: () async {
                    slido.buttonSound();
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: 200,
                    height: 90,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                left: (MediaQuery.of(context).size.width / 2) - 64,
                child: GestureDetector(
                  onTap: () async {
                    slido.buttonSound();
                    Get.to(() => const Board());
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 46,
                    width: 128,
                    padding: const EdgeInsets.all(4),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.5,
                left: (MediaQuery.of(context).size.width / 2) - 64,
                child: GestureDetector(
                  onTap: () async {
                    if (!kIsWeb) {
                      if (!Platform.isWindows) {
                        slido.buttonSound();

                        Get.to(() => const Settings());
                      }
                    } else {
                      slido.buttonSound();

                      Get.to(() => const Settings());
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 46,
                    width: 128,
                    padding: const EdgeInsets.all(4),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.6,
                left: (MediaQuery.of(context).size.width / 2) - 64,
                child: GestureDetector(
                  onTap: () async {
                    slido.buttonSound();
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 46,
                    width: 128,
                    padding: const EdgeInsets.all(4),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.7,
                left: (MediaQuery.of(context).size.width / 2) - 64,
                child: GestureDetector(
                  onTap: () async {
                    slido.buttonSound();
                    exit(0);
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 46,
                    width: 128,
                    padding: const EdgeInsets.all(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
