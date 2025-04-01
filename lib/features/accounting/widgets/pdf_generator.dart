import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGenerator {
  static Future<void> generatePdf(
    String shop,
    String wasGekauft,
    String quantity,
    String item,
    String nettoItemPrice,
    String nettoQuantityPrice,
    String taxPercent,
    String bruttoItemPrice,
    String taxOnBruttoItemPrice,
    String bruttoQuantityPrice,
    String zahlungsmittel,
    String warengruppe,
    String einkaeufer,
    String notizen,
  ) async {
    final pdf = pw.Document();

    final logoImage = pw.MemoryImage(
      (await rootBundle
              .load('assets/company_logos/enpower_expert_logo_4_x_4.png'))
          .buffer
          .asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.zero,
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: pw.Container(
                  width: double.infinity,
                  height: 50,
                  color: PdfColors.white,
                  alignment: pw.Alignment.centerLeft,
                  padding: pw.EdgeInsets.fromLTRB(16, 0, 10, 0),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        'Ausgabe-Beleg-Nr.: _________',
                        style: pw.TextStyle(
                          fontSize: 16,
                          color: PdfColors.black,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'EnPower-Expert.de\nLeutzestraße 64\nD-73525 Schwäbisch Gmünd',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(fontSize: 12),
                      ),
                      pw.Image(logoImage, width: 50, height: 50),
                    ],
                  ),
                ),
              ),
              pw.Positioned(
                top: 60,
                left: 16,
                right: 16,
                child: pw.Divider(thickness: 1, color: PdfColors.black),
              ),
              pw.Positioned(
                top: 80,
                bottom: 0,
                left: 0,
                child: pw.Padding(
                  padding: pw.EdgeInsets.fromLTRB(32, 0, 16, 0),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildInfoContainer('Datum des Einkaufs:', '31.03.2025'),
                      pw.SizedBox(height: 10),
                      _buildInfoContainer('Wo eingekauft:', shop),
                      pw.SizedBox(height: 10),
                      _buildInfoContainer('Was eingekauft:', wasGekauft),
                      pw.SizedBox(height: 10),
                      _buildInfoContainer(
                          'Menge und Einheit:', '$quantity $item'),
                      pw.SizedBox(height: 10),
                      _buildInfoContainer(
                          'Netto-Einzelpreis:', '$nettoItemPrice EUR'),
                      pw.SizedBox(height: 10),
                      _buildInfoContainer(
                          'Netto-Gesamtpreis:', '$nettoQuantityPrice EUR'),
                      pw.SizedBox(height: 10),
                      _buildInfoContainer(
                          'Mehrwertsteuersatz:', '$taxPercent %'),
                      pw.SizedBox(height: 10),
                      _buildInfoContainer(
                          'Brutto-Einzelpreis:', '$bruttoItemPrice EUR'),
                      pw.SizedBox(height: 10),
                      _buildInfoContainer(
                          'MwSt. Brutto-Gesamt:', '$taxOnBruttoItemPrice EUR'),
                      pw.SizedBox(height: 10),
                      _buildInfoContainer(
                          'Brutto-Gesamtpreis:', '$bruttoQuantityPrice EUR'),
                      pw.SizedBox(height: 10),
                      _buildInfoContainer('Zahlungsmittel:', zahlungsmittel),
                      pw.SizedBox(height: 10),
                      _buildInfoContainer('Warengruppe:', warengruppe),
                      pw.SizedBox(height: 10),
                      _buildInfoContainer('Einkäufer:', einkaeufer),
                      pw.SizedBox(height: 10),
                      _buildInfoContainer('Notizen:', notizen),
                    ],
                  ),
                ),
              ),
              pw.Positioned(
                bottom: 10,
                left: 16,
                right: 16,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Divider(thickness: 1, color: PdfColors.black),
                    pw.Text(
                      '© JOTHAsoft.de - Seite ${context.pageNumber} von ${context.pagesCount}',
                      style: pw.TextStyle(fontSize: 10, color: PdfColors.black),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _buildInfoContainer(String label, String value) {
    return pw.Container(
      width: 220,
      padding: pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label),
          pw.Text(
            value,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
