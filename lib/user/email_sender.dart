import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailSender {
  static const String username = 'admin@quickroll.in';
  static const String password = 'Onelove@3040';

  static Future<void> sendEmail({
    required String recipientEmail,
    required String subject,
    required String body,
  }) async {
    final smtpServer = SmtpServer(
      'smtp.hostinger.com',
      port: 465,
      ssl: true,
      username: username,
      password: password,
    );

    // HTML Header
    const String htmlHeader = '''
      <div style="background-color:#35BC52;padding:20px;text-align:center;color:#ffffff;font-family:Arial,sans-serif;">
        <h1 style="margin:0;">QuickRoll</h1>
        <p style="margin:0;font-size:16px;">Your trusted partner in seamless operations</p>
      </div>
    ''';

    // HTML Footer
    const String htmlFooter = '''
      <div style="background-color:#f0f0f0;padding:20px;text-align:center;font-family:Arial,sans-serif;font-size:12px;color:#666;">
        <p style="margin:0;">© 2025 QuickRoll. All rights reserved.</p>
        <p style="margin:5px 0 0;">Follow us on 
          <a href="https://twitter.com/quickroll" style="color:#35BC52;text-decoration:none;">Twitter</a>, 
          <a href="https://facebook.com/quickroll" style="color:#35BC52;text-decoration:none;">Facebook</a>
        </p>
      </div>
    ''';

    // Combine HTML
    final String fullHtmlBody = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
        </head>
        <body style="margin:0;padding:0;">
          $htmlHeader
          <div style="padding:20px;font-family:Arial,sans-serif;font-size:14px;line-height:1.6;color:#333;">
            $body
          </div>
          $htmlFooter
        </body>
      </html>
    ''';

    final message = Message()
      ..from = Address(username, 'QuickRoll Admin')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..html = fullHtmlBody;

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Email failed to send.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      print('Unknown error: $e');
    }
  }
}
