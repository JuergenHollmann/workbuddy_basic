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
    log('0016 - WbAudioSoundManager - Ist der Ton bei "Warnungen" eingeschaltet? ${prefs.getBool('warningSound')}');
    isButtonSoundEnabled = prefs.getBool('buttonSound') ?? false;
    log('0018 - WbAudioSoundManager - Ist der Ton bei "Buttons anklicken" eingeschaltet? ${prefs.getBool('buttonSound')}');
    isPageChangeSoundEnabled = prefs.getBool('pageChangeSound') ?? false;
    log('0020 - WbAudioSoundManager - Ist der Ton bei "Seitenwechsel" eingeschaltet? ${prefs.getBool('pageChangeSound')}');
    isTextFieldSoundEnabled = prefs.getBool('textFieldSound') ?? false;
    log('0022 - WbAudioSoundManager - Ist der Ton bei "Textfeldern" eingeschaltet? ${prefs.getBool('textFieldSound')}');
  }

  void playWarningSound() {
    if (isWarningSoundEnabled) {
      player.play(AssetSource("sound/sound03enterprise.wav"));
      log('0028 - WbAudioSoundManager - ${player.play}');
      log('0029 - WbAudioSoundManager - AssetSource("sound/sound03enterprise.wav")');
    }
  }

  void playButtonSound() {
    if (isButtonSoundEnabled) {
      player.play(AssetSource("sound/sound02click.wav"));
      log('0036 - WbAudioSoundManager - ${player.play}');
      log('0037 - WbAudioSoundManager - AssetSource("sound/sound02click.wav")');
    }
  }

  void playPageChangeSound() {
    if (isPageChangeSoundEnabled) {
      player.play(AssetSource("sound/sound07woosh.wav"));
      log('0044 - WbAudioSoundManager - ${player.play}');
      log('0045 - WbAudioSoundManager - AssetSource("sound/sound07woosh.wav")');
    }
  }

  void playTextFieldSound() {
    if (isTextFieldSoundEnabled) {
      player.play(AssetSource("sound/sound08kurzesbipp.wav"));
      log('0052 - WbAudioSoundManager - ${player.play}');
      log('0053 - WbAudioSoundManager - AssetSource("sound/sound08kurzesbipp.wav")');
    }
  }
}
