import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slido/constants.dart';
import 'package:slido/controller/slido_controller.dart';

class Board extends StatefulWidget {
  const Board({
    Key? key,
  }) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> with WidgetsBindingObserver {
  String removedTiled = "";
  int timeTaken = 0;
  int moves = 0;
  int emptyTileIndex = 99;
  bool animation = false;
  bool pause = false;
  late Timer timer;
  List<String> choosenWords = [];
  List<WordModel> globalCompletedWords = [];
  List<String> globalcompletedWord = [];
  List animate = [];
  bool beginning = true;
  bool completo = false;
  bool _isInForeground = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
    if (!_isInForeground) {
      setState(() {
        pause = true;
      });
    } else {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  moveTime() {
    timer = Timer.periodic(const Duration(seconds: 1), (time) {
      if (!pause) {
        slido.buttonSound();
        setState(() {
          timeTaken++;
        });
      }
    });
  }

  @override
  void initState() {
    makeGame();

    WidgetsBinding.instance!.addObserver(this);

    super.initState();
  }

  makeGame() {
    List letters = [];
    int index = 0;
    removedTiled = "";
    timeTaken = 0;
    moves = 0;
    emptyTileIndex = 99;
    animation = false;
    choosenWords = [];
    globalCompletedWords = [];
    globalcompletedWord = [];
    animate = [];
    beginning = true;
    completo = false;
    pause = false;
    for (int i = 0; i < 5; i++) {
      String word = words[Random().nextInt(words.length)];
      choosenWords.add(word);
      for (int j = 0; j < 5; j++) {
        letters.add(word[j]);
      }
    }
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        state[i][j] = letters[index];
        index++;
        setState(() {});
      }
    }
  }

  removeTile() {
    slido.buttonSound();
    String choosenletter = choosenWords[choosenWords.length - 1][4];
    removedTiled = choosenletter;
    emptyTileIndex = 4 * 10 + 4;
    state[4][4] = "";
    setState(() {});
    Map lastmove = {"i": 9, "j": 9};
    do {
      for (int k = 0; k < 50; k++) {
        int i = emptyTileIndex ~/ 10;
        int j = emptyTileIndex % 10;
        List<Map> moves = [
          {"i": i - 1, "j": j},
          {"i": i, "j": j - 1},
          {"i": i + 1, "j": j},
          {"i": i, "j": j + 1},
        ];
        if (i == 0) {
          moves.removeAt(moves.indexWhere((element) => element["i"] == i - 1));
        }
        if (i == 4) {
          moves.removeAt(moves.indexWhere((element) => element["i"] == i + 1));
        }
        if (j == 0) {
          moves.removeAt(moves.indexWhere((element) => element["j"] == j - 1));
        }
        if (j == 4) {
          moves.removeAt(moves.indexWhere((element) => element["j"] == j + 1));
        }
        for (int j = 0; j < moves.length; j++) {
          // print(lastmove.toString() + "--->" + moves[j].toString());
          if (moves[j]["i"] == lastmove["i"] &&
              moves[j]["j"] == lastmove["j"]) {
            moves.removeAt(j);
            break;
          }
        }
        int random = Random().nextInt(moves.length);
        lastmove = {"i": emptyTileIndex ~/ 10, "j": emptyTileIndex % 10};
        move(moves[random]["i"], moves[random]["j"]);
        setState(() {});
      }
    } while (globalcompletedWord.isNotEmpty);
    if (globalcompletedWord.isEmpty) {
      timeTaken == 0 ? moveTime() : null;
      moves = 0;
      beginning = false;
    }
  }

  movelasttile() {
    slido.tileSound();
    removedTiled = state[4][4];
    state[4][4] = "";
    emptyTileIndex = 4 * 10 + 4;
    setState(() {});
  }

