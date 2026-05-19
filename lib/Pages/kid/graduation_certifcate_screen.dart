import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kido/Pages/parent_content/parent_home_page.dart';
import 'package:kido/Widgets/Buttons/custom_app_button.dart';
import 'package:kido/Widgets/Layout/snackbar.dart';
import 'package:kido/constants.dart';
import 'package:kido/services/certificate_pdf_service.dart';

class GraduationCertificateScreen extends StatefulWidget {
  final String childName;
  final int score;
  final int total;

  const GraduationCertificateScreen({
    super.key,
    required this.childName,
    this.score = 0,
    this.total = 0,
  });

  @override
  State<GraduationCertificateScreen> createState() =>
      _GraduationCertificateScreenState();
}

class _GraduationCertificateScreenState
    extends State<GraduationCertificateScreen> {
  final GlobalKey _certificateKey = GlobalKey();
  bool _isDownloading = false;

  String get _formattedDate =>
      DateFormat('MMMM d, yyyy').format(DateTime.now());

  Future<void> _downloadCertificate() async {
    if (_isDownloading) return;

    setState(() => _isDownloading = true);

    try {
      await Future.delayed(const Duration(milliseconds: 120));

      final pngBytes = await CertificatePdfService.captureWidgetPng(
        _certificateKey,
      );
      if (pngBytes == null) {
        if (mounted) {
          showKidoSnack(
            context,
            'Could not prepare certificate. Please try again.',
          );
        }
        return;
      }

      final pdfBytes = await CertificatePdfService.buildPdfFromPng(pngBytes);
      await CertificatePdfService.sharePdf(
        pdfBytes: pdfBytes,
        childName: widget.childName,
      );
    } catch (e) {
      if (mounted) {
        showKidoSnack(context, 'Download failed. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  void _finishToParentHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const ParentHomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your certificate',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: (media.size.width * 0.055).clamp(18.0, 24.0),
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                // CHANGED: Wrapped in a Center widget to force vertical alignment alignment in the viewport
                child: Center(
                  child: RepaintBoundary(
                    key: _certificateKey,
                    child: _CertificateCard(
                      childName: widget.childName,
                      formattedDate: _formattedDate,
                      score: widget.score,
                      total: widget.total,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                children: [
                  Opacity(
                    opacity: _isDownloading ? 0.65 : 1,
                    child: CustomGradientButton(
                      title:
                          _isDownloading ? 'Preparing PDF...' : 'Download PDF',
                      onPressed: _isDownloading ? () {} : _downloadCertificate,
                      width: double.infinity,
                      borderRadius: 28,
                      fontSize: 18,
                      colors: const [AppColors.kidoBlue, AppColors.purpleMain],
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomGradientButton(
                    title: 'Finish',
                    onPressed: _finishToParentHome,
                    width: double.infinity,
                    borderRadius: 28,
                    fontSize: 18,
                    colors: const [AppColors.kidoPink, AppColors.kidoOrange],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final String childName;
  final String formattedDate;
  final int score;
  final int total;

  const _CertificateCard({
    required this.childName,
    required this.formattedDate,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.35,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.kidoPink,
              AppColors.kidoOrange,
              AppColors.kidoYellow,
              AppColors.kidoGreen,
              AppColors.kidoBlue,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.kidoPink.withValues(alpha: 0.28),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBF7),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -30,
                right: -20,
                child: _bubble(90, AppColors.kidoBlue.withValues(alpha: 0.12)),
              ),
              Positioned(
                bottom: -25,
                left: -15,
                child: _bubble(70, AppColors.kidoPink.withValues(alpha: 0.14)),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: _bubble(
                  36,
                  AppColors.kidoYellow.withValues(alpha: 0.35),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (i) => Icon(
                          Icons.star_rounded,
                          size: 18,
                          color:
                              AppColors.kidoColors[i %
                                  AppColors.kidoColors.length],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Certificate of Graduation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.purpleMain,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Kido Learning Adventure',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGray.withValues(alpha: 0.9),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This certifies that',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textDark.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      childName,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 70),
                        child: Image.asset(
                          'assets/gif/graduation.gif',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'has successfully completed all Kido levels!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.kidoGreen.withValues(alpha: 0.95),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 100,
                      height: 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          colors: [AppColors.kidoPink, AppColors.kidoOrange],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textGray.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Official Kido Graduate',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kidoOrange.withValues(alpha: 0.95),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bubble(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
