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

class WbPrivacyPolicyDSGVO extends StatelessWidget {
  const WbPrivacyPolicyDSGVO({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datenschutzerklärung'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datenschutzerklärung von "WorkBuddy"',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            const Text(
              '1. Verantwortlicher',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Verantwortlicher für die Datenverarbeitung auf dieser App ist:\n\n'
              'JOTHAsoft.de • Mobile Apps + Software\n'
              'Jürgen Hollmann\n'
              'Leutzestraße 64\n'
              '73525 Schwäbisch Gmünd\n'
              'Deutschland\n'
              'E-Mail: JOTHAsoft@gmail.com\n'
              'Telefon: +49-178-9697-193\n',
            ),
            const Text(
              '2. Datenschutzbeauftragter',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Unseren Datenschutzbeauftragten erreichst du unter:\n'
              'E-Mail: JOTHAsoft@gmail.com\n'
              'Telefon: +49-178-9697-193\n',
            ),
            const Text(
              '3. Zwecke der Datenverarbeitung',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Wir verarbeiten deine personenbezogenen Daten zu folgenden Zwecken:\n'
              '- Bereitstellung und Verbesserung unserer App\n'
              '- Verwaltung deines Benutzerkontos\n'
              '- Kommunikation mit dir\n'
              '- Analyse und Verbesserung unserer Dienstleistungen\n'
              '- Erfüllung gesetzlicher Verpflichtungen\n',
            ),
            const Text(
              '4. Rechtsgrundlage der Verarbeitung',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Die Verarbeitung deiner personenbezogenen Daten erfolgt auf folgenden Rechtsgrundlagen:\n'
              '- Einwilligung gemäß Art. 6 Abs. 1 lit. a DSGVO\n'
              '- Erfüllung eines Vertrags gemäß Art. 6 Abs. 1 lit. b DSGVO\n'
              '- Erfüllung einer rechtlichen Verpflichtung gemäß Art. 6 Abs. 1 lit. c DSGVO\n'
              '- Wahrung berechtigter Interessen gemäß Art. 6 Abs. 1 lit. f DSGVO\n',
            ),
            const Text(
              '5. Empfänger oder Kategorien von Empfängern',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Deine personenbezogenen Daten werden an folgende Empfänger weitergegeben:\n'
              '- Dienstleister, die uns bei der Bereitstellung unserer App unterstützen\n'
              '- Behörden und staatliche Institutionen, soweit wir gesetzlich dazu verpflichtet sind\n',
            ),
            const Text(
              '6. Übermittlung in Drittländer',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Eine Übermittlung deiner personenbezogenen Daten in Länder außerhalb der EU oder des EWR erfolgt nur, wenn dies gesetzlich zulässig ist und geeignete Schutzmaßnahmen getroffen wurden.\n',
            ),
            const Text(
              '7. Speicherdauer',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Deine personenbezogenen Daten werden nur so lange gespeichert, wie es für die Erfüllung der oben genannten Zwecke erforderlich ist oder wie es gesetzlich vorgeschrieben ist.\n',
            ),
            const Text(
              '8. Rechte der betroffenen Personen',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Du hast das Recht:\n'
              '- Auskunft über die Verarbeitung deiner Daten zu erhalten\n'
              '- Deine Daten berichtigen oder löschen zu lassen\n'
              '- Die Verarbeitung deiner Daten einschränken zu lassen\n'
              '- Der Verarbeitung deiner Daten zu widersprechen\n'
              '- Deine Daten in einem übertragbaren Format zu erhalten\n'
              '- Deine Einwilligung zur Datenverarbeitung jederzeit zu widerrufen\n',
            ),
            const Text(
              '9. Widerrufsrecht bei Einwilligung',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Du hast das Recht, deine Einwilligung zur Verarbeitung deiner personenbezogenen Daten jederzeit zu widerrufen. Der Widerruf der Einwilligung berührt nicht die Rechtmäßigkeit der aufgrund der Einwilligung bis zum Widerruf erfolgten Verarbeitung.\n',
            ),
            const Text(
              '10. Beschwerderecht bei einer Aufsichtsbehörde',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Du hast das Recht, eine Beschwerde bei einer Datenschutzaufsichtsbehörde einzureichen, wenn du der Ansicht bist, dass die Verarbeitung deiner personenbezogenen Daten gegen die DSGVO verstößt.\n',
            ),
            const Text(
              '11. Automatisierte Entscheidungsfindung',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Eine automatisierte Entscheidungsfindung einschließlich Profiling findet nicht statt.\n',
            ),

            /*--------------------------------- Salvatorische Klausel ---*/
            const Text(
              '12. Änderungen und Salvatorische Klausel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
                'Wir behalten uns das Recht vor, diese Datenschutzerklärung jederzeit zu ändern. Die aktuelle Version ist stets auf unserer App verfügbar. Sollte eine Bestimmung dieser Datenschutzerklärung unwirksam oder undurchführbar sein oder werden, so wird hierdurch die Gültigkeit der übrigen Bestimmungen nicht berührt. Anstelle der unwirksamen oder undurchführbaren Bestimmung soll eine angemessene Regelung gelten, die dem wirtschaftlichen Zweck der unwirksamen oder undurchführbaren Bestimmung möglichst nahekommt. Die Vertragsparteien verpflichten sich, in einem solchen Fall eine angemessene und rechtlich zulässige Ersatzregelung zu vereinbaren, die der unwirksamen oder undurchführbaren Bestimmung im wirtschaftlichen Ergebnis möglichst nahekommt.'),
            const SizedBox(height: 16),

            /*--------------------------------- Änderungsdatum ---*/
            const Text(
              'Diese Datenschutzerklärung wurde zuletzt aktualisiert am 13.03.2025.',
            ),

            /*--------------------------------- Abstand ---*/
            wbSizedBoxHeight8,
            /*--------------------------------- Divider und Text ---*/
            WbDividerWithTextInCenter(
              wbColor: wbColorAppBarBlue,
              wbText: 'Die Datenschutzerklärung speichern + drucken',
              wbTextColor: wbColorLogoBlue,
              wbFontSize12: 12,
              wbHeight3: 3,
            ),
            const Text(
              'Du kannst diese Datenschutzerklärung durch Anklicken des untenstehenden Buttons als PDF-Datei generieren und direkt (mit entsprechender Eignung deines Geräts) ausdrucken, versenden, teilen oder woanders speichern.',
            ),
            /*--------------------------------- Divider ---*/
            Divider(color: wbColorLogoBlue, thickness: 3),

            /*--------------------------------- PDF erstellen ---*/
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: wbColorBackgroundBlue),
                onPressed: () async {
                  log('0174 - WbPrivacyPolicyDSGVO - Datenschutzerklärung als PDF-Datei speichern und drucken');
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
                      maxPages: 20,

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
                                    'Datenschutzerklärung von "WorkBuddy"',
                                    style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  // pw.SizedBox(width: 60),
                                  // pw.Text(
                                  //   'Seite ${context.pageNumber} von ${context.pagesCount}',
                                  //   style: pw.TextStyle(
                                  //     fontSize: 12,
                                  //   ),
                                  // ),
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
                        // margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),

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
                              '© JOTHAsoft.de - Mobile Apps + Software - Datenschutzerklärung - Seite ${context.pageNumber} von ${context.pagesCount}',
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
                              // /*--------------------------------- Stack für Image 2 ---*/
                              // pw.Stack(
                              //   children: [
                              //     pw.Positioned(
                              //       top: 200,
                              //       right: 200,
                              //       child: pw.Image(
                              //         image2,
                              //         width: 50,
                              //         height: 50,
                              //         fit: pw.BoxFit.fill,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // /*--------------------------------- *** ---*/
                              //pw.SizedBox(height: 16),

                              /*--------------------------------- Verantwortlicher ---*/
                              pw.Text(
                                '1. Verantwortlicher\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Verantwortlicher für die Datenverarbeitung auf dieser App ist:\n\n'
                                'JOTHAsoft.de - Mobile Apps + Software\n'
                                'Jürgen Hollmann\n'
                                'Leutzestraße 64\n'
                                '73525 Schwäbisch Gmünd\n'
                                'Deutschland\n'
                                'E-Mail: JOTHAsoft@gmail.com\n'
                                'Telefon: +49-178-9697-193\n\n',
                              ),

                              /*--------------------------------- Datenschutzbeauftragter ---*/
                              pw.Text(
                                '2. Datenschutzbeauftragter\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Unseren Datenschutzbeauftragten erreichst du unter:\n'
                                'E-Mail: JOTHAsoft@gmail.com\n'
                                'Telefon: +49-178-9697-193\n\n',
                              ),

                              /*--------------------------------- Zwecke der Datenverarbeitung ---*/
                              pw.Text(
                                '3. Zwecke der Datenverarbeitung\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Wir verarbeiten deine personenbezogenen Daten zu folgenden Zwecken:\n'
                                '- Bereitstellung und Verbesserung unserer App\n'
                                '- Verwaltung deines Benutzerkontos\n'
                                '- Kommunikation mit dir\n'
                                '- Analyse und Verbesserung unserer Dienstleistungen\n'
                                '- Erfüllung gesetzlicher Verpflichtungen\n\n',
                              ),

                              /*--------------------------------- Rechtsgrundlage der Verarbeitung ---*/
                              pw.Text(
                                '4. Rechtsgrundlage der Verarbeitung\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Die Verarbeitung deiner personenbezogenen Daten erfolgt auf folgenden Rechtsgrundlagen:\n'
                                '- Einwilligung gemäß Art. 6 Abs. 1 lit. a DSGVO\n'
                                '- Erfüllung eines Vertrags gemäß Art. 6 Abs. 1 lit. b DSGVO\n'
                                '- Erfüllung einer rechtlichen Verpflichtung gemäß Art. 6 Abs. 1 lit. c DSGVO\n'
                                '- Wahrung berechtigter Interessen gemäß Art. 6 Abs. 1 lit. f DSGVO\n\n',
                              ),

                              /*--------------------------------- Empfänger oder Kategorien von Empfängern ---*/
                              pw.Text(
                                '5. Empfänger oder Kategorien von Empfängern\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Deine personenbezogenen Daten werden an folgende Empfänger weitergegeben:\n'
                                '- Dienstleister, die uns bei der Bereitstellung unserer App unterstützen\n'
                                '- Behörden und staatliche Institutionen, soweit wir gesetzlich dazu verpflichtet sind\n\n',
                              ),

                              /*--------------------------------- Übermittlung in Drittländer ---*/
                              pw.Text(
                                '6. Übermittlung in Drittländer\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Eine Übermittlung deiner personenbezogenen Daten in Länder außerhalb der EU oder des EWR erfolgt nur, wenn dies gesetzlich zulässig ist und geeignete Schutzmaßnahmen getroffen wurden.\n\n',
                              ),

                              /*--------------------------------- Speicherdauer ---*/
                              pw.Text(
                                '7. Speicherdauer\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Deine personenbezogenen Daten werden nur so lange gespeichert, wie es für die Erfüllung der oben genannten Zwecke erforderlich ist oder wie es gesetzlich vorgeschrieben ist.\n\n',
                              ),

                              /*--------------------------------- Neue Seite erzwingen - funzt nicht ---*/
                              // pw.NewPage(), // funzt nicht
                              // pw.PageBreak(), // gibt es anscheinend nicht?
                              pw.SizedBox(height: 72),
                              /*--------------------------------- *** ---*/

                              /*--------------------------------- Rechte der betroffenen Personen ---*/
                              pw.Text(
                                '8. Rechte der betroffenen Personen\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Du hast das Recht:\n'
                                '- Auskunft über die Verarbeitung deiner Daten zu erhalten\n'
                                '- Deine Daten berichtigen oder löschen zu lassen\n'
                                '- Die Verarbeitung deiner Daten einschränken zu lassen\n'
                                '- Der Verarbeitung deiner Daten zu widersprechen\n'
                                '- Deine Daten in einem übertragbaren Format zu erhalten\n'
                                '- Deine Einwilligung zur Datenverarbeitung jederzeit zu widerrufen\n\n',
                              ),

                              /*--------------------------------- Widerrufsrecht bei Einwilligung ---*/
                              pw.Text(
                                '9. Widerrufsrecht bei Einwilligung\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Du hast das Recht, deine Einwilligung zur Verarbeitung deiner personenbezogenen Daten jederzeit zu widerrufen. Der Widerruf der Einwilligung berührt nicht die Rechtmäßigkeit der aufgrund der Einwilligung bis zum Widerruf erfolgten Verarbeitung.\n\n',
                              ),

                              /*--------------------------------- Beschwerderecht bei einer Aufsichtsbehörde ---*/
                              pw.Text(
                                '10. Beschwerderecht bei einer Aufsichtsbehörde\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Du hast das Recht, eine Beschwerde bei einer Datenschutzaufsichtsbehörde einzureichen, wenn du der Ansicht bist, dass die Verarbeitung deiner personenbezogenen Daten gegen die DSGVO verstößt.\n\n',
                              ),

                              /*--------------------------------- Automatisierte Entscheidungsfindung ---*/
                              pw.Text(
                                '11. Automatisierte Entscheidungsfindung\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Eine automatisierte Entscheidungsfindung einschließlich Profiling findet nicht statt.\n\n',
                              ),

                              /*--------------------------------- Änderungen und Salvatorische Klausel ---*/
                              pw.Text(
                                '12. Änderungen und Salvatorische Klausel',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                  'Wir behalten uns das Recht vor, diese Datenschutzerklärung jederzeit zu ändern. Die aktuelle Version ist stets auf unserer App verfügbar. Sollte eine Bestimmung dieser Datenschutzerklärung unwirksam oder undurchführbar sein oder werden, so wird hierdurch die Gültigkeit der übrigen Bestimmungen nicht berührt. Anstelle der unwirksamen oder undurchführbaren Bestimmung soll eine angemessene Regelung gelten, die dem wirtschaftlichen Zweck der unwirksamen oder undurchführbaren Bestimmung möglichst nahekommt. Die Vertragsparteien verpflichten sich, in einem solchen Fall eine angemessene und rechtlich zulässige Ersatzregelung zu vereinbaren, die der unwirksamen oder undurchführbaren Bestimmung im wirtschaftlichen Ergebnis möglichst nahekommt.'),
                              pw.SizedBox(height: 16),

                              /*--------------------------------- Aktualisierungsdatum ---*/
                              pw.Text(
                                'Diese Datenschutzerklärung wurde zuletzt aktualisiert am 13.03.2025.',
                              ),

                              /*--------------------------------- Druckdatum ---*/
                              pw.Text(
                                'Diese Datenschutzerklärung wurde ausgedruckt am ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year} um ${DateTime.now().hour}:${DateTime.now().minute} Uhr',
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
                      "${output.path}/datenschutzerklaerung.pdf"); // Der Dateiname muss in Kleinbuchstaben geschrieben sein und keine Umlaute, Sonderzeichen oder Leerzeichen haben und mit ".pdf" enden.
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
//   log('0371 - WbPrivacyPolicyDSGVO - workbuddyLogoBytes: $workbuddyLogoBytes');

//   final ByteData jothasoftLogoData =
//       await rootBundle.load('assets/jothasoft_logo_rund_128x128_pixel.png');
//   final Uint8List jothasoftLogoBytes = jothasoftLogoData.buffer.asUint8List();
//   log('0376 - WbPrivacyPolicyDSGVO - jothasoftLogoBytes: $jothasoftLogoBytes');

//   return pdf;
// }
