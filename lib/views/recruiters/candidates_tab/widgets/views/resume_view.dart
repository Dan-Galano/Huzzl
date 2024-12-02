import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/open_in_newtab.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';



class ResumeView extends StatefulWidget {
  const ResumeView({super.key});

  @override
  State<ResumeView> createState() => _ResumeViewState();
}

class _ResumeViewState extends State<ResumeView> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => openPdfInNewTab('assets/pdf/my_portfolio_1.pdf'),
          child: Text(
            "Open Resume in New Tab",
            style: TextStyle(
              color: Color(0xFFff9800),
            ),
          ),
        ),
        Container(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 900,
              maxWidth: 800,
            ),
            child: SfPdfViewer.asset(
              'assets/pdf/my_portfolio_1.pdf',
              controller: _pdfViewerController,
              initialZoomLevel: 1.0,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              onDocumentLoaded: (details) => print('Document loaded'),
              onDocumentLoadFailed: (details) =>
                  print('Document failed to load'),
            ),
          ),
        ),
        Divider(
          thickness: 2,
          color: Color(0xFFff9800),
          height: 60,
        ),
      ],
    );
  }
}

