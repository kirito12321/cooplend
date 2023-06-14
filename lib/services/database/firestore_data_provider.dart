import 'package:ascoop/services/auth/auth_service.dart';
import 'package:ascoop/services/database/data_account_history.dart';
import 'package:ascoop/services/database/data_capital_history.dart';
import 'package:ascoop/services/database/data_coop.dart' as datacoop;
import 'package:ascoop/services/database/data_coop_acc.dart';
import 'package:ascoop/services/database/data_fcm.dart';
import 'package:ascoop/services/database/data_loan.dart';
import 'package:ascoop/services/database/data_loan_payment_data.dart';
import 'package:ascoop/services/database/data_loan_tenure.dart';
import 'package:ascoop/services/database/data_loan_types.dart';
import 'package:ascoop/services/database/data_notification.dart';
import 'package:ascoop/services/database/data_payment.dart';
import 'package:ascoop/services/database/data_provider.dart';
import 'package:ascoop/services/database/data_subscription.dart';
import 'package:ascoop/services/database/data_user.dart' as dataUser;
import 'package:ascoop/services/database/data_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'data_coop.dart';
import 'data_user_notification.dart';

class FirestoreDataProvider implements DataProvider {
  //User
  @override
  Future<void> createUser({required dataUser.UserInfo user}) async {
    try {
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(user.userUID);
      final json = user.toJson();
      await docUser.set(json);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> updateInfo({required dataUser.UserInfo user}) async {
    try {
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(user.userUID);
      final json = user.toJson();
      await docUser.update(json);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<dataUser.UserInfo?> readUserData() async {
    final user = AuthService.firebase().currentUser;

    if (user != null) {
      final docUser = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      final snapshot = await docUser.get();

      if (snapshot.exists) {
        return dataUser.UserInfo.fromJson(snapshot.data()!);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<void> accHistory(
      {required String uid,
      required String actionTitle,
      required String actionText,
      required DateTime createdAt}) async {
    try {
      final docHistory = FirebaseFirestore.instance.collection('user').doc(uid);

      await docHistory.set(AccountHistory(
              id: uid,
              actionTitle: actionTitle,
              actionText: actionText,
              createdAt: createdAt)
          .toJson());
    } catch (e) {
      throw UnimplementedError();
    }
  }

  //Coop
  @override
  Stream<List<datacoop.CoopInfo>> readCoopsData() {
    final docCoops =
        FirebaseFirestore.instance.collection('coopInfo').snapshots();

    if (docCoops.first.toString() != '') {
      return docCoops.map((snapshot) => snapshot.docs
          .map((doc) => datacoop.CoopInfo.fromJson(doc.data()))
          .toList());
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<datacoop.CoopInfo?> readCoopData({required String coopID}) async {
    final docCoop =
        FirebaseFirestore.instance.collection('coopInfo').doc(coopID);
    final snapshot = await docCoop.get();

    if (snapshot.exists) {
      return datacoop.CoopInfo.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<void> subscribe({required DataSubscription subscribe}) async {
    try {
      final docSubs = FirebaseFirestore.instance
          .collection('subscribers')
          .doc('${subscribe.coopId}_${subscribe.userId}');
      final json = subscribe.toJson();
      await docSubs.set(json);
    } catch (e) {
      throw SubscribeException;
    }
  }

  @override
  Future<DataSubscription?> readSubscriptions(
      {required String coopID, required String userID}) async {
    final docSub = FirebaseFirestore.instance
        .collection('subscribers')
        .doc('${coopID}_$userID');

    final snapshot = await docSub.get();

    if (snapshot.exists) {
      return DataSubscription.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  //User notification
  @override
  Stream<List<DataNotification>> readNotifications() =>
      FirebaseFirestore.instance
          .collection('notifications')
          .where('authUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .map((snapshots) => snapshots.docs
              .map((doc) => DataNotification.fromJson(doc.data()))
              .toList());

  @override
  Future<void> createNotification({
    required String authUID,
    required String notifTitle,
    required String notifText,
    required String? notifImageUrl,
  }) async {
    try {
      final docNotif =
          FirebaseFirestore.instance.collection('notifications').doc();
      final json = DataNotification(
              id: docNotif.id,
              authUID: authUID,
              notifTitle: notifTitle,
              notifText: notifText,
              timestamp: Timestamp.now().toDate(),
              notifImageUrl: notifImageUrl)
          .toJson();
      await docNotif.set(json);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> createUserNotification(
      {required String userId,
      required String notifTitle,
      required String notifText,
      required String? notifImageUrl}) async {
    try {
      final docNotif =
          FirebaseFirestore.instance.collection('user_notifications').doc();
      final json = DataNotification(
              id: docNotif.id,
              authUID: userId,
              notifTitle: notifTitle,
              notifText: notifText,
              timestamp: Timestamp.now().toDate(),
              notifImageUrl: notifImageUrl)
          .toJson();
      await docNotif.set(json);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Stream<List<DataUserNotification>> readUserNotifications() =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('user_notifications')
          .where('status', isEqualTo: 'unread')
          .snapshots()
          .map((snapshots) => snapshots.docs
              .map((doc) => DataUserNotification.fromJson(doc.data()))
              .toList());
  //user loans
  @override
  Stream<List<DataLoan>> readAllLoans({required List<String> status}) =>
      FirebaseFirestore.instance
          .collection('loans')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('loanStatus', whereIn: status)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => DataLoan.fromJson(doc.data()))
              .toList());

  @override
  Future<void> createLoan({required DataLoan loan}) async {
    try {
      final loanData = FirebaseFirestore.instance
          .collection('loans')
          .doc('${loan.coopId}_${loan.userId}_${loan.loanId}');
      final json = loan.toJson();
      await loanData.set(json);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<DataLoan?> readLoan(
      {required String loanId,
      required String coopId,
      required String userId}) async {
    final docLoan = FirebaseFirestore.instance
        .collection('loans')
        .doc('${coopId}_${userId}_$loanId');

    final snapshot = await docLoan.get();

    if (snapshot.exists) {
      return DataLoan.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<void> createPayment({required DataPayment payment}) async {
    try {
      final payData = FirebaseFirestore.instance
          .collection('loans')
          .doc(payment.collectionID)
          .collection('payments')
          .doc('${payment.loanId}_${payment.invoiceNo}');
      final json = payment.toJson();
      await payData.set(json);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> createFCMToken({required String token}) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DataFCM fcmToken = DataFCM(userId: userId, fcmToken: token);

      final tokenData =
          FirebaseFirestore.instance.collection('FCMToken').doc(userId);

      final json = fcmToken.toJson();
      await tokenData.set(json);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> updateFCMToken({required String token}) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('FCMToken')
          .doc(userId)
          .update({"fcmToken": token});
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> checkFCMToken({required String token}) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    final checkFCM =
        FirebaseFirestore.instance.collection('FCMToken').doc(userId);

    final snapshot = await checkFCM.get();
    if (snapshot.exists) {
      return;
    } else {
      createFCMToken(token: token);
    }
  }

  @override
  Future<void> changeProfilePic({required String path}) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({"profilePicUrl": path});
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Stream<List<DataUserNotification>> checkUserUnreadNotif() =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('user_notifications')
          .where('status', isEqualTo: 'unread')
          .snapshots()
          .map((snapshots) => snapshots.docs
              .map((doc) => DataUserNotification.fromJson(doc.data()))
              .toList());

  @override
  Future<void> updateNotifStatus({required String notifID}) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('user_notifications')
          .doc(notifID)
          .update({'status': 'read'});
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<bool> checkLoanCode({required String loanId}) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('loans')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('loanId', isEqualTo: loanId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Stream<DataLoanTenure> readLoanTenure(
          {required String loanId,
          required String coopId,
          required String userId}) =>
      FirebaseFirestore.instance
          .collectionGroup('tenure')
          .where('loanId', isEqualTo: loanId)
          .where('status', isEqualTo: 'pending')
          .orderBy('dueDate')
          .limit(1)
          .snapshots()
          .map((snapshot) =>
              DataLoanTenure.fromJson(snapshot.docs.single.data()));
  // final docLoanTenure = FirebaseFirestore.instance
  //     .collection('loans')
  //     .doc('${coopId}_${userId}_$loanId')
  //     .collection('tenure')
  //     .doc('1');

  // final snapshot = await docLoanTenure.get();
  // if (snapshot.exists) {
  //   return DataLoanTenure.fromJson(snapshot.data()!);
  // } else {
  //   return null;
  // }

  @override
  Stream<List<DataLoanTenure>> readAllLoanTenure(
          {required String loanId,
          required String coopId,
          required String userId}) =>
      FirebaseFirestore.instance
          .collectionGroup('tenure')
          .where('loanId', isEqualTo: loanId)
          .orderBy('dueDate')
          .snapshots()
          .map((snapshots) => snapshots.docs
              .map((doc) => DataLoanTenure.fromJson(doc.data()))
              .toList());

  @override
  Future<void> updateLoanTenure(
      {required String loanId,
      required String coopId,
      required String userId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('loans')
          .doc('${coopId}_${userId}_$loanId')
          .collection('tenure')
          .doc('1')
          .update({'status': 'paid'});
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Stream<List<DataLoanTypes>> readLoanTypeAvailable({required String coopId}) =>
      FirebaseFirestore.instance
          .collection('coops')
          .doc(coopId)
          .collection('loanTypes')
          .where('status', isEqualTo: 'available')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => DataLoanTypes.fromJson(doc.data()))
              .toList());

  @override
  Future<double> getCapitalShare(
      {required String coopId, required String userId}) async {
    try {
      final coopData = FirebaseFirestore.instance
          .collection('subscribers')
          .doc('${coopId}_$userId')
          .collection('coopAccDetails')
          .doc('Data');

      final snapshot = await coopData.get();

      if (snapshot.exists) {
        DataCoopAcc acc = DataCoopAcc.fromJson(snapshot.data()!);
        return acc.capitalShare;
      } else {
        return 0;
      }
    } catch (e) {
      throw UnimplementedError;
    }
  }

  @override
  Future<double> getSavings(
      {required String coopId, required String userId}) async {
    // TODO: implement getSavings
    try {
      final coopData = FirebaseFirestore.instance
          .collection('subscribers')
          .doc('${coopId}_$userId')
          .collection('coopAccDetails')
          .doc('Data');

      final snapshot = await coopData.get();

      if (snapshot.exists) {
        DataCoopAcc acc = DataCoopAcc.fromJson(snapshot.data()!);
        return acc.savings;
      } else {
        return 0;
      }
    } catch (e) {
      throw UnimplementedError;
    }
  }

  @override
  Future<DataCoopAcc?> getCoopAcc(
      {required String coopId, required String userId}) async {
    // TODO: implement getCoopAcc
    try {
      final coopData = FirebaseFirestore.instance
          .collection('subscribers')
          .doc('${coopId}_$userId')
          .collection('coopAccDetails')
          .doc('Data');

      final snapshot = await coopData.get();

      if (snapshot.exists) {
        return DataCoopAcc.fromJson(snapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      throw UnimplementedError;
    }
  }

  @override
  Future<void> payLoan(
      {required DataLoanTenure tenure, required double amount}) async {
    // TODO: implement payLoan
    //DateFormat('yyyyMMddHHmmsss).format(DateTime.now());

    try {
      final paymentData = DataLoanPaymentData(
          amount: amount,
          coopId: tenure.coopId,
          dueDate: tenure.dueDate,
          invoiceNo:
              '${DateFormat('yyyyMMdd').format(DateTime.now())}${tenure.loanId.toUpperCase()}${tenure.month}',
          loanId: tenure.loanId,
          payStatus: 'processing',
          payerId: tenure.userId,
          paymentMethod: 'Online Payment',
          receivedBy: '',
          tenureId: tenure.month.toString(),
          timestamp: Timestamp.now().toDate(),
          monthlyPay: tenure.payment);

      final docPaymentData = FirebaseFirestore.instance
          .collection('payment')
          .doc('${tenure.coopId}_${tenure.userId}_${paymentData.invoiceNo}');
      final json = paymentData.toJson();
      await docPaymentData.set(json);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Stream<DataLoanPaymentData> checkLoanPayment(
          {required DataLoanTenure tenure}) =>
      FirebaseFirestore.instance
          .collection('payment')
          .where('coopId', isEqualTo: tenure.coopId)
          .where('payerId', isEqualTo: tenure.userId)
          .where('loanId', isEqualTo: tenure.loanId)
          .where('tenureId', isEqualTo: tenure.month.toString())
          .limit(1)
          .snapshots()
          .map((snapshot) =>
              DataLoanPaymentData.fromJson(snapshot.docs.single.data()));

  @override
  Future<CoopInfo?> checkCoopOnlinePay({required String coopId}) async {
    try {
      final docCoop =
          FirebaseFirestore.instance.collection('coopInfo').doc(coopId);
      final snapshot = await docCoop.get();

      if (snapshot.exists) {
        return CoopInfo.fromJson(snapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      throw UnimplementedError;
    }
  }

  @override
  Stream<List<DataSubscription>> readAllSubs() => FirebaseFirestore.instance
      .collection('subscribers')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('status', isEqualTo: 'verified')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => DataSubscription.fromJson(doc.data()))
          .toList());

  @override
  Stream<List<DataCapitalShareHistory>> getCapitalShareHistory(
          {required String coopId, required String userId}) =>
      FirebaseFirestore.instance
          .collection('subscribers')
          .doc('${coopId}_$userId')
          .collection('coopAccDetails')
          .doc('Data')
          .collection('shareLedger')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => DataCapitalShareHistory.fromJson(doc.data()))
              .toList());

  @override
  Stream<List<DataCapitalShareHistory>> getSavingsHistory(
          {required String coopId, required String userId}) =>
      FirebaseFirestore.instance
          .collection('subscribers')
          .doc('${coopId}_$userId')
          .collection('coopAccDetails')
          .doc('Data')
          .collection('savingsLedger')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => DataCapitalShareHistory.fromJson(doc.data()))
              .toList());
}