  move(i, j) {
    if (!pause) {
      //check top
      if (i > 0) {
        if (state[i - 1][j] == "") {
          beginning ? null : slido.tileSound();
          state[i - 1][j] = state[i][j];
          state[i][j] = "";
          emptyTileIndex = i * 10 + j;
          setState(() {});
          getAllcombinations();
          return;
        }
      }
      //check right
      if (j < 4) {
        if (state[i][j + 1] == "") {
          beginning ? null : slido.tileSound();
          state[i][j + 1] = state[i][j];
          state[i][j] = "";
          emptyTileIndex = i * 10 + j;
          setState(() {});
          getAllcombinations();
          return;
        }
      }
      //check left
      if (j > 0) {
        if (state[i][j - 1] == "") {
          beginning ? null : slido.tileSound();
          state[i][j - 1] = state[i][j];
          state[i][j] = "";
          emptyTileIndex = i * 10 + j;
          setState(() {});
          getAllcombinations();
          return;
        }
      }
      //check bottom
      if (i < 4) {
        if (state[i + 1][j] == "") {
          beginning ? null : slido.tileSound();
          state[i + 1][j] = state[i][j];
          state[i][j] = "";
          emptyTileIndex = i * 10 + j;
          setState(() {});
          getAllcombinations();
          return;
        }
      }
      slido.errorSound();
    }
  }

  getAllcombinations() async {
    moves++;
    setState(() {});
    List<String> newChosenWords = [...choosenWords];
    animate = [];
    List<WordModel> five = [];
    for (int i = 0; i < 5; i++) {
      WordModel word = WordModel(
          state[i][0] + state[i][1] + state[i][2] + state[i][3] + state[i][4],
          i + 1);
      if (word.word.length == 5) {
        five.add(word);
      }
      word = WordModel(
          state[0][i] + state[1][i] + state[2][i] + state[3][i] + state[4][i],
          (i + 1) * 10);
      if (word.word.length == 5) {
        five.add(word);
      }
    }

    List instanceWords = [for (WordModel word in five) word.word];
    List instanceLocations = [for (WordModel word in five) word.loc];
    List completedWords = [
      for (WordModel word in globalCompletedWords) word.word
    ];

    for (String goal in choosenWords) {
      // print(goal);
      if (instanceWords.contains(goal) && !completedWords.contains(goal)) {
        globalCompletedWords.add(
            WordModel(goal, instanceLocations[instanceWords.indexOf(goal)]));
        globalcompletedWord.add(goal);
        globalcompletedWord = globalcompletedWord.toSet().toList();
        newChosenWords.remove(goal);
        newChosenWords.add(goal);
        slido.wordFoundSound();
        setState(() {
          animation = true;
        });
        Future.delayed(const Duration(milliseconds: 300)).then((value) {
          setState(() {
            animation = false;
          });
        });
      } else if (!instanceWords.contains(goal) &&
          completedWords.contains(goal)) {
        globalCompletedWords.removeWhere((element) => element.word == goal);
        globalcompletedWord.remove(goal);
        setState(() {});
      }
    }
    choosenWords = newChosenWords;
    colorTiles();
    if (globalcompletedWord.length == 5) {
      setState(() {
        completo = true;
        pause = true;
      });
    }
  }

  colorTiles() {
    for (WordModel word in globalCompletedWords) {
      for (int i = 0; i < 5; i++) {
        if (word.loc < 10) {
          animate.add((word.loc - 1) * 10 + i);
        } else {
          animate.add((i * 10) + word.loc - 11);
        }
      }
    }
  }

  endGame() {
    if (!pause) {
      if (state[4][4] == "") {
        slido.tileSound();
        state[emptyTileIndex ~/ 10][emptyTileIndex % 10] = removedTiled;
        removedTiled = "";
        getAllcombinations();
        setState(() {});
      } else {
        slido.errorSound();
      }
    }
  }

