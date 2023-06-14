class FlatRate {
  final double loanAmount;
  final double paidAmount;
  final double totalPayment;
  final double interest;
  final int noMonths;
  final int noMonthsPaid;
  final double montlyPayment;

  FlatRate(
      {required this.loanAmount,
      required this.paidAmount,
      required this.totalPayment,
      required this.interest,
      required this.noMonths,
      required this.noMonthsPaid,
      required this.montlyPayment});

  double computeMonthlyPayment() {
    double monthlyPayment = computeTotalPayment() / noMonths;
    return monthlyPayment;
  }

  double computeTotalPayment() {
    double loanAmountRate = (interest * noMonths) * loanAmount;
    double total = loanAmount + loanAmountRate;

    return total;
  }
}
