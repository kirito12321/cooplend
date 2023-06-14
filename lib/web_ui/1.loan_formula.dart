import 'package:ascoop/web_ui/global_var.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class LoanFormula {
  double? getMonthlyPayment(
      double amount, double interest, int noMonths, String coopid, int month) {
    if (coopid == '7JcfdmGdC4O5mmfYuCkPONQMPAy1') {
      if (month < 12) {
        var estMonthPay = ((amount * interest) + (amount / noMonths));
        return estMonthPay;
      } else {
        var estMonthPay =
            ((globals.totBalance * interest) + (amount / noMonths));
        return estMonthPay;
      }
    } else {
      if (month == 0) {
        var estMonthPay = ((amount * interest) + (amount / noMonths));
        return estMonthPay;
      } else {
        var estMonthPay =
            ((globals.totBalance * interest) + (amount / noMonths));
        return estMonthPay;
      }
    }
  }

  double? getAmountPayable(
      double amount, double interest, int noMonths, String coopid, int month) {
    if (coopid == '7JcfdmGdC4O5mmfYuCkPONQMPAy1') {
      var amountPayable = (amount / noMonths);

      return amountPayable;
    } else {
      var amountPayable = (amount / noMonths);

      return amountPayable;
    }
  }

  double? getMonthlyInterest(
      double amount, double interest, int noMonths, String coopid, int month) {
    if (coopid == '7JcfdmGdC4O5mmfYuCkPONQMPAy1') {
      if (month < 12) {
        var estMonthInterest = (amount * interest);
        globals.totBalance = globals.totBalance - (amount / noMonths);

        return estMonthInterest;
      } else {
        globals.totBalance = globals.totBalance - (amount / noMonths);
        var estMonthInterest = (globals.totBalance * interest);

        return estMonthInterest;
      }
    } else {
      if (month == 0) {
        var estMonthInterest = (amount * interest);
        globals.totBalance = globals.totBalance - (amount / noMonths);

        return estMonthInterest;
      } else {
        globals.totBalance = globals.totBalance - (amount / noMonths);
        var estMonthInterest = (globals.totBalance * interest);
        return estMonthInterest;
      }
    }
  }

  double? getBalance(
      double amount, double interest, int noMonths, String coopid, int month) {
    if (coopid == '7JcfdmGdC4O5mmfYuCkPONQMPAy1') {
      if (month == 0) {
        globals.totBalance = amount;
      }
      if (globals.totBalance == 0) {
        return 0;
      } else {
        return globals.totBalance - (amount / noMonths);
      }
    } else {
      if (month == 0) {
        globals.totBalance = amount;
      }
      if (globals.totBalance == 0) {
        return 0;
      } else {
        return globals.totBalance - (amount / noMonths);
      }
    }
  }
}
