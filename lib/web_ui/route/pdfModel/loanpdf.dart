import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

import 'package:printing/printing.dart';

class PDFSave extends StatefulWidget {
  String loanid, coopid, userid;
  PDFSave({
    super.key,
    required this.loanid,
    required this.coopid,
    required this.userid,
  });
  @override
  _PDFSaveState createState() => _PDFSaveState();
}

class _PDFSaveState extends State<PDFSave> {
  final pdf = pw.Document();
  var anchor;

  savePDF() async {
    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download =
          '${DateFormat('yyyyMMddHHmm').format(DateTime.now())}_${widget.loanid}.pdf';
    html.document.body?.children.add(anchor);
    return anchor.click();
  }

  createPDF() async {
    myDb
        .collectionGroup('tenure')
        .where('loanId', isEqualTo: widget.loanid)
        .where('coopId', isEqualTo: widget.coopid)
        .orderBy('dueDate')
        .get()
        .then((tenure) {
      myDb
          .collection('loans')
          .where('userId', isEqualTo: widget.userid)
          .where('coopId', isEqualTo: widget.coopid)
          .where('loanId', isEqualTo: widget.loanid)
          .get()
          .then((loan) {
        myDb
            .collection('subscribers')
            .where('userId', isEqualTo: widget.userid)
            .where('coopId', isEqualTo: widget.coopid)
            .get()
            .then((user) {
          myDb
              .collection('subscribers')
              .doc('${widget.coopid}_${widget.userid}')
              .collection('coopAccDetails')
              .doc('Data')
              .get()
              .then((userdata) async {
            myDb
                .collection('staffs')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get()
                .then((staff) async {
              myDb
                  .collection('coops')
                  .doc(widget.coopid)
                  .get()
                  .then((coops) async {
                myDb
                    .collection('coops')
                    .doc(widget.coopid)
                    .collection('loanTypes')
                    .doc(loan.docs[0]['loanType'])
                    .get()
                    .then((coopdata) async {
                  final ttf = await PdfGoogleFonts.robotoRegular();
                  final ttfbold = await PdfGoogleFonts.robotoBlack();
                  // final font = await rootBundle
                  //     .load("assets/fonts/Montserrat-Regular.ttf");
                  // final ttf = pw.Font.ttf(font);
                  pdf.addPage(
                    pw.Page(
                      pageFormat: PdfPageFormat.a4,
                      build: (pw.Context context) => pw.Container(
                        width: 2480,
                        height: 3508,
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Container(
                              alignment: pw.Alignment.topCenter,
                              child: pw.Column(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text(
                                    coops.data()!['coopName'],
                                    style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold,
                                      font: ttfbold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  pw.Text(
                                    coops.data()!['coopAddress'],
                                    style: pw.TextStyle(
                                      font: ttf,
                                      fontSize: 11,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          vertical: 2)),
                                  pw.Divider(
                                    thickness: 0.7,
                                    height: 0.7,
                                  )
                                ],
                              ),
                            ),
                            pw.Padding(
                                padding:
                                    const pw.EdgeInsets.symmetric(vertical: 5)),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text('Statement of Active Loan',
                                    style: pw.TextStyle(
                                      fontSize: 16,
                                      fontWeight: pw.FontWeight.bold,
                                      font: ttfbold,
                                      letterSpacing: 1,
                                    ))
                              ],
                            ),
                            pw.Padding(
                                padding:
                                    const pw.EdgeInsets.symmetric(vertical: 7)),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Container(
                                  width: 2480,
                                  padding: const pw.EdgeInsets.only(right: 8),
                                  child: pw.Column(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.RichText(
                                        text: pw.TextSpan(
                                          text: "Borrower's Name:  ",
                                          style: pw.TextStyle(
                                            font: ttf,
                                            fontSize: 11,
                                          ),
                                          children: [
                                            pw.TextSpan(
                                              text:
                                                  '${user.docs[0]['userLastName']}, ${user.docs[0]['userFirstName']} ${user.docs[0]['userMiddleName'].toString()[0]}.'
                                                      .toUpperCase(),
                                              style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                font: ttfbold,
                                                letterSpacing: 1,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      pw.RichText(
                                        text: pw.TextSpan(
                                          text: 'Email:  ',
                                          style: pw.TextStyle(
                                            font: ttf,
                                            fontSize: 11,
                                          ),
                                          children: [
                                            pw.TextSpan(
                                              text:
                                                  '${user.docs[0]['userEmail']}',
                                              style: pw.TextStyle(
                                                fontWeight:
                                                    pw.FontWeight.normal,
                                                font: ttf,
                                                letterSpacing: 1,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      pw.RichText(
                                        text: pw.TextSpan(
                                          text: 'Address:  ',
                                          style: pw.TextStyle(
                                            font: ttf,
                                            fontSize: 11,
                                          ),
                                          children: [
                                            pw.TextSpan(
                                              text:
                                                  '${user.docs[0]['userAddress']}',
                                              style: pw.TextStyle(
                                                letterSpacing: 1,
                                                fontWeight:
                                                    pw.FontWeight.normal,
                                                font: ttf,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            pw.Padding(
                                padding:
                                    const pw.EdgeInsets.symmetric(vertical: 8)),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      DateFormat('MMMM d, yyyy')
                                          .format(DateTime.now()),
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.bold,
                                        font: ttfbold,
                                      ),
                                    ),
                                    pw.Text(
                                      'Date Prepared',
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.normal,
                                        font: ttf,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            pw.Padding(
                                padding:
                                    const pw.EdgeInsets.symmetric(vertical: 2)),
                            pw.Container(
                              width: 2480,
                              child: pw.Column(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.RichText(
                                    text: pw.TextSpan(
                                      text: 'Loan Number:  ',
                                      style: pw.TextStyle(
                                        fontSize: 11,
                                        font: ttf,
                                      ),
                                      children: [
                                        pw.TextSpan(
                                          text: loan.docs[0]['loanId'],
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            font: ttfbold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  pw.RichText(
                                    text: pw.TextSpan(
                                      text: 'Type of Loan:  ',
                                      style: pw.TextStyle(
                                        fontSize: 11,
                                        font: ttf,
                                        fontWeight: pw.FontWeight.normal,
                                      ),
                                      children: [
                                        pw.TextSpan(
                                          text:
                                              '${loan.docs[0]['loanType']} Loan'
                                                  .toUpperCase(),
                                          style: pw.TextStyle(
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.bold,
                                            font: ttfbold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.RichText(
                                        text: pw.TextSpan(
                                          text: 'Loan Amount:',
                                          style: pw.TextStyle(
                                            fontSize: 11,
                                            font: ttf,
                                          ),
                                          children: [
                                            pw.TextSpan(
                                              text: '',
                                              style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                font: ttfbold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      pw.RichText(
                                        text: pw.TextSpan(
                                          text:
                                              'PHP ${NumberFormat('###,###,###,###.##').format(loan.docs[0]['loanAmount'])}',
                                          style: pw.TextStyle(
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.bold,
                                            font: ttfbold,
                                          ),
                                          children: [
                                            pw.TextSpan(
                                              text: '       Loan Term: ',
                                              style: pw.TextStyle(
                                                fontSize: 11,
                                                font: ttf,
                                                fontWeight:
                                                    pw.FontWeight.normal,
                                              ),
                                            ),
                                            pw.TextSpan(
                                              text:
                                                  '${NumberFormat('###,###,###,###').format(loan.docs[0]['noMonths'])} mos.',
                                              style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                font: ttfbold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          vertical: 2)),
                                  pw.Text(
                                    'OTHER CHARGES/DEDUCTION:',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      font: ttfbold,
                                      fontSize: 11,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(left: 15),
                                    child: pw.Container(
                                      width: 500,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.start,
                                        children: [
                                          pw.Column(
                                            mainAxisAlignment:
                                                pw.MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Text(
                                                'Paid-up Capital Share (${NumberFormat('###.##').format(coopdata.data()!['capitalFee'] * 100)}%):',
                                                style: pw.TextStyle(
                                                  font: ttf,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              pw.Text(
                                                'Savings Deposit (${NumberFormat('###.##').format(coopdata.data()!['savingsFee'] * 100)}%):',
                                                style: pw.TextStyle(
                                                  font: ttf,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              pw.Text(
                                                'Service Fee (${NumberFormat('###.##').format(coopdata.data()!['serviceFee'] * 100)}%):',
                                                style: pw.TextStyle(
                                                  font: ttf,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              pw.Text(
                                                'Insurance Premium:',
                                                style: pw.TextStyle(
                                                  font: ttf,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              pw.Padding(
                                                  padding: const pw
                                                          .EdgeInsets.symmetric(
                                                      vertical: 3)),
                                              pw.Text(
                                                'TOTAL CHARGES/DEDUCTION:',
                                                style: pw.TextStyle(
                                                  font: ttf,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                          pw.Padding(
                                              padding:
                                                  const pw.EdgeInsets.symmetric(
                                                      horizontal: 20)),
                                          pw.Column(
                                            mainAxisAlignment:
                                                pw.MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Text(
                                                'PHP ${NumberFormat('###,###,###,###.##').format(loan.docs[0]['capitalFee'])}',
                                                style: pw.TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                              pw.Text(
                                                'PHP ${NumberFormat('###,###,###,###.##').format(loan.docs[0]['savingsFee'])}',
                                                style: pw.TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                              pw.Text(
                                                'PHP ${NumberFormat('###,###,###,###.##').format(loan.docs[0]['serviceFee'])}',
                                                style: pw.TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                              pw.Text(
                                                'PHP ${NumberFormat('###,###,###,###.##').format(loan.docs[0]['insuranceFee'])}',
                                                style: pw.TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                              pw.Padding(
                                                  padding: const pw
                                                          .EdgeInsets.symmetric(
                                                      vertical: 3)),
                                              pw.Padding(
                                                padding:
                                                    const pw.EdgeInsets.only(
                                                        left: 70),
                                                child: pw.Text(
                                                  '(PHP ${NumberFormat('###,###,###,###.##').format(loan.docs[0]['totalDeduction'])})',
                                                  style: pw.TextStyle(
                                                    font: ttfbold,
                                                    fontSize: 12,
                                                    decoration: pw
                                                        .TextDecoration
                                                        .underline,
                                                    fontWeight:
                                                        pw.FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          vertical: 2)),
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        'NET PROCEEDS OF LOAN:',
                                        style: pw.TextStyle(
                                          fontSize: 11,
                                          fontWeight: pw.FontWeight.bold,
                                          font: ttfbold,
                                        ),
                                      ),
                                      pw.Padding(
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                  horizontal: 73)),
                                      pw.Text(
                                        'PHP ${NumberFormat('###,###,###,###.##').format(loan.docs[0]['netProceed'])}',
                                        style: pw.TextStyle(
                                          fontSize: 12,
                                          decoration:
                                              pw.TextDecoration.underline,
                                          decorationStyle:
                                              pw.TextDecorationStyle.double,
                                          fontWeight: pw.FontWeight.bold,
                                          font: ttfbold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          vertical: 5)),
                                  pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          vertical: 10)),
                                  pw.Column(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    children: [
                                      pw.Text(
                                        'SCHEDULE OF PAYMENTS',
                                        style: pw.TextStyle(
                                          fontSize: 12,
                                          fontWeight: pw.FontWeight.bold,
                                          font: ttfbold,
                                        ),
                                      ),
                                      pw.Padding(
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                  vertical: 5)),
                                      pw.Table(
                                        defaultColumnWidth:
                                            const pw.FixedColumnWidth(150.0),
                                        columnWidths: {
                                          0: const pw.FixedColumnWidth(50.0),
                                        },
                                        border: const pw.TableBorder(
                                            bottom: pw.BorderSide(
                                                style: pw.BorderStyle.dotted),
                                            top: pw.BorderSide(
                                                style: pw.BorderStyle.dotted)),
                                        children: [
                                          pw.TableRow(
                                            children: [
                                              pw.Row(
                                                mainAxisAlignment:
                                                    pw.MainAxisAlignment.start,
                                                children: [
                                                  pw.Text('  '),
                                                ],
                                              ),
                                              pw.Padding(
                                                padding:
                                                    const pw.EdgeInsets.only(
                                                  top: 4,
                                                  bottom: 4,
                                                ),
                                                child: pw.Row(
                                                  mainAxisAlignment: pw
                                                      .MainAxisAlignment.center,
                                                  children: [
                                                    pw.Row(
                                                      mainAxisAlignment: pw
                                                          .MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        pw.Text(
                                                          'Amount Payable',
                                                          style: pw.TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: pw
                                                                .FontWeight
                                                                .bold,
                                                            font: ttfbold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              pw.Padding(
                                                padding:
                                                    const pw.EdgeInsets.only(
                                                  top: 4,
                                                  bottom: 4,
                                                ),
                                                child: pw.Row(
                                                  mainAxisAlignment: pw
                                                      .MainAxisAlignment.center,
                                                  children: [
                                                    pw.Text(
                                                      'Monthly Interest',
                                                      style: pw.TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            pw.FontWeight.bold,
                                                        font: ttfbold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              pw.Padding(
                                                padding:
                                                    const pw.EdgeInsets.only(
                                                  top: 4,
                                                  bottom: 4,
                                                ),
                                                child: pw.Row(
                                                  mainAxisAlignment: pw
                                                      .MainAxisAlignment.center,
                                                  children: [
                                                    pw.Text(
                                                      'Monthly Payment',
                                                      style: pw.TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            pw.FontWeight.bold,
                                                        font: ttfbold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      tenure.size <= 15
                                          ? pw.Column(
                                              children: [
                                                pw.ListView.builder(
                                                  itemCount: tenure.size,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return pw.Table(
                                                      defaultColumnWidth: const pw
                                                              .FixedColumnWidth(
                                                          150.0),
                                                      columnWidths: {
                                                        0: const pw
                                                                .FixedColumnWidth(
                                                            50.0),
                                                      },
                                                      border:
                                                          const pw.TableBorder(
                                                        bottom: pw.BorderSide(
                                                            style: pw
                                                                .BorderStyle
                                                                .dotted),
                                                      ),
                                                      children: [
                                                        pw.TableRow(
                                                          children: [
                                                            pw.Row(
                                                              mainAxisAlignment:
                                                                  pw.MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                pw.Text((index +
                                                                        1)
                                                                    .toString()),
                                                              ],
                                                            ),
                                                            pw.Row(
                                                              mainAxisAlignment:
                                                                  pw.MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                pw.Text(
                                                                  'PHP ${NumberFormat('###,###,###,###,###.##').format(tenure.docs[index]['amountPayable'])}',
                                                                  style: pw
                                                                      .TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    font: ttf,
                                                                    fontWeight: pw
                                                                        .FontWeight
                                                                        .normal,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            pw.Row(
                                                              mainAxisAlignment:
                                                                  pw.MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                pw.Text(
                                                                  'PHP ${NumberFormat('###,###,###,###,###.##').format(tenure.docs[index]['monthInterest'])}',
                                                                  style: pw
                                                                      .TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    font: ttf,
                                                                    fontWeight: pw
                                                                        .FontWeight
                                                                        .normal,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            pw.Row(
                                                              mainAxisAlignment:
                                                                  pw.MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                pw.Text(
                                                                  'PHP ${NumberFormat('###,###,###,###,###.##').format(tenure.docs[index]['monthlyPay'])}',
                                                                  style: pw
                                                                      .TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    font: ttf,
                                                                    fontWeight: pw
                                                                        .FontWeight
                                                                        .normal,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                pw.Padding(
                                                    padding: const pw
                                                            .EdgeInsets.symmetric(
                                                        vertical: 2)),
                                                pw.Table(
                                                  defaultColumnWidth:
                                                      const pw.FixedColumnWidth(
                                                          150.0),
                                                  columnWidths: {
                                                    0: const pw
                                                        .FixedColumnWidth(50.0),
                                                  },
                                                  border: const pw.TableBorder(
                                                    bottom: pw.BorderSide(
                                                      style:
                                                          pw.BorderStyle.solid,
                                                    ),
                                                  ),
                                                  children: [
                                                    pw.TableRow(
                                                      children: [
                                                        pw.Row(
                                                          mainAxisAlignment: pw
                                                              .MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            pw.Text(''),
                                                          ],
                                                        ),
                                                        pw.Row(
                                                          mainAxisAlignment: pw
                                                              .MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            pw.Text(
                                                              'PHP ${NumberFormat('###,###,###,###,###.##').format(loan.docs[0]['loanAmount'])}',
                                                              style:
                                                                  pw.TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: pw
                                                                    .FontWeight
                                                                    .bold,
                                                                font: ttfbold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        pw.Row(
                                                          mainAxisAlignment: pw
                                                              .MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            pw.Text(
                                                              'PHP ${NumberFormat('###,###,###,###,###.##').format(loan.docs[0]['totalInterest'])}',
                                                              style:
                                                                  pw.TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: pw
                                                                    .FontWeight
                                                                    .bold,
                                                                font: ttfbold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        pw.Row(
                                                          mainAxisAlignment: pw
                                                              .MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            pw.Text(
                                                              'PHP ${NumberFormat('###,###,###,###,###.##').format(loan.docs[0]['totalPayment'])}',
                                                              style:
                                                                  pw.TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: pw
                                                                    .FontWeight
                                                                    .bold,
                                                                font: ttfbold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                pw.Padding(
                                                    padding: const pw
                                                            .EdgeInsets.symmetric(
                                                        vertical: 20)),
                                                pw.Row(
                                                  mainAxisAlignment:
                                                      pw.MainAxisAlignment.end,
                                                  children: [
                                                    pw.Column(
                                                      crossAxisAlignment: pw
                                                          .CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        pw.Text(
                                                          'Prepared By:',
                                                          style: pw.TextStyle(
                                                            fontSize: 10,
                                                            fontWeight: pw
                                                                .FontWeight
                                                                .normal,
                                                            font: ttf,
                                                          ),
                                                        ),
                                                        pw.Padding(
                                                            padding: const pw
                                                                    .EdgeInsets.symmetric(
                                                                vertical: 5)),
                                                        pw.Text(
                                                          '${staff.data()!['firstname']} ${staff.data()!['lastname']}',
                                                          style: pw.TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: pw
                                                                .FontWeight
                                                                .bold,
                                                            font: ttfbold,
                                                          ),
                                                        ),
                                                        pw.Text(
                                                          staff.data()!['role'],
                                                          style: pw.TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: pw
                                                                .FontWeight
                                                                .normal,
                                                            font: ttf,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : //if subra sa 15ang table
                                          pw.Column(
                                              children: [
                                                pw.ListView.builder(
                                                  itemCount: 15,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return pw.Table(
                                                      defaultColumnWidth: const pw
                                                              .FixedColumnWidth(
                                                          150.0),
                                                      columnWidths: {
                                                        0: const pw
                                                                .FixedColumnWidth(
                                                            50.0),
                                                      },
                                                      border:
                                                          const pw.TableBorder(
                                                        bottom: pw.BorderSide(
                                                            style: pw
                                                                .BorderStyle
                                                                .dotted),
                                                      ),
                                                      children: [
                                                        pw.TableRow(
                                                          children: [
                                                            pw.Row(
                                                              mainAxisAlignment:
                                                                  pw.MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                pw.Text((index +
                                                                        1)
                                                                    .toString()),
                                                              ],
                                                            ),
                                                            pw.Row(
                                                              mainAxisAlignment:
                                                                  pw.MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                pw.Text(
                                                                  'PHP ${NumberFormat('###,###,###,###,###.##').format(tenure.docs[index]['amountPayable'])}',
                                                                  style: pw
                                                                      .TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight: pw
                                                                        .FontWeight
                                                                        .normal,
                                                                    font: ttf,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            pw.Row(
                                                              mainAxisAlignment:
                                                                  pw.MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                pw.Text(
                                                                  'PHP ${NumberFormat('###,###,###,###,###.##').format(tenure.docs[index]['monthInterest'])}',
                                                                  style: pw
                                                                      .TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight: pw
                                                                        .FontWeight
                                                                        .normal,
                                                                    font: ttf,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            pw.Row(
                                                              mainAxisAlignment:
                                                                  pw.MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                pw.Text(
                                                                  'PHP ${NumberFormat('###,###,###,###,###.##').format(tenure.docs[index]['monthlyPay'])}',
                                                                  style: pw
                                                                      .TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight: pw
                                                                        .FontWeight
                                                                        .normal,
                                                                    font: ttf,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  if (tenure.size > 15) {
                    int ind = 14;
                    pdf.addPage(pw.Page(
                      build: (context) => pw.Container(
                        width: 2480,
                        height: 3508,
                        child: pw.Column(
                          children: [
                            pw.ListView.builder(
                              itemCount: tenure.size - 15,
                              itemBuilder: (context, index) {
                                ind++;
                                return pw.Table(
                                  defaultColumnWidth:
                                      const pw.FixedColumnWidth(150.0),
                                  columnWidths: {
                                    0: const pw.FixedColumnWidth(50.0),
                                  },
                                  border: const pw.TableBorder(
                                    bottom: pw.BorderSide(
                                        style: pw.BorderStyle.dotted),
                                  ),
                                  children: [
                                    pw.TableRow(
                                      children: [
                                        pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.start,
                                          children: [
                                            pw.Text((ind + 1).toString()),
                                          ],
                                        ),
                                        pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.center,
                                          children: [
                                            pw.Text(
                                              'PHP ${NumberFormat('###,###,###,###,###.##').format(tenure.docs[ind]['amountPayable'])}',
                                              style: pw.TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                    pw.FontWeight.normal,
                                                font: ttf,
                                              ),
                                            ),
                                          ],
                                        ),
                                        pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.center,
                                          children: [
                                            pw.Text(
                                              'PHP ${NumberFormat('###,###,###,###,###.##').format(tenure.docs[ind]['monthInterest'])}',
                                              style: pw.TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                    pw.FontWeight.normal,
                                                font: ttf,
                                              ),
                                            ),
                                          ],
                                        ),
                                        pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.center,
                                          children: [
                                            pw.Text(
                                              'PHP ${NumberFormat('###,###,###,###,###.##').format(tenure.docs[ind]['monthlyPay'])}',
                                              style: pw.TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                    pw.FontWeight.normal,
                                                font: ttf,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            pw.Padding(
                                padding:
                                    const pw.EdgeInsets.symmetric(vertical: 2)),
                            pw.Table(
                              defaultColumnWidth:
                                  const pw.FixedColumnWidth(150.0),
                              columnWidths: {
                                0: const pw.FixedColumnWidth(50.0),
                              },
                              border: const pw.TableBorder(
                                bottom: pw.BorderSide(
                                  style: pw.BorderStyle.solid,
                                ),
                              ),
                              children: [
                                pw.TableRow(
                                  children: [
                                    pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.start,
                                      children: [
                                        pw.Text(''),
                                      ],
                                    ),
                                    pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Text(
                                          'PHP ${NumberFormat('###,###,###,###,###.##').format(loan.docs[0]['loanAmount'])}',
                                          style: pw.TextStyle(
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.bold,
                                            font: ttfbold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Text(
                                          'PHP ${NumberFormat('###,###,###,###,###.##').format(loan.docs[0]['totalInterest'])}',
                                          style: pw.TextStyle(
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.bold,
                                            font: ttfbold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Text(
                                          'PHP ${NumberFormat('###,###,###,###,###.##').format(loan.docs[0]['totalPayment'])}',
                                          style: pw.TextStyle(
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.bold,
                                            font: ttfbold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(
                                    vertical: 20)),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      'Prepared By:',
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.normal,
                                      ),
                                    ),
                                    pw.Padding(
                                        padding: const pw.EdgeInsets.symmetric(
                                            vertical: 5)),
                                    pw.Text(
                                      '${staff.data()!['firstname']} ${staff.data()!['lastname']}',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.bold,
                                        font: ttfbold,
                                      ),
                                    ),
                                    pw.Text(
                                      staff.data()!['role'],
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ));
                  }
                  savePDF();
                });
              });
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: ElevatedButton(
        onPressed: () async {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: onWait),
          );
          await createPDF();
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: const BorderSide(
              width: 2,
              color: Colors.black,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Feather.printer,
                color: Colors.black,
                size: 18,
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
              Text(
                'Download PDF FILE'.toUpperCase(),
                style: const TextStyle(
                  fontFamily: FontNameDefault,
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class PdfMakerApi {
//   savePDF() async {
//     Uint8List pdfInBytes = await pdf.save();
//     final blob = html.Blob([pdfInBytes], 'application/pdf');
//     final url = html.Url.createObjectUrlFromBlob(blob);
//     anchor = html.document.createElement('a') as html.AnchorElement
//       ..href = url
//       ..style.display = 'none'
//       ..download = 'pdf.pdf';
//     html.document.body.children.add(anchor);
//   }

//   static Future<void> generate(LoanPdf loan) async {
//     final pdf = Document();
//     final font = await PdfGoogleFonts.nunitoExtraLight();
//     pdf.addPage(
//       pw.Page(
//         build: (context) {
//           return pw.Column(
//             children: [
//               pw.SizedBox(
//                 width: double.infinity,
//                 child: pw.FittedBox(
//                   child: pw.Text('Coop', style: pw.TextStyle( font: font)),
//                 ),
//               ),
//               pw.SizedBox(height: 20),
//               pw.Flexible(child: pw.FlutterLogo())
//             ],
//           );
//         },
//       ),
//     );

//     await PdfApi.saveDocument(
//         name: '${loan.info.loanId}_${loan.customer.lastname}', pdf: pdf);
//   }

//   static Widget buildHeader(LoanPdf loan) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(height: 1 * PdfPageFormat.cm),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Column(children: [
//               Text(loan.coop.name, style: TextStyle()),
//               Text(loan.coop.address),
//             ]),
//           ],
//         ),
//         SizedBox(height: 1 * PdfPageFormat.cm),
//       ],
//     );
//   }

//   static Widget buildInfo(LoanPdf loan) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("BORROWER'S NAME:  "),
//               Text(
//                 '${loan.customer.lastname}, ${loan.customer.firstname} ${loan.customer.middlename}',
//               ),
//             ],
//           ),
//           SizedBox(height: 0.5 * PdfPageFormat.cm),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("ADDRESS:  "),
//               Text(
//                 loan.customer.address,
//               ),
//             ],
//           ),
//         ],
//       );
// }
