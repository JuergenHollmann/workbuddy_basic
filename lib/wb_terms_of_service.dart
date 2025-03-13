import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';

class WbTermsOfService extends StatelessWidget {
  const WbTermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutzungsbedingungen'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nutzungsbedingungen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Einleitung',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Willkommen bei WorkBuddy!\nDiese Nutzungsbedingungen regeln deine Nutzung unserer mobilen Anwendung ("App"). Durch die Nutzung der App erklärst du dich mit diesen Bedingungen einverstanden. Wenn du nicht einverstanden bist, darfst du die App nicht nutzen.',
            ),
            const SizedBox(height: 16),
            const Text(
              '2. Nutzung der App',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              '2.1. Berechtigung\n'
              'Du musst mindestens 18 Jahre alt sein, um die App nutzen zu dürfen. Durch die Nutzung der App bestätigst du, dass du diese Altersanforderung erfüllst.\n\n'
              '2.2. Registrierung\n'
              'Die App ist in der Version "WorkBuddy-Basic" kostenfrei und Du kannst diese Version auch ohne Registrierung nutzen. Alle Daten, die Du in dieser Version speicherst, werden nur auf deinem Device (Smartphone, Tablet, etc.) gespeichert und auf keine Server übermittelt. Um aber bestimmte (kostenlose oder kostenpflichtige) Funktionen der App nutzen zu können, musst du dich registrieren und ein Konto erstellen. Du bist dafür verantwortlich, die Vertraulichkeit deiner Kontoinformationen zu wahren und alle Aktivitäten, die unter deinem Konto stattfinden, zu überwachen.',
            ),
            const SizedBox(height: 16),
            const Text(
              '3. Datenschutz',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Deine Privatsphäre ist uns wichtig. Bitte lies unsere Datenschutzerklärung, um zu erfahren, ob und wie wir deine persönlichen Daten sammeln, verwenden und schützen.',
            ),
            const SizedBox(height: 16),
            const Text(
              '4. Inhalte und geistiges Eigentum',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              '4.1. Inhalte\n'
              'Alle Inhalte, die in der App verfügbar sind, einschließlich Texte, Grafiken, Logos, Bilder und Software, sind Eigentum von JOTHAsoft und WorkBuddy oder unseren Lizenzgebern und durch Urheberrechtsgesetze geschützt.\n\n'
              '4.2. Lizenz\n'
              'Wir gewähren dir eine beschränkte, nicht exklusive, nicht übertragbare Lizenz zur Nutzung der App für persönliche und geschäftliche Zwecke. Du darfst die App nicht ohne unsere ausdrückliche schriftliche Genehmigung modifizieren, kopieren, vertreiben, übertragen, anzeigen, aufführen, reproduzieren, veröffentlichen, lizenzieren, abgeleitete Werke erstellen oder verkaufen.',
            ),
            const SizedBox(height: 16),
            const Text(
              '5. Verbotene Aktivitäten',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Du darfst die App nicht für illegale oder unbefugte Zwecke nutzen. Dazu gehören unter anderem:\n'
              '- Das Hochladen von Viren oder schädlichem Code\n'
              '- Das Sammeln von Informationen über andere Benutzer ohne deren Zustimmung\n'
              '- Das Stören oder Unterbrechen der App oder der mit der App verbundenen Server oder Netzwerke',
            ),
            const SizedBox(height: 16),
            const Text(
              '6. Haftungsausschluss',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Die App wird "wie besehen" und "wie verfügbar" bereitgestellt. Wir übernehmen keine Gewährleistung, weder ausdrücklich noch stillschweigend, hinsichtlich der App oder ihrer Inhalte. Wir haften nicht für Schäden, die aus der Nutzung oder Unmöglichkeit der Nutzung der App entstehen.',
            ),
            const SizedBox(height: 16),
            const Text(
              '7. Änderungen der Nutzungsbedingungen',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Wir behalten uns das Recht vor, diese Nutzungsbedingungen jederzeit zu ändern. Änderungen werden in der App veröffentlicht und treten sofort in Kraft. Deine fortgesetzte Nutzung der App nach der Veröffentlichung der Änderungen gilt als Zustimmung zu den geänderten Bedingungen.',
            ),
            const SizedBox(height: 16),
            const Text(
              '8. Beendigung',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Wir können dein Konto und deinen Zugang zur App jederzeit und ohne Vorankündigung aus beliebigem Grund beenden oder aussetzen, einschließlich, aber nicht beschränkt auf Verstöße gegen diese Nutzungsbedingungen.',
            ),
            const SizedBox(height: 16),
            const Text(
              '9. Anwendbares Recht',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Diese Nutzungsbedingungen unterliegen den Gesetzen der Bundesrepublik Deutschland. Gerichtsstand für alle Streitigkeiten aus oder im Zusammenhang mit diesen Nutzungsbedingungen ist, soweit gesetzlich zulässig, der Sitz von JOTHAsoft und WorkBuddy.',
            ),
            const SizedBox(height: 16),
            const Text(
              '10. Kontakt',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Wenn du Fragen oder Bedenken zu diesen Nutzungsbedingungen hast, kontaktiere uns bitte unter:\n\n'
              'JOTHAsoft.de • Mobile Apps + Software\n'
              'Jürgen Hollmann\n'
              'Leutzestraße 64\n'
              '73525 Schwäbisch Gmünd\n'
              'Deutschland\n'
              'E-Mail: JOTHAsoft@gmail.com\n'
              'Telefon: +49-178-9697-193',
            ),
            const SizedBox(height: 16),
            const Text(
              'Diese Nutzungsbedingungen wurden zuletzt aktualisiert am 15.03.2025.',
            ),

            /*--------------------------------- Abstand ---*/
            wbSizedBoxHeight8,
            /*--------------------------------- Divider und Text ---*/
            WbDividerWithTextInCenter(
              wbColor: wbColorAppBarBlue,
              wbText: 'Die Nutzungsbedingungen speichern + drucken',
              wbTextColor: wbColorLogoBlue,
              wbFontSize12: 12,
              wbHeight3: 3,
            ),
            const Text(
              'Du kannst diese Nutzungsbedingungen durch Anklicken des untenstehenden Buttons als PDF-Datei generieren und direkt (mit entsprechender Eignung deines Geräts) ausdrucken, versenden, teilen oder woanders speichern.',
            ),
            /*--------------------------------- Divider ---*/
            Divider(color: wbColorLogoBlue, thickness: 3),

            /*--------------------------------- PDF erstellen ---*/
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: wbColorBackgroundBlue),
                onPressed: () async {
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
                                'Nutzungsbedingungen',
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

                      /*--------------------------------- Footer = Fußzeile ---*/
                      footer: (context) => pw.Container(
                        alignment: pw.Alignment.bottomRight,
                        margin: const pw.EdgeInsets.only(
                            top: 1.0 * PdfPageFormat.cm),
                        child: pw.Text(
                          '© JOTHAsoft.de • Mobile Apps + Software • Nutzungsbedingungen • Seite ${context.pageNumber} von ${context.pagesCount}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.black,
                          ),
                        ),
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
                              pw.Text(
                                '1. Einleitung\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Willkommen bei WorkBuddy!\nDiese Nutzungsbedingungen regeln deine Nutzung unserer mobilen Anwendung ("App"). Durch die Nutzung der App erklärst du dich mit diesen Bedingungen einverstanden. Wenn du nicht einverstanden bist, darfst du die App nicht nutzen.\n\n',
                              ),
                              pw.Text(
                                '2. Nutzung der App\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                '2.1. Berechtigung\n'
                                'Du musst mindestens 18 Jahre alt sein, um die App nutzen zu dürfen. Durch die Nutzung der App bestätigst du, dass du diese Altersanforderung erfüllst.\n\n'
                                '2.2. Registrierung\n'
                                'Die App ist in der Version "WorkBuddy-Basic" kostenfrei und Du kannst diese Version auch ohne Registrierung nutzen. Alle Daten, die Du in dieser Version speicherst, werden nur auf deinem Device (Smartphone, Tablet, etc.) gespeichert und auf keine Server übermittelt. Um aber bestimmte (kostenlose oder kostenpflichtige) Funktionen der App nutzen zu können, musst du dich registrieren und ein Konto erstellen. Du bist dafür verantwortlich, die Vertraulichkeit deiner Kontoinformationen zu wahren und alle Aktivitäten, die unter deinem Konto stattfinden, zu überwachen.\n\n',
                              ),
                              pw.Text(
                                '3. Datenschutz\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Deine Privatsphäre ist uns wichtig. Bitte lies unsere Datenschutzerklärung, um zu erfahren, ob und wie wir deine persönlichen Daten sammeln, verwenden und schützen.\n\n',
                              ),
                              pw.Text(
                                '4. Inhalte und geistiges Eigentum\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                '4.1. Inhalte\n'
                                'Alle Inhalte, die in der App verfügbar sind, einschließlich Texte, Grafiken, Logos, Bilder und Software, sind Eigentum von JOTHAsoft und WorkBuddy oder unseren Lizenzgebern und durch Urheberrechtsgesetze geschützt.\n\n'
                                '4.2. Lizenz\n'
                                'Wir gewähren dir eine beschränkte, nicht exklusive, nicht übertragbare Lizenz zur Nutzung der App für persönliche und geschäftliche Zwecke. Du darfst die App nicht ohne unsere ausdrückliche schriftliche Genehmigung modifizieren, kopieren, vertreiben, übertragen, anzeigen, aufführen, reproduzieren, veröffentlichen, lizenzieren, abgeleitete Werke erstellen oder verkaufen.\n\n',
                              ),
                              pw.Text(
                                '5. Verbotene Aktivitäten\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Du darfst die App nicht für illegale oder unbefugte Zwecke nutzen. Dazu gehören unter anderem:\n'
                                '- Das Hochladen von Viren oder schädlichem Code\n'
                                '- Das Sammeln von Informationen über andere Benutzer ohne deren Zustimmung\n'
                                '- Das Stören oder Unterbrechen der App oder der mit der App verbundenen Server oder Netzwerke\n\n',
                              ),

                              /*--------------------------------- Neue Seite ---*/
                              pw.NewPage(), // Neue Seite erzwingen funzt nicht
                              pw.SizedBox(height: 54),

                              /*--------------------------------- Text auf Seite 2 ---*/
                              pw.Text(
                                '6. Haftungsausschluss\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Die App wird "wie besehen" und "wie verfügbar" bereitgestellt. Wir übernehmen keine Gewährleistung, weder ausdrücklich noch stillschweigend, hinsichtlich der App oder ihrer Inhalte. Wir haften nicht für Schäden, die aus der Nutzung oder Unmöglichkeit der Nutzung der App entstehen.\n\n',
                              ),
                              pw.Text(
                                '7. Änderungen der Nutzungsbedingungen\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Wir behalten uns das Recht vor, diese Nutzungsbedingungen jederzeit zu ändern. Änderungen werden in der App veröffentlicht und treten sofort in Kraft. Deine fortgesetzte Nutzung der App nach der Veröffentlichung der Änderungen gilt als Zustimmung zu den geänderten Bedingungen.\n\n',
                              ),
                              pw.Text(
                                '8. Beendigung\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Wir können dein Konto und deinen Zugang zur App jederzeit und ohne Vorankündigung aus beliebigem Grund beenden oder aussetzen, einschließlich, aber nicht beschränkt auf Verstöße gegen diese Nutzungsbedingungen.\n\n',
                              ),
                              pw.Text(
                                '9. Anwendbares Recht\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Diese Nutzungsbedingungen unterliegen den Gesetzen der Bundesrepublik Deutschland. Gerichtsstand für alle Streitigkeiten aus oder im Zusammenhang mit diesen Nutzungsbedingungen ist, soweit gesetzlich zulässig, der Sitz von JOTHAsoft und WorkBuddy.\n\n',
                              ),
                              pw.Text(
                                '10. Kontakt\n',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Wenn du Fragen oder Bedenken zu diesen Nutzungsbedingungen hast, kontaktiere uns bitte unter:\n\n'
                                'JOTHAsoft.de • Mobile Apps + Software\n'
                                'Jürgen Hollmann\n'
                                'Leutzestraße 64\n'
                                '73525 Schwäbisch Gmünd\n'
                                'Deutschland\n'
                                'E-Mail: JOTHAsoft@gmail.com\n'
                                'Telefon: +49-178-9697-193\n\n',
                              ),
                              pw.Text(
                                'Diese Nutzungsbedingungen wurden zuletzt aktualisiert am 15.03.2025.\n\n'
                                'Druckdatum: Am ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year} um ${DateTime.now().hour}:${DateTime.now().minute} Uhr',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );

                  // Speichern der PDF-Datei im lokalen Speicher
                  final output = await getTemporaryDirectory();
                  final file = File("${output.path}/Nutzungsbedingungen.pdf");
                  await file.writeAsBytes(await pdf.save());

                  // Öffnen und Drucken der PDF-Datei
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
            const Divider(
              color: wbColorLogoBlue,
              thickness: 3,
            ),
            const SizedBox(height: 16),
            /*--------------------------------- *** ---*/
          ],
        ),
      ),
    );
  }
}