  List<List<String>> state = [
    ["", "", "", "", ""],
    ["", "", "", "", ""],
    ["", "", "", "", ""],
    ["", "", "", "", ""],
    ["", "", "", "", ""],
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff79a9d1),
      body: SafeArea(
        child: Stack(children: [
          Center(
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: 470, minWidth: beginning ? 316 : 261),
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (int i = 0; i < 5; i++)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      for (int j = 0; j < 5; j++)
                        Padding(
                          padding: animate.contains(i * 10 + j) && animation
                              ? const EdgeInsets.fromLTRB(1, 6, 1, 6)
                              : const EdgeInsets.all(6.0),
                          child: state[i][j] == ""
                              ? Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 80,
                                    maxHeight: 80,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  color: Colors.transparent,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    removedTiled == "" &&
                                            i == 4 &&
                                            j == 4 &&
                                            !beginning
                                        ? movelasttile()
                                        : move(i, j);
                                  },
                                  child: Box(
                                    animate: animate,
                                    i: i,
                                    j: j,
                                    state: state,
                                    beginning: beginning,
                                  ),
                                ),
                        )
                    ]),
                  removedTiled == ""
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: endGame,
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 80,
                              maxHeight: 80,
                            ),
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: const Color(0xff79a9d1),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0xff7d8ca3),
                                      offset: Offset(3, 3),
                                      blurRadius: 4,
                                      spreadRadius: 4)
                                ]),
                            child: Center(
                                child: Text(
                              removedTiled,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            )),
                          ),
                        ),
                ],
              ),
            ),
          ),
          beginning
              ? const SizedBox()
              : Positioned(
                  bottom: 0,
                  child: Container(
                    height: 164,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff7d8ca3),
                              offset: Offset(3, 3),
                              blurRadius: 8,
                              spreadRadius: 8),
                          BoxShadow(
                              color: Color(0xff79a9d1),
                              offset: Offset(3, 3),
                              blurRadius: 12,
                              spreadRadius: 12)
                        ],
                        color: Color(0xff79a9d1),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(64))),
                    child: Column(children: [
                      const SizedBox(height: 16),
                      const Text(
                        "FIND THOSE WORDS",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 12,
                            children: [
                              for (int i = 0; i < choosenWords.length; i++)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Text(
                                    choosenWords[i],
                                    style: TextStyle(
                                        color: globalcompletedWord
                                                .contains(choosenWords[i])
                                            ? const Color(0xffd1a078)
                                            : Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22),
                                  ),
                                )
                            ]),
                      ),
                    ]),
                  )),
          beginning
              ? Positioned(
                  top: 58,
                  left: MediaQuery.of(context).size.width * 0.5 - 150,
                  child: const SizedBox(
                    width: 300,
                    child: Center(
                      child: Text(
                        "Find those five words to complete the puzzle",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ))
              : const SizedBox(),
          beginning
              ? Positioned(
                  bottom: 58,
                  left: MediaQuery.of(context).size.width * 0.5 - 150,
                  child: GestureDetector(
                    onTap: removeTile,
                    child: const SizedBox(
                      width: 300,
                      child: Center(
                        child: Text(
                          "Tap to start",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ))
              : const SizedBox(),
          beginning
              ? Positioned(
                  top: 124,
                  left: MediaQuery.of(context).size.width * 0.5 - 150,
                  child: SizedBox(
                      width: 300,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          for (int i = 0; i < choosenWords.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                choosenWords[i],
                                style: const TextStyle(
                                    letterSpacing: 2,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                            )
                        ],
                      )))
              : const SizedBox(),
          beginning
              ? const SizedBox()
              : Positioned(
                  top: 20,
                  left: 32,
                  child: Center(
                    child: Text(
                      timeTaken.toString().padLeft(4, "0"),
                      style: const TextStyle(
                          fontFamily: "Digital",
                          fontSize: 48,
                          color: Colors.white),
                    ),
                  )),
          beginning
              ? const SizedBox()
              : Positioned(
                  top: 20,
                  left: MediaQuery.of(context).size.width * 0.5 - 20,
                  child: SizedBox(
                      width: 40,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (pause) {
                              setState(() {
                                pause = !pause;
                                slido.resumeBackgroundMusic();
                              });
                            } else {
                              setState(() {
                                pause = !pause;
                                slido.pauseBackgroundMusic();
                              });
                            }
                          },
                          child: Icon(
                            pause ? Icons.play_arrow : Icons.pause,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ))),
          beginning
              ? const SizedBox()
              : GetBuilder<Slido>(
                  init: slido,
                  builder: (val) {
                    return Positioned(
                        top: MediaQuery.of(context).size.height * 0.5,
                        right: 16,
                        child: GestureDetector(
                          onTap: () {
                            if (val.gameSound ||
                                val.uiSound ||
                                val.backGroundMusic) {
                              val.stopBackgroundMusic();
                              val.uiSound = false;
                              val.gameSound = false;
                            } else {
                              val.playBackgroundMusic();
                              val.uiSound = true;
                              val.gameSound = true;
                            }
                          },
                          child: Icon(
                            val.gameSound || val.uiSound || val.backGroundMusic
                                ? Icons.music_off
                                : Icons.music_note,
                            color: Colors.white,
                          ),
                        ));
                  }),
          beginning
              ? const SizedBox()
              : Positioned(
                  top: 20,
                  right: 32,
                  child: Center(
                    child: Text(
                      moves.toString(),
                      style: const TextStyle(
                          fontFamily: "Digital",
                          fontSize: 48,
                          color: Colors.white),
                    ),
                  )),
          pause
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      completo ? null : pause = !pause;
                    });
                  },
                  child: Container(
                    color: Colors.black38,
                    child: Center(
                      child: Card(
                          elevation: 8,
                          child: SizedBox(
                            height: 140,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  completo
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              "Completed in $moves moves and $timeTaken seconds",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Color(0xff79a9d1),
                                                  fontSize: 24)),
                                        )
                                      : const SizedBox(),
                                  completo
                                      ? const SizedBox(height: 16)
                                      : const SizedBox(),
                                  SizedBox(
                                    width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (pause) {
                                                setState(() {
                                                  completo ? makeGame() : null;
                                                  pause = !pause;
                                                  slido.resumeBackgroundMusic();
                                                });
                                              } else {
                                                setState(() {
                                                  pause = !pause;
                                                  slido.pauseBackgroundMusic();
                                                });
                                              }
                                            },
                                            child: Icon(
                                              completo
                                                  ? Icons.restart_alt
                                                  : Icons.play_arrow,
                                              size: 32,
                                              color: const Color(0xff79a9d1),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 32,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: const Icon(
                                              Icons.home,
                                              size: 32,
                                              color: Color(0xff79a9d1),
                                            ),
                                          ),
                                          kIsWeb
                                              ? const SizedBox()
                                              : const SizedBox(
                                                  width: 32,
                                                ),
                                          kIsWeb
                                              ? const SizedBox()
                                              : GestureDetector(
                                                  onTap: () {
                                                    exit(0);
                                                  },
                                                  child: const Icon(
                                                    Icons.exit_to_app_sharp,
                                                    size: 28,
                                                    color: Color(0xff79a9d1),
                                                  ),
                                                )
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          )),
                    ),
                  ),
                )
              : const SizedBox()
        ]),
      ),
    );
  }
}

