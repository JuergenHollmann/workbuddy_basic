import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_sizes.dart';

class WbButtonsUniWithImageButton extends StatelessWidget {
  const WbButtonsUniWithImageButton({
    super.key,
    required this.wbColor,
    required this.wbIcon,
    required this.wbIconSize40,
    required this.wbText,
    required this.wbFontSize24,
    required this.wbWidth276,
    required this.wbHeight90,
    required this.wbHeightAssetImage90,
    required this.wbImageAssetImage,
    required this.wbImageButtonRadius12,
    required this.wbOnTapTextButton,
    required this.wbOnTapImageButton,
  });

// benötigte Variablen:
  final Color wbColor;
  final IconData wbIcon;
  final double wbIconSize40;
  final String wbText;
  final double wbFontSize24;
  final double wbWidth276;
  final double wbHeight90;
  final double wbHeightAssetImage90;
  final ImageProvider<Object> wbImageAssetImage;
  final double wbImageButtonRadius12;
  final void Function() wbOnTapTextButton;
  final void Function() wbOnTapImageButton;

  @override
  Widget build(BuildContext context) {
    log("0039 - WbButtonsUniWithImageButton - aktiviert");

    return Row(
      children: [
        /*--------------------------------- Container - Button vorne ---*/
        Expanded(
          child: Container(
            width: wbWidth276,
            height: wbHeight90,
            decoration: ShapeDecoration(
              shadows: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 8,
                  offset: Offset(4, 4),
                  spreadRadius: 0,
                )
              ],
              color: wbColor,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(
                  16,
                ),
              ),
            ),
            /*--------------------------------- Gesture - TextButton vorne ---*/
            child: GestureDetector(
              onTap: wbOnTapTextButton,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        /*--------------------------------- Icon - TextButton vorne ---*/
                        child: Icon(
                          wbIcon,
                          color: Colors.white,
                          size: wbIconSize40,
                          shadows: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 8,
                              offset: Offset(4, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        /*--------------------------------- Text im TextButton vorne ---*/
                        child: Text(
                          wbText,
                          style: TextStyle(
                            color: Colors.white,
                            shadows: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 8,
                                offset: Offset(4, 4),
                                spreadRadius: 0,
                              )
                            ],
                            fontSize: wbFontSize24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2, // Zwischenraum der Buchtstaben
                          ),
                        ),
                        // ), // Padding
                        // ), // Center
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        /*--------------------------------- *** ---*/
        wbSizedBoxWidth16,
        /*-------------------------------------------------- Container - Button hinten ---*/
        GestureDetector(
          onTap: wbOnTapImageButton,
          child: Container(
            clipBehavior: Clip.antiAlias, //funzt nicht?
            constraints: const BoxConstraints(maxWidth: 90),
            // wenn "width" ausgeschaltet ist ergibt sich die Größe automatisch aus "height".
            //width: wbHeightAssetImage90,
            height: wbHeightAssetImage90,
            decoration: ShapeDecoration(
              shadows: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 8,
                  offset: Offset(4, 4),
                  spreadRadius: 0,
                )
              ],
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(
                  wbImageButtonRadius12,
                ),
              ),
            ),
            /*--------------------------------- Image im Container ---*/
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Image(
                fit: BoxFit.contain,
                //width: 90,
                height: wbHeightAssetImage90,
                image: wbImageAssetImage,
              ),
            ),
          ),
        ),
        /*--------------------------------- *** ---*/
      ],
    );
  }
}
