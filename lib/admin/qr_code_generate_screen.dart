// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:quick_roll/utils/admin_colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:pdf/pdf.dart';
// import 'dart:typed_data';

// class QRCodeGenerateScreen extends StatefulWidget {
//   const QRCodeGenerateScreen({super.key});

//   @override
//   _QRCodeGenerateScreenState createState() => _QRCodeGenerateScreenState();
// }

// class _QRCodeGenerateScreenState extends State<QRCodeGenerateScreen> {
//   String? _qrData;

//   @override
//   void initState() {
//     super.initState();
//     _generateQRCode();
//   }

//   void _generateQRCode() async {
//     final prefs = await SharedPreferences.getInstance();
//     final companyData = prefs.getString('companyData');

//     if (companyData != null) {
//       setState(() {
//         _qrData = companyData;
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No company data found!')),
//       );
//     }
//   }

//   Future<void> _downloadQrPdf() async {
//     if (_qrData == null) return;
//     final pdf = pw.Document();

//     final qrImage = await QrPainter(
//       data: _qrData!,
//       version: QrVersions.auto,
//       gapless: true,
//     ).toImageData(400);

//     pdf.addPage(
//       pw.Page(
//         build: (context) => pw.Center(
//           child: pw.Column(
//             mainAxisAlignment: pw.MainAxisAlignment.center,
//             children: [
//               pw.Text('Company QR Code',
//                   style: pw.TextStyle(
//                       fontSize: 22, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 24),
//               if (qrImage != null)
//                 pw.Center(
//                   child: pw.Image(
//                     pw.MemoryImage(qrImage.buffer.asUint8List()),
//                     width: 200,
//                     height: 200,
//                   ),
//                 ),
//               pw.SizedBox(height: 16),
//               // pw.Text(_qrData!, style: pw.TextStyle(fontSize: 10)),
//             ],
//           ),
//         ),
//       ),
//     );

//     await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => pdf.save(),
//       name: 'company_qr_code.pdf',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.skyBlue,
//         title: const Text(
//           'Generate QR Code',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: AppColors.charcoalGray,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 32),
//               if (_qrData != null)
//                 Column(
//                   children: [
//                     const Text(
//                       'Generated QR Code:',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Center(
//                       child: QrImageView(
//                         data: _qrData!,
//                         version: QrVersions.auto,
//                         size: 200.0,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     ElevatedButton.icon(
//                       onPressed: _downloadQrPdf,
//                       icon: const Icon(Icons.download, color: AppColors.white),
//                       label: const Text(
//                         'Download QR as PDF',
//                         style: TextStyle(color: AppColors.white),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.skyBlue,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 24, vertical: 12),
//                       ),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quick_roll/utils/admin_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

class QRCodeGenerateScreen extends StatefulWidget {
  const QRCodeGenerateScreen({super.key});

  @override
  _QRCodeGenerateScreenState createState() => _QRCodeGenerateScreenState();
}

class _QRCodeGenerateScreenState extends State<QRCodeGenerateScreen> {
  String? _qrData;

  // Secret key and signature for AES encryption (store securely in production)
  static const String _qrSignature = 'ATTENDANCE_APP_V1_2025';
  static final _key = encrypt.Key.fromUtf8(
      'your-32-byte-secret-key-here1234'); // 32 bytes for AES-256
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  @override
  void initState() {
    super.initState();
    _generateQRCode();
  }

  void _generateQRCode() async {
    final prefs = await SharedPreferences.getInstance();
    final companyData = prefs.getString('companyData');

    if (companyData != null) {
      // Generate random IV
      final iv = encrypt.IV.fromSecureRandom(16);
      // Encrypt the QR data with signature
      String signedData = '$_qrSignature$companyData';
      String encryptedData = _encrypter.encrypt(signedData, iv: iv).base64;
      // Combine IV and encrypted data
      String qrData = '${iv.base64}:$encryptedData';
      setState(() {
        _qrData = qrData;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No company data found!')),
      );
    }
  }

  Future<void> _downloadQrPdf() async {
    if (_qrData == null) return;
    final pdf = pw.Document();

    final qrImage = await QrPainter(
      data: _qrData!,
      version: QrVersions.auto,
      gapless: true,
    ).toImageData(400);

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Company QR Code',
                  style: pw.TextStyle(
                      fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 24),
              if (qrImage != null)
                pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(qrImage.buffer.asUint8List()),
                    width: 200,
                    height: 200,
                  ),
                ),
              pw.SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'company_qr_code.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text(
          'Generate QR Code',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.charcoalGray,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              if (_qrData != null)
                Column(
                  children: [
                    const Text(
                      'Generated QR Code:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: QrImageView(
                        data: _qrData!,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _downloadQrPdf,
                      icon: const Icon(Icons.download, color: AppColors.white),
                      label: const Text(
                        'Download QR as PDF',
                        style: TextStyle(color: AppColors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.skyBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
