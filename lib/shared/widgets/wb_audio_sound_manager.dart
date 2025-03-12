import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WbAudioSoundManager {
  final AudioPlayer player = AudioPlayer();
  bool isWarningSoundEnabled = true;
  bool isButtonSoundEnabled = false;
  bool isPageChangeSoundEnabled = false;
  bool isTextFieldSoundEnabled = false;

  Future<void> initializePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isWarningSoundEnabled = prefs.getBool('warningSound') ?? true;
    log('0052 - WbAudioSoundManager - Ist der Ton bei "Warnungen" eingeschaltet? ${prefs.getBool('warningSound')}');
    isButtonSoundEnabled = prefs.getBool('buttonSound') ?? false;
    log('0055 - WbAudioSoundManager - Ist der Ton bei "Buttons anklicken" eingeschaltet? ${prefs.getBool('buttonSound')}');
    isPageChangeSoundEnabled = prefs.getBool('pageChangeSound') ?? false;
    log('0058 - WbAudioSoundManager - Ist der Ton bei "Seitenwechsel" eingeschaltet? ${prefs.getBool('pageChangeSound')}');
    isTextFieldSoundEnabled = prefs.getBool('textFieldSound') ?? false;
    log('0062 - WbAudioSoundManager - Ist der Ton bei "Textfeldern" eingeschaltet? ${prefs.getBool('textFieldSound')}');
  }

  void playButtonSound() {
    if (isButtonSoundEnabled) {
      player.play(AssetSource("sound/sound02click.wav"));
    }
  }
}
