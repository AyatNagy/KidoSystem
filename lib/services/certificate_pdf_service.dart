import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Builds and shares a certificate PDF from an on-screen widget capture.
class CertificatePdfService {
  static Future<Uint8List?> captureWidgetPng(GlobalKey boundaryKey) async {
    final boundary =
        boundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) return null;

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  static Future<Uint8List> buildPdfFromPng(Uint8List pngBytes) async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(pngBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build:
            (context) =>
                pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
      ),
    );

    return pdf.save();
  }

  static Future<void> sharePdf({
    required Uint8List pdfBytes,
    required String childName,
  }) async {
    final safeName =
        childName.trim().isEmpty
            ? 'kido_graduate'
            : childName
                .trim()
                .replaceAll(RegExp(r'[^\w\s-]'), '')
                .replaceAll(' ', '_');
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: '${safeName}_kido_certificate.pdf',
    );
  }
}
