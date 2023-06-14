import 'package:ascoop/services/database/data_capital_history.dart';
import 'package:ascoop/services/database/data_coop.dart' as datacoop;
import 'package:ascoop/services/database/data_coop_acc.dart';

import 'package:ascoop/services/database/data_loan.dart';
import 'package:ascoop/services/database/data_loan_tenure.dart';
import 'package:ascoop/services/database/data_loan_types.dart';
import 'package:ascoop/services/database/data_notification.dart';
import 'package:ascoop/services/database/data_payment.dart';
import 'package:ascoop/services/database/data_subscription.dart';
import 'package:ascoop/services/database/data_user.dart' as datauser;

import 'data_coop.dart';
import 'data_loan_payment_data.dart';
import 'data_user_notification.dart';

abstract class DataProvider {
  //User

  Future<void> accHistory(
      {required String uid,
      required String actionTitle,
      required String actionText,
      required DateTime createdAt});
  Future<void> createUser({required datauser.UserInfo user});

  Future<void> updateInfo({required datauser.UserInfo user});

  Future<datauser.UserInfo?> readUserData();

  Future<void> createFCMToken({required String token});

  Future<void> updateFCMToken({required String token});

  Future<void> checkFCMToken({required String token});

  Future<void> changeProfilePic({required String path});

  //Coops
  Stream<List<datacoop.CoopInfo>> readCoopsData();

  Future<datacoop.CoopInfo?> readCoopData({required String coopID});

  Future<void> subscribe({required DataSubscription subscribe});

  Future<DataSubscription?> readSubscriptions(
      {required String coopID, required String userID});

  //employee notification
  Stream<List<DataNotification>> readNotifications();
  //User notification
  Stream<List<DataUserNotification>> readUserNotifications();

  Future<void> createNotification({
    required String authUID,
    required String notifTitle,
    required String notifText,
    required String? notifImageUrl,
  });

  Future<void> createUserNotification({
    required String userId,
    required String notifTitle,
    required String notifText,
    required String? notifImageUrl,
  });

  Future<void> updateNotifStatus({required String notifID});

  Stream<List<DataUserNotification>> checkUserUnreadNotif();
  //user loans

  Stream<List<DataLoan>> readAllLoans({required List<String> status});

  Future<DataLoan?> readLoan(
      {required String loanId, required String coopId, required String userId});

  Future<void> createLoan({required DataLoan loan});

  Future<void> createPayment({required DataPayment payment});

  Future<bool> checkLoanCode({required String loanId});

  Stream<DataLoanTenure> readLoanTenure(
      {required String loanId, required String coopId, required String userId});

  Stream<List<DataLoanTenure>> readAllLoanTenure(
      {required String loanId, required String coopId, required String userId});

  Future<void> updateLoanTenure(
      {required String loanId, required String coopId, required String userId});

  Stream<List<DataLoanTypes>> readLoanTypeAvailable({required String coopId});

  Future<double> getCapitalShare(
      {required String coopId, required String userId});

  Future<double> getSavings({required String coopId, required String userId});

  Future<DataCoopAcc?> getCoopAcc(
      {required String coopId, required String userId});

  Stream<List<DataCapitalShareHistory>> getCapitalShareHistory(
      {required String coopId, required String userId});

  Stream<List<DataCapitalShareHistory>> getSavingsHistory(
      {required String coopId, required String userId});

  Future<void> payLoan(
      {required DataLoanTenure tenure, required double amount});

  Stream<DataLoanPaymentData> checkLoanPayment(
      {required DataLoanTenure tenure});

  Future<CoopInfo?> checkCoopOnlinePay({required String coopId});

  Stream<List<DataSubscription>> readAllSubs();
}
