import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../utils/constants.dart';
import 'pdf_viewer_screen.dart';

/// Document model
class Document {
  final String title;
  final String subtitle;
  final String description;
  final String fileName;
  final String fileSize;
  final Color color;
  final IconData icon;

  const Document({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.fileName,
    required this.fileSize,
    required this.color,
    this.icon = Icons.picture_as_pdf,
  });
}

/// Screen showing available resources and documents
class ResourcesScreen extends StatefulWidget {
  static const routeName = '/resources';

  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  String? _downloadingFile;

  // List of available documents
  static const List<Document> _documents = [
    Document(
      title: 'NIDS Booklet 2017',
      subtitle: 'National Indicator Data Set',
      description:
          'The official NIDS booklet containing comprehensive information about all indicators, their definitions, and usage guidelines.',
      fileName: 'NIDS_booklet_2017.pdf',
      fileSize: '2.8 MB',
      color: Colors.red,
    ),
    Document(
      title: 'VMMC Guidelines 2025',
      subtitle: 'Voluntary Medical Male Circumcision',
      description:
          'Comprehensive guidelines for voluntary medical male circumcision programs, including clinical protocols and best practices.',
      fileName: 'VMMC_Guidelines_2025.pdf',
      fileSize: '11 MB',
      color: Color(0xFF2196F3), // Blue
    ),
    Document(
      title: 'Maternal & Perinatal Care',
      subtitle: 'Integrated Clinical Guideline',
      description:
          'Integrated maternal and perinatal care guidelines covering pregnancy, childbirth, and postnatal care protocols.',
      fileName: 'Maternal_Perinatal_Care_Guideline.pdf',
      fileSize: '14 MB',
      color: Color(0xFFE91E63), // Pink
    ),
    Document(
      title: 'DHMIS Policy 2011',
      subtitle: 'District Health Management Information System',
      description:
          'Policy framework for the District Health Management Information System, including data collection and reporting standards.',
      fileName: 'DHMIS_Policy_2011.pdf',
      fileSize: '481 KB',
      color: Color(0xFF9C27B0), // Purple
    ),
  ];

  Future<void> _downloadPDF(Document document) async {
    setState(() {
      _downloadingFile = document.fileName;
    });

    try {
      // Load the PDF from assets
      final ByteData data =
          await rootBundle.load('assets/documents/${document.fileName}');
      final bytes = data.buffer.asUint8List();

      // Get the directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${document.fileName}';

      // Write the file
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      setState(() {
        _downloadingFile = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${document.title} downloaded successfully'),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Share',
              onPressed: () => _sharePDF(document, filePath),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _downloadingFile = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sharePDF(Document document, String filePath) async {
    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: document.title,
        text: document.subtitle,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Opens PDF in the in-app viewer
  void _openPDF(Document document) {
    Navigator.of(context).pushNamed(
      PdfViewerScreen.routeName,
      arguments: {
        'title': document.title,
        'assetPath': 'assets/documents/${document.fileName}',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            // Custom App Bar
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12.0,
                bottom: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              decoration: const BoxDecoration(
                color: saGovernmentGreen,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Resources',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page Header
                    Text(
                      'Available Documents',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Access and download official NIDS documentation',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Document Cards
                    ..._documents.map((doc) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildDocumentCard(doc),
                        )),

                    // Info Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'These documents are available offline once downloaded. You can view them anytime without an internet connection.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blue.shade900,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(Document document) {
    final bool isDownloading = _downloadingFile == document.fileName;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: document.color.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: document.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    document.icon,
                    color: document.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        document.subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: document.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    document.fileSize,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: document.color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              document.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openPDF(document),
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('View'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: saGovernmentGreen,
                      side: const BorderSide(color: saGovernmentGreen),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        isDownloading ? null : () => _downloadPDF(document),
                    icon: isDownloading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.download, size: 18),
                    label: Text(isDownloading ? 'Downloading...' : 'Download'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: saGovernmentGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
