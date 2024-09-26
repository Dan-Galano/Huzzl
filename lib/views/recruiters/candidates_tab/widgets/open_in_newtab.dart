
import 'dart:html' as html;

void openPdfInNewTab(pdfUrl) {
  final url = Uri.base.resolve(pdfUrl).toString();
  html.window.open(url, '_blank');
}