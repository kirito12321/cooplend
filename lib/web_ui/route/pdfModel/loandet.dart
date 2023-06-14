import 'package:ascoop/web_ui/route/pdfModel/coop.dart';
import 'package:ascoop/web_ui/route/pdfModel/customer.dart';

class LoanPdf {
  final LoanInfo info;
  final Customer customer;
  final Coop coop;
  final List<TenureInfo> items;

  const LoanPdf({
    required this.info,
    required this.coop,
    required this.customer,
    required this.items,
  });
}

class LoanInfo {
  final String loanId;
  final double loanAmount;
  final DateTime activeDate;
  final String loantype;
  final int noMonths;
  final double totBal;
  final double totInterest;
  final double totPayment;

  const LoanInfo({
    required this.loanId,
    required this.loanAmount,
    required this.activeDate,
    required this.loantype,
    required this.noMonths,
    required this.totBal,
    required this.totInterest,
    required this.totPayment,
  });
}

class TenureInfo {
  final int month;
  final DateTime duedate;
  final double amountPay;
  final double monthInterest;
  final double monthlyPayment;

  const TenureInfo({
    required this.month,
    required this.duedate,
    required this.monthInterest,
    required this.monthlyPayment,
    required this.amountPay,
  });
}
