import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';

class WbImpressum extends StatelessWidget {
  const WbImpressum({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impressum'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Impressum von "WorkBuddy"',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            const Text(
              'Verantwortlich nach §5 Telemediengesetz (TMG):\n',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'JOTHAsoft.de • Mobile Apps + Software\n'
              'Jürgen Hollmann\n'
              'Leutzestraße 64\n'
              '73525 Schwäbisch Gmünd\n'
              'Deutschland\n'
              'E-Mail: JOTHAsoft@gmail.com\n'
              'Telefon: +49-178-9697-193\n',
            ),

            /*--------------------------------- Abstand ---*/
            wbSizedBoxHeight8,
            /*--------------------------------- Divider und Text ---*/
            WbDividerWithTextInCenter(
              wbColor: wbColorAppBarBlue,
              wbText: 'Das Impressum speichern + drucken',
              wbTextColor: wbColorLogoBlue,
              wbFontSize12: 12,
              wbHeight3: 3,
            ),
            const Text(
              'Du kannst dieses Impressum durch Anklicken des untenstehenden Buttons als PDF-Datei generieren und direkt (mit entsprechender Eignung deines Geräts) ausdrucken, versenden, teilen oder woanders speichern.',
            ),
            /*--------------------------------- Divider ---*/
            Divider(color: wbColorLogoBlue, thickness: 3),

            /*--------------------------------- PDF erstellen ---*/
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: wbColorBackgroundBlue),
                onPressed: () async {
                  log('0174 - WbImpressum - Impressum als PDF-Datei speichern und drucken');
                  final pdf = pw.Document();

                  /*--------------------------------- Image 1 laden ---*/
                  final image1 = pw.MemoryImage(
                    (await rootBundle
                            .load('assets/icon/workbuddy_icon_neon_green.png'))
                        .buffer
                        .asUint8List(),
                  );

                  /*--------------------------------- Image 2 laden---*/
                  final image2 = pw.MemoryImage(
                    (await rootBundle.load(
                            'assets/jothasoft_logo_rund_128x128_pixel.png'))
                        .buffer
                        .asUint8List(),
                  );

                  /*--------------------------------- PDF-Seiten erstellen ---*/
                  pdf.addPage(
                    pw.MultiPage(
                      maxPages: 1,

                      /*--------------------------------- Header = Kopfzeile ---*/
                      header: (context) => pw.Column(
                        children: [
                          pw.Stack(
                            children: [
                              /*--------------------------------- Image 1 - WorkBuddy ---*/
                              pw.Positioned(
                                top: 0,
                                right: 2.5 * PdfPageFormat.cm,
                                child: pw.Image(image1,
                                    width: 2 * PdfPageFormat.cm,
                                    height: 2 * PdfPageFormat.cm),
                              ),
                              /*--------------------------------- Image 2 - JOTHAsoft ---*/
                              pw.Positioned(
                                top: 0,
                                right: 0,
                                child: pw.Image(image2,
                                    width: 2 * PdfPageFormat.cm,
                                    height: 2 * PdfPageFormat.cm),
                              ),
                              /*--------------------------------- Text ---*/
                              pw.Row(
                                children: [
                                  pw.Text(
                                    'Impressum von "WorkBuddy"',
                                    style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.SizedBox(height: 60),
                                ],
                              ),
                            ],
                          ),

                          /*--------------------------------- Divider ---*/
                          pw.Divider(
                            color: PdfColors.black,
                            thickness: 1,
                          ),
                        ],
                      ),

                      /*--------------------------------- Footer = Fußzeile ---*/
                      footer: (context) => pw.Container(
                        alignment: pw.Alignment.bottomRight,

                        /*--------------------------------- Divider ---*/
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            pw.Divider(
                              color: PdfColors.black,
                              thickness: 1,
                            ),

                            /*--------------------------------- Text ---*/
                            pw.Text(
                              '© JOTHAsoft.de - Mobile Apps + Software - Impressum - Seite ${context.pageNumber} von ${context.pagesCount}',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /*--------------------------------- DIN-A4-Format und Margin ---*/
                      pageFormat: PdfPageFormat.a4,
                      margin: pw.EdgeInsets.fromLTRB(64, 24, 24, 8),
                      build: (pw.Context context) => [
                        /*--------------------------------- Text ---*/
                        pw.Container(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              /*--------------------------------- Verantwortlicher ---*/
                              pw.Text(
                                'Verantwortlich nach §5 Telemediengesetz (TMG):\n\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'JOTHAsoft.de - Mobile Apps + Software\n'
                                'Jürgen Hollmann\n'
                                'Leutzestraße 64\n'
                                '73525 Schwäbisch Gmünd\n'
                                'Deutschland\n'
                                'E-Mail: JOTHAsoft@gmail.com\n'
                                'Telefon: +49-178-9697-193\n\n',
                              ),

                              /*--------------------------------- Druckdatum ---*/
                              pw.Text(
                                'Dieses Impressum wurde ausgedruckt am ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year} um ${DateTime.now().hour}:${DateTime.now().minute} Uhr',
                              ),
                              /*--------------------------------- *** ---*/
                            ],
                          ),
                        ),
                        //   ],
                        // ),
                      ],
                    ),
                  );

                  /*--- Speichern der PDF-Datei im lokalen Speicher ---*/
                  final output = await getTemporaryDirectory();
                  final file = File(
                      "${output.path}/impressum.pdf"); // Der Dateiname muss in Kleinbuchstaben geschrieben sein und keine Umlaute, Sonderzeichen oder Leerzeichen haben und mit ".pdf" enden.
                  await file.writeAsBytes(await pdf.save());

                  /*--- Öffnen und Drucken der PDF-Datei ---*/
                  await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => pdf.save(),
                  );
                },
                child: const Text(
                  'Eine PDF-Datei erstellen und drucken',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /*--------------------------------- Divider ---*/
            Divider(color: wbColorLogoBlue, thickness: 3),

            /*--------------------------------- Abstand ---*/
            const SizedBox(height: 16),
            /*--------------------------------- *** ---*/
          ],
        ),
      ),
    );
  }
}

// Future<pw.Document> createPdf() async {
//   // PDF-Dokument erstellen
//   final pdf = pw.Document();

//   // Logos laden
//   final ByteData workbuddyLogoData =
//       await rootBundle.load('assets/icon/workbuddy_icon_neon_green.png');
//   final Uint8List workbuddyLogoBytes = workbuddyLogoData.buffer.asUint8List();
//   log('0371 - WbImpressum - workbuddyLogoBytes: $workbuddyLogoBytes');

//   final ByteData jothasoftLogoData =
//       await rootBundle.load('assets/jothasoft_logo_rund_128x128_pixel.png');
//   final Uint8List jothasoftLogoBytes = jothasoftLogoData.buffer.asUint8List();
//   log('0376 - WbImpressum - jothasoftLogoBytes: $jothasoftLogoBytes');

//   return pdf;
// }
