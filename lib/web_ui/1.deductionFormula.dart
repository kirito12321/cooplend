import 'package:ascoop/web_ui/global_var.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class DeductionFormula {
  double? forDedSavings(double amt, double rate) {
    globals.savingsFee = amt * rate;
    return globals.savingsFee;
  }

  double? forDedCapital(double amt, double rate) {
    globals.capitalFee = amt * rate;
    return globals.capitalFee;
  }

  double? forDedService(double amt, double rate) {
    globals.serviceFee = amt * rate;
    return globals.serviceFee;
  }

  double? forDedInsurance(
      double amt, double insurancefee, double rate, double noMonths) {
    globals.insuranceFee = (amt / insurancefee) * rate * noMonths;
    return globals.insuranceFee;
  }

  double? forTotDed(double savings, capital, service, insurance) {
    globals.totDeduction = savings + capital + service + insurance;
    return globals.totDeduction;
  }

  double? forNetProceed(double amt, totDed) {
    globals.netProceed = amt - totDed;
    return globals.netProceed;
  }
}
