import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdf extends StatefulWidget {
  final pdfUrl;

  const ViewPdf({
    Key? key,
    required this.pdfUrl,
  }) : super(key: key);

  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
PdfViewerController? _pdfViewerController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Pdf"),),
      body: SfPdfViewer.network(
          widget.pdfUrl,
        controller: _pdfViewerController,
      ),

    );
  }
}
