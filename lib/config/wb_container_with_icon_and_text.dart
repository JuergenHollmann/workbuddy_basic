import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/shared/widgets/wb_audio_sound_manager.dart';

class WbContainerWithIconAndText extends StatefulWidget {
  const WbContainerWithIconAndText({
    super.key,
    required this.containerText,
    this.containerColor,
    this.containerIcon,
    this.containerIconSize32,
    this.containerIconColor,
    this.containerTextSize22,
    this.containerTextColor,
    this.onTap,
  });

  final String containerText;
  final Color? containerColor;
  final IconData? containerIcon;
  final double? containerIconSize32;
  final Color? containerIconColor;
  final double? containerTextSize22;
  final Color? containerTextColor;
  final VoidCallback? onTap;

  @override
  State<WbContainerWithIconAndText> createState() =>
      _WbContainerWithIconAndTextState();
}

class _WbContainerWithIconAndTextState
    extends State<WbContainerWithIconAndText> {
  /*--------------------------------- WbAudioSoundManager ---*/
  final WbAudioSoundManager audioSoundManager = WbAudioSoundManager();

  @override
  void initState() {
    super.initState();
    audioSoundManager.initializePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return /*--------------------------------- *** ---*/
        GestureDetector(
      onTap: () {
        log('0047 - WbContainerWithIconAndText - "${widget.containerText}" - aktiviert');
        /*--------------------------------- Sound abspielen ---*/
        audioSoundManager.playButtonSound();
        /*--------------------------------- *** ---*/
        if (widget.onTap != null) {
          widget.onTap!();
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
                fontSize: widget.containerTextSize22 ?? 22,
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
