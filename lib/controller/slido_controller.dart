import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class Slido extends GetxController {
  bool backGroundMusic = false;
  bool uiSound = true;
  bool gameSound = true;
  double backgroungMusicVolume = 0.1;
  double uiVolume = 0.1;
  double gameVolume = 0.05;

  AudioPlayer player = AudioPlayer();
  AudioCache audioCache = AudioCache();

  AudioPlayer uiPlayer = AudioPlayer();
  AudioCache uiCache = AudioCache();

  AudioPlayer gamePlayer = AudioPlayer();
  AudioCache gameCache = AudioCache();

  init() {
    if (!kIsWeb) {
      if (!Platform.isWindows) {
        player.setVolume(backgroungMusicVolume);
        uiPlayer.setVolume(uiVolume);
        gamePlayer.setVolume(gameVolume);
        playBackgroundMusic();
      }
    } else {
      player.setVolume(backgroungMusicVolume);
      uiPlayer.setVolume(0);
      gamePlayer.setVolume(0);
      playBackgroundMusic();
    }
  }

  playBackgroundMusic() async {
    if (!kIsWeb) {
      if (!backGroundMusic && !Platform.isWindows) {
        player.stop();
        audioCache.load("backgroundMusic.mp3");
        backGroundMusic = true;
        player = await audioCache.loop("backgroundMusic.mp3");
        player.setVolume(backgroungMusicVolume);
      }
    } else if (!backGroundMusic) {
      player.stop();
      audioCache.load("backgroundMusic.mp3");
      backGroundMusic = true;
      player = await audioCache.loop("backgroundMusic.mp3");
      player.setVolume(backgroungMusicVolume);
    }
    update();
  }

  playUIsound() async {
    if (!kIsWeb) {
      if (!uiSound && !Platform.isWindows) {
        uiSound = true;
      }
    } else if (!uiSound) {
      uiSound = true;
    }
    update();
  }

  playGameSound() async {
    if (!kIsWeb) {
      if (!gameSound && !Platform.isWindows) {
        gameSound = true;
      }
    } else if (!gameSound) {
      gameSound = true;
    }
    update();
  }

  stopBackgroundMusic() {
    if (backGroundMusic) {
      player.stop();
      backGroundMusic = false;
      update();
    }
  }

  pauseBackgroundMusic() {
    if (backGroundMusic) {
      player.pause();
      update();
    }
  }

  resumeBackgroundMusic() {
    if (!kIsWeb) {
      if (backGroundMusic && !Platform.isWindows) {
        player.resume();
      }
    } else if (backGroundMusic) {
      player.resume();
    }
    update();
  }

  stopUISound() {
    if (uiSound) {
      uiSound = false;
      update();
    }
  }

  stopGameSound() {
    if (gameSound) {
      gameSound = false;
      update();
    }
  }

  buttonSound() async {
    if (!kIsWeb) {
      if (uiSound && !Platform.isWindows) {
        uiCache.load("buttonClick.mp3");
        uiPlayer = await uiCache.play("buttonClick.mp3");
        uiPlayer.setVolume(uiVolume);
      }
    } else if (uiSound) {
      uiCache.load("buttonClick.mp3");
      uiPlayer = await uiCache.play("buttonClick.mp3");
      uiPlayer.setVolume(uiVolume);
    }
  }

  tileSound() async {
    if (!kIsWeb) {
      if (gameSound && !Platform.isWindows) {
        gameCache.load("tileMove.mp3");
        gamePlayer = await gameCache.play("tileMove.mp3");
        gamePlayer.setVolume(gameVolume);
      }
    } else if (gameSound) {
      gameCache.load("tileMove.mp3");
      gamePlayer = await gameCache.play("tileMove.mp3");
      gamePlayer.setVolume(gameVolume);
    }
  }

  errorSound() async {
    if (!kIsWeb) {
      if (gameSound && !Platform.isWindows) {
        gameCache.load("error.mp3");
        gamePlayer = await gameCache.play("error.mp3");
        gamePlayer.setVolume(gameVolume + 0.05);
      }
    } else if (gameSound) {
      gameCache.load("error.mp3");
      gamePlayer = await gameCache.play("error.mp3");
      gamePlayer.setVolume(gameVolume + 0.05);
    }
  }

  wordFoundSound() async {
    if (!kIsWeb) {
      if (gameSound && !Platform.isWindows) {
        gameCache.load("wordFound.mp3");
        gamePlayer = await gameCache.play("wordFound.mp3");
        gamePlayer.setVolume(gameVolume + 0.05);
      }
    } else if (gameSound) {
      gameCache.load("wordFound.mp3");
      gamePlayer = await gameCache.play("wordFound.mp3");
      gamePlayer.setVolume(gameVolume + 0.05);
    }
  }

  changeBackgroundMusicVolume(double vol) {
    backgroungMusicVolume = vol;
    player.setVolume(vol);
    update();
  }

  changeUIVolume(double vol) {
    uiVolume = vol;
    // uiPlayer.setVolume(vol);
    update();
  }

  changeGameVolume(double vol) {
    gameVolume = vol;
    // gamePlayer.setVolume(vol);
    update();
  }
}

final Slido slido = Get.put(Slido());
