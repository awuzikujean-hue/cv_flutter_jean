import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../core/constants/app_assets.dart';
import '../../data/cv_data.dart';
import '../../data/profile_data.dart';
import '../../models/cv_entry.dart';

/// Génère le CV au format PDF (A4) et ouvre la boîte d'impression /
/// d'enregistrement. Le contenu vient de [CvData] et [ProfileData].
abstract final class CvPdfService {
  static final PdfColor _navy = PdfColor.fromInt(0xFF0B1F3A);
  static final PdfColor _blue = PdfColor.fromInt(0xFF1976D2);
  static final PdfColor _grey = PdfColor.fromInt(0xFF5B6B80);
  static final PdfColor _soft = PdfColor.fromInt(0xFFE8F1FC);

  static Future<void> printCv() async {
    final doc = await _build();
    await Printing.layoutPdf(
      onLayout: (format) async => doc.save(),
      name: 'CV_Opua_Awuziku_Jean.pdf',
    );
  }

  static Future<pw.Document> _build() async {
    final photo = await _loadPhoto();
    final doc = pw.Document(
      title: 'CV - ${ProfileData.fullName}',
      author: ProfileData.fullName,
    );

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _header(photo),
            pw.SizedBox(height: 22),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: 165,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _section('Contact', [
                        _text(ProfileData.phone),
                        pw.SizedBox(height: 4),
                        _text(ProfileData.email),
                        pw.SizedBox(height: 4),
                        _text(ProfileData.address),
                      ]),
                      pw.SizedBox(height: 18),
                      _section('Compétences', [_tags(CvData.skills)]),
                      pw.SizedBox(height: 18),
                      _section('Langues', [_tags(CvData.languages)]),
                      pw.SizedBox(height: 18),
                      _section('Centres d’intérêt', [_tags(CvData.interests)]),
                    ],
                  ),
                ),
                pw.SizedBox(width: 24),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _section('Formation académique', _entries(CvData.education)),
                      pw.SizedBox(height: 18),
                      _section(
                        'Expérience professionnelle',
                        _entries(CvData.experiences),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return doc;
  }

  static Future<pw.ImageProvider?> _loadPhoto() async {
    try {
      final data = await rootBundle.load(AppAssets.profilePhoto);
      return pw.MemoryImage(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
    } catch (_) {
      return null;
    }
  }

  // Les polices PDF standard ne gèrent pas certains signes typographiques.
  static String _s(String value) => value
      .replaceAll('’', "'")
      .replaceAll('—', '-')
      .replaceAll('–', '-')
      .replaceAll('•', '-');

  static pw.Widget _text(String value, {double size = 10, PdfColor? color}) {
    return pw.Text(
      _s(value),
      style: pw.TextStyle(fontSize: size, color: color ?? _grey),
    );
  }

  static pw.Widget _header(pw.ImageProvider? photo) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(
        color: _navy,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
      ),
      child: pw.Row(
        children: [
          if (photo != null) ...[
            pw.ClipOval(
              child: pw.Container(
                width: 74,
                height: 74,
                child: pw.Image(
                  photo,
                  fit: pw.BoxFit.cover,
                  alignment: pw.Alignment.topCenter,
                ),
              ),
            ),
            pw.SizedBox(width: 18),
          ],
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  _s(ProfileData.fullName),
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
                pw.SizedBox(height: 5),
                _text(ProfileData.title, size: 12, color: PdfColors.white),
                _text(ProfileData.speciality, size: 10.5, color: PdfColors.grey300),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _section(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          _s(title).toUpperCase(),
          style: pw.TextStyle(
            fontSize: 10.5,
            fontWeight: pw.FontWeight.bold,
            color: _blue,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Container(width: 30, height: 2, color: _blue),
        pw.SizedBox(height: 8),
        ...children,
      ],
    );
  }

  static pw.Widget _tags(List<String> items) {
    return pw.Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final item in items)
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: pw.BoxDecoration(
              color: _soft,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Text(
              _s(item),
              style: pw.TextStyle(fontSize: 9, color: _navy),
            ),
          ),
      ],
    );
  }

  static List<pw.Widget> _entries(List<CvEntry> entries) {
    return [
      for (var i = 0; i < entries.length; i++) ...[
        if (i > 0) pw.SizedBox(height: 10),
        _entry(entries[i]),
      ],
    ];
  }

  static pw.Widget _entry(CvEntry entry) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          _s(entry.title),
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: _navy,
          ),
        ),
        if (entry.subtitle != null) _text(entry.subtitle!, color: _blue),
        if (entry.description != null) ...[
          pw.SizedBox(height: 3),
          _text(entry.description!),
        ],
        for (final bullet in entry.bullets)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 3),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 4, right: 6),
                  width: 3.5,
                  height: 3.5,
                  decoration: pw.BoxDecoration(
                    color: _blue,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.Expanded(child: _text(bullet)),
              ],
            ),
          ),
      ],
    );
  }
}
