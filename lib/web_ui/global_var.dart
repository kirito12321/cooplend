// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';

var logId = FirebaseAuth.instance.currentUser!.uid;
var staffId;
var myRole;

//coop's information
var coopId;
var coopName;
var coopAddress;
var coopEmail;
var coopProfile;

bool isSearchStaff = false;
bool isSearchSub = false;
bool isSearchLoan = false;
bool isSearchLoanCom = false;

//route's navigation headers
List sidenavsel = [true, false, false, false, false, false, false, false];
List headnavselsub = [true, false, false];
List headnavselloan = [true, false, false];
List headnavstaff = [true, false];
List headnavselpay = [true, false, false, false];
List headnavselnotif = [true, false];
List headnavseldeposit = [true, false];

//index for content navs indexedstack
int subIndex = 0;
int loanIndex = 0;
int staffIndex = 0;
int payIndex = 0;
int notifIndex = 0;
int depIndex = 0;

String profSubid = 'none';
bool subClicked = false;

//loan
double totBalance = 0;
double totInterest = 0;
double totPayment = 0;

//profile
List listSubProfHead = [true, false];

//loan request
double capitalFee = 0;
double serviceFee = 0;
double savingsFee = 0;
double insuranceFee = 0;
double netProceed = 0;
double totDeduction = 0;
