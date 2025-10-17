import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../utils/constants.dart';

/// Screen for viewing PDF documents in-app
class PdfViewerScreen extends StatelessWidget {
  static const routeName = '/pdf-viewer';

  const PdfViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the arguments passed to this screen
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String title = args['title'] as String;
    final String assetPath = args['assetPath'] as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: saGovernmentGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SfPdfViewer.asset(
        assetPath,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        enableDoubleTapZooming: true,
      ),
    );
  }
}
