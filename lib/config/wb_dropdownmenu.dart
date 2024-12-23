import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_colors.dart';

class WBDropdownMenu extends StatefulWidget {
  const WBDropdownMenu({
    super.key,
    required this.headlineText,
    required this.hintText,
  });

  final String headlineText;
  final String hintText;

  @override
  State<WBDropdownMenu> createState() => _WBDropdownMenuState();
}

class _WBDropdownMenuState extends State<WBDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 400,
          child: Text(
            widget.headlineText, //"Wo wurde eingekauft?"
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: Text(
                widget.hintText, // "Welches Geachäft oder Lieferant?",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: wbColorAppBarBlue,
                ),
              ),
              isExpanded: true,
              //value: _selectedValue,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
              items: const [
                DropdownMenuItem(
                    value: "Wo_0000",
                    child: Text("--- Wo wurde eingekauft? ---")),
                DropdownMenuItem(value: "Wo_01", child: Text("OBI")),
                DropdownMenuItem(value: "Wo_02", child: Text("TOOM")),
                DropdownMenuItem(value: "Wo_03", child: Text("Kaufland")),
                DropdownMenuItem(value: "Wo_04", child: Text("ACTION")),
                DropdownMenuItem(value: "Wo_05", child: Text("WOOLWORTH")),

                // ------ Was wurde eingekauft? ------
                DropdownMenuItem(
                    value: "Was_0000",
                    child: Text("--- Was wurde eingekauft? ---")),
                DropdownMenuItem(value: "Was_0006", child: Text("Dachlatten")),
                DropdownMenuItem(
                    value: "Was_0007", child: Text("Spax-Schrauben")),
                DropdownMenuItem(value: "Was_0008", child: Text("Wurst")),
                DropdownMenuItem(value: "Was_0009", child: Text("Käse")),
                DropdownMenuItem(value: "Was_0010", child: Text("Brot")),

                // ------ Einheit ------
                DropdownMenuItem(
                    value: "Einheit_0000", child: Text("--- Einheiten ---")),
                DropdownMenuItem(value: "Einheit_0011", child: Text("Stk")),
                DropdownMenuItem(value: "Einheit_0012", child: Text("kg")),
                DropdownMenuItem(value: "Einheit_0013", child: Text("gr")),
                DropdownMenuItem(value: "Einheit_0014", child: Text("Pkg")),
                DropdownMenuItem(value: "Einheit_0015", child: Text("ltr")),

                // ------ MwSt % ------

                // ------ Warengruppe ------
                DropdownMenuItem(
                    value: "WG_0000", child: Text("--- Warengruppen ---")),
                DropdownMenuItem(value: "WG_0006", child: Text("Werkzeuge")),
                DropdownMenuItem(value: "WG_0007", child: Text("Ersatzteile")),
                DropdownMenuItem(value: "WG_0008", child: Text("Büroartikel")),
                DropdownMenuItem(value: "WG_0009", child: Text("Zubehör")),
                DropdownMenuItem(value: "WG_0010", child: Text("Kabel")),

                // ------ Wer hat eingekauft? ------
                DropdownMenuItem(
                    value: "EK_0000", child: Text("--- Einkäufer ---")),
                DropdownMenuItem(value: "EK_0006", child: Text("Klaus")),
                DropdownMenuItem(value: "EK_0007", child: Text("Paul")),
                DropdownMenuItem(value: "EK_0008", child: Text("Carla")),
                DropdownMenuItem(value: "EK_0009", child: Text("Paula")),
                DropdownMenuItem(value: "EK_0010", child: Text("Schorsch")),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  //_selectedValue = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
