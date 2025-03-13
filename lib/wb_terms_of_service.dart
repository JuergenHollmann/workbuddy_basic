import 'package:flutter/material.dart';

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
          children: const [
            Text(
              'Nutzungsbedingungen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '1. Einleitung',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Willkommen bei WorkBuddy! Diese Nutzungsbedingungen regeln deine Nutzung unserer mobilen Anwendung ("App"). Durch die Nutzung der App erklärst du dich mit diesen Bedingungen einverstanden. Wenn du nicht einverstanden bist, darfst du die App nicht nutzen.',
            ),
            SizedBox(height: 16),
            Text(
              '2. Nutzung der App',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '2.1. Berechtigung\n'
              'Du musst mindestens 18 Jahre alt sein, um die App nutzen zu dürfen. Durch die Nutzung der App bestätigst du, dass du diese Altersanforderung erfüllst.\n\n'
              '2.2. Registrierung\n'
              'Um bestimmte Funktionen der App nutzen zu können, musst du dich registrieren und ein Konto erstellen. Du bist dafür verantwortlich, die Vertraulichkeit deiner Kontoinformationen zu wahren und alle Aktivitäten, die unter deinem Konto stattfinden, zu überwachen.',
            ),
            SizedBox(height: 16),
            Text(
              '3. Datenschutz',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Deine Privatsphäre ist uns wichtig. Bitte lies unsere Datenschutzerklärung, um zu erfahren, wie wir deine persönlichen Daten sammeln, verwenden und schützen.',
            ),
            SizedBox(height: 16),
            Text(
              '4. Inhalte und geistiges Eigentum',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '4.1. Inhalte\n'
              'Alle Inhalte, die in der App verfügbar sind, einschließlich Texte, Grafiken, Logos, Bilder und Software, sind Eigentum von WorkBuddy oder unseren Lizenzgebern und durch Urheberrechtsgesetze geschützt.\n\n'
              '4.2. Lizenz\n'
              'Wir gewähren dir eine beschränkte, nicht exklusive, nicht übertragbare Lizenz zur Nutzung der App für persönliche, nicht kommerzielle Zwecke. Du darfst die App nicht modifizieren, kopieren, vertreiben, übertragen, anzeigen, aufführen, reproduzieren, veröffentlichen, lizenzieren, abgeleitete Werke erstellen oder verkaufen.',
            ),
            SizedBox(height: 16),
            Text(
              '5. Verbotene Aktivitäten',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Du darfst die App nicht für illegale oder unbefugte Zwecke nutzen. Dazu gehören unter anderem:\n'
              '- Das Hochladen von Viren oder schädlichem Code\n'
              '- Das Sammeln von Informationen über andere Benutzer ohne deren Zustimmung\n'
              '- Das Stören oder Unterbrechen der App oder der mit der App verbundenen Server oder Netzwerke',
            ),
            SizedBox(height: 16),
            Text(
              '6. Haftungsausschluss',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Die App wird "wie besehen" und "wie verfügbar" bereitgestellt. Wir übernehmen keine Gewährleistung, weder ausdrücklich noch stillschweigend, hinsichtlich der App oder ihrer Inhalte. Wir haften nicht für Schäden, die aus der Nutzung oder Unmöglichkeit der Nutzung der App entstehen.',
            ),
            SizedBox(height: 16),
            Text(
              '7. Änderungen der Nutzungsbedingungen',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Wir behalten uns das Recht vor, diese Nutzungsbedingungen jederzeit zu ändern. Änderungen werden in der App veröffentlicht und treten sofort in Kraft. Deine fortgesetzte Nutzung der App nach der Veröffentlichung der Änderungen gilt als Zustimmung zu den geänderten Bedingungen.',
            ),
            SizedBox(height: 16),
            Text(
              '8. Beendigung',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Wir können dein Konto und deinen Zugang zur App jederzeit und ohne Vorankündigung aus beliebigem Grund beenden oder aussetzen, einschließlich, aber nicht beschränkt auf, Verstöße gegen diese Nutzungsbedingungen.',
            ),
            SizedBox(height: 16),
            Text(
              '9. Anwendbares Recht',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Diese Nutzungsbedingungen unterliegen den Gesetzen der Bundesrepublik Deutschland. Gerichtsstand für alle Streitigkeiten aus oder im Zusammenhang mit diesen Nutzungsbedingungen ist, soweit gesetzlich zulässig, der Sitz von WorkBuddy.',
            ),
            SizedBox(height: 16),
            Text(
              '10. Kontakt',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Wenn du Fragen oder Bedenken zu diesen Nutzungsbedingungen hast, kontaktiere uns bitte unter:\n\n'
              'JOTHAsoft.de • Mobile Apps + Software\n'
              'Jürgen Hollmann\n'
              'Leutzestraße 64\n'
              '73525 Schwäbisch Gmünd\n'
              'Deutschland\n'
              'E-Mail: JOTHAsoft@gmail.com\n'
              'Telefon: +49-178-9697-193',
            ),
            SizedBox(height: 16),
            Text(
              'Diese Nutzungsbedingungen wurden zuletzt aktualisiert am [Datum].',
            ),
          ],
        ),
      ),
    );
  }
}
