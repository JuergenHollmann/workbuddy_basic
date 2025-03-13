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
              'Datenschutzerklärung',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            const Text(
              '12. Änderungen dieser Datenschutzerklärung',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Wir behalten uns das Recht vor, diese Datenschutzerklärung jederzeit zu ändern. Die aktuelle Version ist stets auf unserer App verfügbar.\n\n'
              'Diese Datenschutzerklärung wurde zuletzt aktualisiert am 15.03.2025.',
            ),

            /*--- Abstand ---*/
            wbSizedBoxHeight8,
            /*--- Divider und Text ---*/
            WbDividerWithTextInCenter(
              wbColor: wbColorAppBarBlue,
              wbText: 'Datenschutzerklärung speichern und drucken',
              wbTextColor: wbColorLogoBlue,
              wbFontSize12: 12,
              wbHeight3: 3,
            ),
            const Text(
              'Du kannst diese Datenschutzerklärung durch Anklicken des untenstehenden Buttons als PDF-Datei generieren und direkt mit (entsprechender Eignung deines Geräts) ausdrucken, versenden, teilen oder woanders speichern.',
            ),

            /*--------------------------------- PDF erstellen ---*/
            ElevatedButton(
              onPressed: () async {
                final pdf = pw.Document();

                /*--------------------------------- Image 1 laden ---*/
                final image1 = pw.MemoryImage(
                  (await rootBundle
                          .load('assets/icon/workbuddy_icon_neon_green.png'))
                      .buffer
                      .asUint8List(),
                );
                log('0172 - WbPrivacyPolicyDSGVO - image1: $image1');

                /*--------------------------------- Image 2 laden ---*/
                final image2 = pw.MemoryImage(
                  (await rootBundle
                          .load('assets/jothasoft_logo_rund_128x128_pixel.png'))
                      .buffer
                      .asUint8List(),
                );
                log('0181 - WbPrivacyPolicyDSGVO - image2: $image2');

                /*--------------------------------- PDF-Seiten erstellen ---*/
                pdf.addPage(
                  pw.MultiPage(
                    maxPages: 20,
                    header: (context) => pw.Stack(
                      children: [
                        /*--------------------------------- Image 1 ---*/
                        pw.Positioned(
                          top: 0,
                          right: 0,
                          child: pw.Image(image1,
                              width: 2 * PdfPageFormat.cm,
                              height: 2 * PdfPageFormat.cm),
                        ),

                        /*--------------------------------- Image 2 ---*/
                        pw.Positioned(
                          top: 0,
                          right: 2.5 * PdfPageFormat.cm,
                          child: pw.Image(image2,
                              width: 2 * PdfPageFormat.cm,
                              height: 2 * PdfPageFormat.cm),
                        ),

                        /*--------------------------------- Text ---*/
                        pw.Row(
                          children: [
                            pw.Text(
                              'Datenschutzerklärung',
                              style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(width: 60),
                            pw.Text(
                              'Seite ${context.pageNumber} von ${context.pagesCount}',
                              style: pw.TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            pw.SizedBox(height: 60),
                          ],
                        ),
                      ],
                    ),

                    /*--------------------------------- DIN-A4-Format und Margin ---*/
                    pageFormat: PdfPageFormat.a4,
                    margin: pw.EdgeInsets.fromLTRB(64, 24, 24, 32),
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

                            pw.Text(
                              '1. Verantwortlicher\n',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
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
                            pw.Text(
                              '2. Datenschutzbeauftragter\n',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'Unseren Datenschutzbeauftragten erreichst du unter:\n\n'
                              'E-Mail: JOTHAsoft@gmail.com\n'
                              'Telefon: +49-178-9697-193\n\n',
                            ),
                            pw.Text(
                              '3. Zwecke der Datenverarbeitung\n',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'Wir verarbeiten deine personenbezogenen Daten zu folgenden Zwecken:\n'
                              '- Bereitstellung und Verbesserung unserer App\n'
                              '- Verwaltung deines Benutzerkontos\n'
                              '- Kommunikation mit dir\n'
                              '- Analyse und Verbesserung unserer Dienstleistungen\n'
                              '- Erfüllung gesetzlicher Verpflichtungen\n\n',
                            ),
                            pw.Text(
                              '4. Rechtsgrundlage der Verarbeitung\n',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'Die Verarbeitung deiner personenbezogenen Daten erfolgt auf folgenden Rechtsgrundlagen:\n'
                              '- Einwilligung gemäß Art. 6 Abs. 1 lit. a DSGVO\n'
                              '- Erfüllung eines Vertrags gemäß Art. 6 Abs. 1 lit. b DSGVO\n'
                              '- Erfüllung einer rechtlichen Verpflichtung gemäß Art. 6 Abs. 1 lit. c DSGVO\n'
                              '- Wahrung berechtigter Interessen gemäß Art. 6 Abs. 1 lit. f DSGVO\n\n',
                            ),
                            pw.Text(
                              '5. Empfänger oder Kategorien von Empfängern\n',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'Deine personenbezogenen Daten werden an folgende Empfänger weitergegeben:\n'
                              '- Dienstleister, die uns bei der Bereitstellung unserer App unterstützen\n'
                              '- Behörden und staatliche Institutionen, soweit wir gesetzlich dazu verpflichtet sind\n\n',
                            ),
                            pw.Text(
                              '6. Übermittlung in Drittländer\n',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'Eine Übermittlung deiner personenbezogenen Daten in Länder außerhalb der EU oder des EWR erfolgt nur, wenn dies gesetzlich zulässig ist und geeignete Schutzmaßnahmen getroffen wurden.\n\n',
                            ),
                            pw.Text(
                              '7. Speicherdauer\n',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'Deine personenbezogenen Daten werden nur so lange gespeichert, wie es für die Erfüllung der oben genannten Zwecke erforderlich ist oder wie es gesetzlich vorgeschrieben ist.\n\n',
                            ),

                            // Neue Seite erzwingen
                            pw.NewPage(), // funzt nicht

                            pw.SizedBox(height: 80),
                            
                            pw.Text(
                              '8. Rechte der betroffenen Personen\n',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
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
                            pw.Text(
                              '9. Widerrufsrecht bei Einwilligung\n',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'Du hast das Recht, deine Einwilligung zur Verarbeitung deiner personenbezogenen Daten jederzeit zu widerrufen. Der Widerruf der Einwilligung berührt nicht die Rechtmäßigkeit der aufgrund der Einwilligung bis zum Widerruf erfolgten Verarbeitung.\n\n',
                            ),
                            pw.Text(
                              '10. Beschwerderecht bei einer Aufsichtsbehörde\n',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'Du hast das Recht, eine Beschwerde bei einer Datenschutzaufsichtsbehörde einzureichen, wenn du der Ansicht bist, dass die Verarbeitung deiner personenbezogenen Daten gegen die DSGVO verstößt.\n\n',
                            ),
                            pw.Text(
                              '11. Automatisierte Entscheidungsfindung\n',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'Eine automatisierte Entscheidungsfindung einschließlich Profiling findet nicht statt.\n\n',
                            ),
                            pw.Text(
                              '12. Änderungen dieser Datenschutzerklärung\n',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'Wir behalten uns das Recht vor, diese Datenschutzerklärung jederzeit zu ändern. Die aktuelle Version ist stets auf unserer App verfügbar.\n\n'
                              'Diese Datenschutzerklärung wurde zuletzt aktualisiert am 15.03.2025.\n\n'
                              'Druckdatum: Am ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year} um ${DateTime.now().hour}:${DateTime.now().minute} Uhr',
                            ),
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
                final file = File("${output.path}/datenschutzerklaerung.pdf");
                await file.writeAsBytes(await pdf.save());

                /*--- Öffnen und Drucken der PDF-Datei ---*/
                await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => pdf.save(),
                );
              },
              child: const Text('Eine PDF-Datei erstellen und drucken'),
            ),
            Divider(
              color: wbColorLogoBlue,
              thickness: 3,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

Future<pw.Document> createPdf() async {
  // PDF-Dokument erstellen
  final pdf = pw.Document();

  // Logos laden
  final ByteData workbuddyLogoData =
      await rootBundle.load('assets/icon/workbuddy_icon_neon_green.png');
  final Uint8List workbuddyLogoBytes = workbuddyLogoData.buffer.asUint8List();
  log('0371 - WbPrivacyPolicyDSGVO - workbuddyLogoBytes: $workbuddyLogoBytes');

  final ByteData jothasoftLogoData =
      await rootBundle.load('assets/jothasoft_logo_rund_128x128_pixel.png');
  final Uint8List jothasoftLogoBytes = jothasoftLogoData.buffer.asUint8List();
  log('0376 - WbPrivacyPolicyDSGVO - jothasoftLogoBytes: $jothasoftLogoBytes');

  return pdf;
}
