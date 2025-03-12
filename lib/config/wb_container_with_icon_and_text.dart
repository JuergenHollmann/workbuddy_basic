import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workbuddy/config/wb_colors.dart';

class WbContainerWithIconAndText extends StatefulWidget {
  const WbContainerWithIconAndText({
    super.key,
    required this.containerText,
    this.containerColor,
    this.containerIcon,
    this.containerIconSize32,
    this.containerIconColor,
    this.containerTextSize26,
    this.containerTextColor,
  });

  final String containerText;
  final Color? containerColor;
  final IconData? containerIcon;
  final double? containerIconSize32;
  final Color? containerIconColor;
  final double? containerTextSize26;
  final Color? containerTextColor;

  @override
  State<WbContainerWithIconAndText> createState() => _WbContainerWithIconAndTextState();
}

class _WbContainerWithIconAndTextState extends State<WbContainerWithIconAndText> {
  /*--------------------------------- AudioPlayer ---*/
  final AudioPlayer player = AudioPlayer();

  final Future<SharedPreferences> prefsFuture = SharedPreferences.getInstance();
  bool isWarningSoundEnabled = true;
  bool isButtonSoundEnabled = false;
  bool isPageChangeSoundEnabled = false;
  bool isTextFieldSoundEnabled = false;

    @override
  void initState() {
    super.initState();
    initializePreferences();
  }

  void initializePreferences() {
    prefsFuture.then((prefs) {
      isWarningSoundEnabled = prefs.getBool('warningSound') ?? true;
      log('0052 - P01LoginScreen - Ist der Ton bei "Warnungen" eingeschaltet? ${prefs.getBool('warningSound')}');
      isButtonSoundEnabled = prefs.getBool('buttonSound') ?? false;
      log('0055 - P01LoginScreen - Ist der Ton bei "Buttons anklicken" eingeschaltet? ${prefs.getBool('buttonSound')}');
      isPageChangeSoundEnabled = prefs.getBool('pageChangeSound') ?? false;
      log('0058 - P01LoginScreen - Ist der Ton bei "Seitenwechsel" eingeschaltet? ${prefs.getBool('pageChangeSound')}');
      isTextFieldSoundEnabled = prefs.getBool('textFieldSound') ?? false;
      log('0062 - P01LoginScreen - Ist der Ton bei "Textfeldern" eingeschaltet? ${prefs.getBool('textFieldSound')}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return /*--------------------------------- *** ---*/
        GestureDetector(
      onTap: () {
        log('0031 - WbContainerWithIconAndText - "${widget.containerText}" angeklickt');
        /*--------------------------------- Sound abspielen ---*/
        if (isButtonSoundEnabled) {
          player.play(AssetSource("sound/sound02click.wav"));
        }
        /*--------------------------------- *** ---*/
      },
      child: Container(
        height: 50,
        width: double.infinity, // maximale Breite
        color: widget.containerColor ?? wbColorDrawerOrangeLight,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: widget.containerIcon != null
                  ? Icon(
                      widget.containerIcon,
                      size: widget.containerIconSize32 ?? 32,
                      color: widget.containerIconColor ?? wbColorLogoBlue,
                    )
                  : Icon(
                      Icons.menu_book_outlined,
                      size: 32,
                      color: wbColorLogoBlue,
                    ),
            ),
            Text(
              widget.containerText,
              style: TextStyle(
                fontSize: widget.containerTextSize26 ?? 26,
                fontWeight: FontWeight.bold,
                color: widget.containerTextColor ?? wbColorLogoBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