class Box extends StatefulWidget {
  const Box({
    Key? key,
    required this.animate,
    required this.i,
    required this.j,
    required this.state,
    required this.beginning,
  }) : super(key: key);

  final List animate;
  final int i;
  final int j;
  final bool beginning;
  final List<List<String>> state;

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> with SingleTickerProviderStateMixin {
  late Timer timer;
  @override
  void initState() {
    super.initState();
    animate();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  int val = 0;
  List<Alignment> alignments = [
    Alignment.center,
    Alignment.centerLeft,
    Alignment.centerRight,
    Alignment.topCenter,
    Alignment.bottomCenter
  ];
  animate() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (widget.beginning) val = Random().nextInt(5);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 82,
        maxHeight: 82,
      ),
      width: widget.beginning
          ? MediaQuery.of(context).size.width * 0.13
          : MediaQuery.of(context).size.width * 0.102,
      height: widget.beginning
          ? MediaQuery.of(context).size.width * 0.13
          : MediaQuery.of(context).size.width * 0.102,
      alignment: widget.beginning ? alignments[val] : Alignment.center,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 80,
          maxHeight: 80,
        ),
        width: widget.beginning
            ? MediaQuery.of(context).size.width * 0.12
            : MediaQuery.of(context).size.width * 0.1,
        height: widget.beginning
            ? MediaQuery.of(context).size.width * 0.12
            : MediaQuery.of(context).size.width * 0.1,
        decoration: BoxDecoration(
            color: widget.animate.contains(widget.i * 10 + widget.j)
                ? const Color(0xffd1a078)
                : const Color(0xff79a9d1),
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                  color: Color(0xff7d8ca3),
                  offset: Offset(3, 3),
                  blurRadius: 4,
                  spreadRadius: 4)
            ]),
        child: Center(
            child: Text(
          widget.state[widget.i][widget.j],
          style: const TextStyle(fontSize: 20, color: Colors.white),
        )),
      ),
    );
  }
}

class WordModel {
  String word;
  int loc;
  WordModel(this.word, this.loc);
}
