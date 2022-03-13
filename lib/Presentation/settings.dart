import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slido/controller/slido_controller.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<Slido>(
          init: slido,
          builder: (value) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("Background Music"),
                      Switch(
                        activeColor: const Color(0xff79a9d1),
                        value: value.backGroundMusic,
                        onChanged: (val) async {
                          await slido.buttonSound();
                          val
                              ? value.playBackgroundMusic()
                              : value.stopBackgroundMusic();
                        },
                      ),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("Background Music Volume"),
                      Slider(
                          activeColor: const Color(0xff79a9d1),
                          min: 0,
                          max: 1,
                          value: value.backgroungMusicVolume,
                          onChanged: (val) {
                            value.changeBackgroundMusicVolume(val);
                          }),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("UI Sound"),
                      Switch(
                        activeColor: const Color(0xff79a9d1),
                        value: value.uiSound,
                        onChanged: (val) {
                          val ? value.playUIsound() : value.stopUISound();
                          slido.buttonSound();
                        },
                      ),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("UI Sound Volume"),
                      Slider(
                          activeColor: const Color(0xff79a9d1),
                          min: 0,
                          max: 1,
                          value: value.uiVolume,
                          onChanged: (val) {
                            value.changeUIVolume(val);
                          }),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("Game Sound"),
                      Switch(
                        activeColor: const Color(0xff79a9d1),
                        value: value.gameSound,
                        onChanged: (val) {
                          slido.buttonSound();
                          val ? value.playGameSound() : value.stopGameSound();
                        },
                      ),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("Game Sound Volume"),
                      Slider(
                          activeColor: const Color(0xff79a9d1),
                          min: 0,
                          max: 0.1,
                          value: value.gameVolume,
                          onChanged: (val) {
                            value.changeGameVolume(val);
                          }),
                    ]),
                    GestureDetector(
                      onTap: () async {
                        await slido.buttonSound();
                        Get.back();
                      },
                      child: Container(
                        width: 81,
                        height: 32,
                        color: const Color(0xff79a9d1),
                        child: const Center(
                            child: Text(
                          "Done",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    )
                  ]),
            );
          }),
    );
  }
}
