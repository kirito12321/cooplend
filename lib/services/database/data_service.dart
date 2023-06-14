import 'package:ascoop/services/database/data_capital_history.dart';
import 'package:ascoop/services/database/data_coop.dart';
import 'package:ascoop/services/database/data_coop_acc.dart';
import 'package:ascoop/services/database/data_loan.dart';
import 'package:ascoop/services/database/data_loan_tenure.dart';
import 'package:ascoop/services/database/data_loan_types.dart';
import 'package:ascoop/services/database/data_notification.dart';
import 'package:ascoop/services/database/data_payment.dart';
import 'package:ascoop/services/database/data_provider.dart';
import 'package:ascoop/services/database/data_subscription.dart';
import 'package:ascoop/services/database/data_user.dart' as dataUser;
import 'package:ascoop/services/database/firestore_data_provider.dart';

import 'data_loan_payment_data.dart';
import 'data_user_notification.dart';

class DataService implements DataProvider {
  final DataProvider provider;
  const DataService(this.provider);

  factory DataService.database() => DataService(FirestoreDataProvider());

  //User
  @override
  Future<void> accHistory(
          {required String uid,
          required String actionTitle,
          required String actionText,
          required DateTime createdAt}) =>
      provider.accHistory(
          uid: uid,
          actionTitle: actionTitle,
          actionText: actionText,
          createdAt: createdAt);

  @override
  Future<void> createUser({required dataUser.UserInfo user}) =>
      provider.createUser(user: user);
  @override
  Future<dataUser.UserInfo?> readUserData() => provider.readUserData();

  @override
  Future<void> updateInfo({required dataUser.UserInfo user}) =>
      provider.updateInfo(user: user);

  //Coop
  @override
  Stream<List<CoopInfo>> readCoopsData() => provider.readCoopsData();

  @override
  Future<CoopInfo?> readCoopData({required String coopID}) =>
      provider.readCoopData(coopID: coopID);

  @override
  Future<void> subscribe({required DataSubscription subscribe}) =>
      provider.subscribe(subscribe: subscribe);

  @override
  Future<DataSubscription?> readSubscriptions(
          {required String coopID, required String userID}) =>
      provider.readSubscriptions(coopID: coopID, userID: userID);

  //User Notification
  @override
  Stream<List<DataNotification>> readNotifications() =>
      provider.readNotifications();

  @override
  Future<void> createNotification(
          {required String authUID,
          required String notifTitle,
          required String notifText,
          required String? notifImageUrl}) =>
      provider.createNotification(
          authUID: authUID,
          notifTitle: notifTitle,
          notifText: notifText,
          notifImageUrl: notifImageUrl);

  //user Loans
  @override
  Stream<List<DataLoan>> readAllLoans({required List<String> status}) =>
      provider.readAllLoans(status: status);

  @override
  Future<void> createLoan({required DataLoan loan}) =>
      provider.createLoan(loan: loan);

  @override
  Future<DataLoan?> readLoan(
          {required String loanId,
          required String coopId,
          required String userId}) =>
      provider.readLoan(loanId: loanId, coopId: coopId, userId: userId);

  @override
  Future<void> createPayment({required DataPayment payment}) =>
      provider.createPayment(payment: payment);

  @override
  Future<void> createFCMToken({required String token}) =>
      provider.createFCMToken(token: token);

  @override
  Future<void> updateFCMToken({required String token}) =>
      provider.updateFCMToken(token: token);

  @override
  Future<void> checkFCMToken({required String token}) =>
      provider.checkFCMToken(token: token);

  @override
  Future<void> changeProfilePic({required String path}) =>
      provider.changeProfilePic(path: path);

  @override
  Future<void> createUserNotification(
          {required String userId,
          required String notifTitle,
          required String notifText,
          required String? notifImageUrl}) =>
      provider.createUserNotification(
          userId: userId,
          notifTitle: notifTitle,
          notifText: notifText,
          notifImageUrl: notifImageUrl);

  @override
  Stream<List<DataUserNotification>> readUserNotifications() =>
      provider.readUserNotifications();

  @override
  Stream<List<DataUserNotification>> checkUserUnreadNotif() =>
      provider.checkUserUnreadNotif();

  @override
  Future<void> updateNotifStatus({required String notifID}) =>
      provider.updateNotifStatus(notifID: notifID);

  @override
  Future<bool> checkLoanCode({required String loanId}) =>
      provider.checkLoanCode(loanId: loanId);

  @override
  Stream<DataLoanTenure> readLoanTenure(
          {required String loanId,
          required String coopId,
          required String userId}) =>
      provider.readLoanTenure(loanId: loanId, coopId: coopId, userId: userId);

  @override
  Stream<List<DataLoanTenure>> readAllLoanTenure(
          {required String loanId,
          required String coopId,
          required String userId}) =>
      provider.readAllLoanTenure(
          loanId: loanId, coopId: coopId, userId: userId);

  @override
  Future<void> updateLoanTenure(
          {required String loanId,
          required String coopId,
          required String userId}) =>
      provider.updateLoanTenure(loanId: loanId, coopId: coopId, userId: userId);

  @override
  Stream<List<DataLoanTypes>> readLoanTypeAvailable({required String coopId}) =>
      provider.readLoanTypeAvailable(coopId: coopId);

  @override
  Future<double> getCapitalShare(
          {required String coopId, required String userId}) =>
      provider.getCapitalShare(coopId: coopId, userId: userId);

  @override
  Future<double> getSavings({required String coopId, required String userId}) =>
      provider.getSavings(coopId: coopId, userId: userId);

  @override
  Future<DataCoopAcc?> getCoopAcc(
          {required String coopId, required String userId}) =>
      provider.getCoopAcc(coopId: coopId, userId: userId);

  @override
  Future<void> payLoan(
          {required DataLoanTenure tenure, required double amount}) =>
      provider.payLoan(tenure: tenure, amount: amount);

  @override
  Stream<DataLoanPaymentData> checkLoanPayment(
          {required DataLoanTenure tenure}) =>
      provider.checkLoanPayment(tenure: tenure);

  @override
  Future<CoopInfo?> checkCoopOnlinePay({required String coopId}) =>
      provider.checkCoopOnlinePay(coopId: coopId);

  @override
  Stream<List<DataSubscription>> readAllSubs() => provider.readAllSubs();

  @override
  Stream<List<DataCapitalShareHistory>> getCapitalShareHistory(
          {required String coopId, required String userId}) =>
      provider.getCapitalShareHistory(coopId: coopId, userId: userId);

  @override
  Stream<List<DataCapitalShareHistory>> getSavingsHistory(
          {required String coopId, required String userId}) =>
      provider.getSavingsHistory(coopId: coopId, userId: userId);
}
