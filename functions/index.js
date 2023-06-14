const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions



const updateTenure = (updateTenureData => {
    return admin.firestore().collection('loans')
        .doc(updateTenureData.coopId + '_' + updateTenureData.payerId + '_' + updateTenureData.loanId)
        .collection('tenure')
        .doc(updateTenureData.tenureId)
        .update(
            {
                "payDate": updateTenureData.timestamp,
                "paidAmount": updateTenureData.amount,
                "payMethod": updateTenureData.paymentMethod,
                "status": updateTenureData.status
            }
        )
})


//update loan
const updateLoan = (updateLoanData => {

    return admin.firestore().collection('loans')
        .doc(updateLoanData.collectionID)
        .update(
            {
                "noMonthsPaid": admin.firestore.FieldValue.increment(1),
                "paidAmount": admin.firestore.FieldValue.increment(updateLoanData.paidAmount)
            });
})

//save changes in history
const createUserUpdate = (userUpdateHistoryData => {

    return admin.firestore().collection('users')
        .doc(userUpdateHistoryData.userId)
        .collection('acc_history')
        .add(userUpdateHistoryData)
        .then(doc => console.log('notification added', doc));
})


const updateAllFromCollection = async (userUpdateData) => {


    const collection = admin.firestore().collection(userUpdateData.collectionName)

    // const newDocumentBody = {
    //     profilePicUrl: userUpdateData.profilePicUrl
    // }

    collection.where('userId', '==', userUpdateData.userId).get().then(response => {
        let batch = admin.firestore().batch()
        response.docs.forEach((doc) => {
            const docRef = admin.firestore().collection(userUpdateData.collectionName).doc(doc.id)
            batch.update(docRef, "profilePicUrl", userUpdateData.profilePicUrl)
        })
        batch.commit().then(() => {
            console.log(`updated all Profile Picture inside ${userUpdateData.collectionName}`)
        })
    })
}

//create notification
const createUserNotif = (userNotif => {

    return admin.firestore().collection('users')
        .doc(userNotif.userId)
        .collection('user_notifications')
        .doc(userNotif.notifID)
        .set(userNotif)
        .then(doc => console.log('notification added', doc));
})
// const updateLoan = (updateLoanData => {
//     return admin.firestore().collection('loans')
//         .add(updateLoanData)
//         .then(doc => console.log('notification added', doc))

// })

exports.helloWorld = functions.https.onRequest((request, Response) => {
    functions.logger.info("Hello Logs!", { structuredDate: true });
    Response.send("Hello from firebase!");
});


exports.loanPaymentUpdated = functions.firestore
    .document('loans/{loanId}/payments/{paymentId}')
    .onUpdate(doc => {

        const payment = doc.after.data();

        const updateLoanData = {
            collectionID: payment.collectionID,
            paidAmount: payment.paidAmount

        }

        return updateLoan(updateLoanData);
    })

exports.loanReqUpdateNotif = functions.firestore
    .document('loans/{loanId}')
    .onUpdate(async (doc) => {

        const loanBef = doc.before.data();
        const loan = doc.after.data();
        var db = admin.firestore();
        const docRef = await db.collection('FCMToken').doc(loan.userId).get();
        const coopRef = await db.collection('coopInfo').doc(loan.coopId).get();
        if (loan.loanStatus !== loanBef.loanStatus) {

            if (docRef.exists) {
                const coopData = coopRef.data();
                const token = docRef.data();
                cNotifID = db.collection('users').doc(loan.userId).collection('user_notifications').doc().id;

                const userNotif = {
                    userId: loan.userId,
                    notifID: cNotifID,
                    notifTitle: coopData.coopName,
                    notifText: 'Your loan request is' + loan.loanStatus,
                    timestamp: admin.firestore.FieldValue.serverTimestamp(),
                    notifImageUrl: '',
                    iconUrl: coopData.profilePic,
                    status: 'unread'
                }

                const payload = {
                    token: token.fcmToken,
                    notification: {
                        title: loan.loanId,
                        body: "Your laon is now " + loan.loanStatus,
                    },
                    data: {
                        notifID: cNotifID,
                        priority: "high",
                        timeToLive: "60 * 60* 24",
                    },
                }

                admin.messaging().send(payload).then((response) => {
                    // Response is a message ID string.

                    console.log('Successfully sent message:', response);
                    return createUserNotif(userNotif);
                }).catch((error) => {
                    return { error: error.code };
                });
            };

        } else {

            return;
        }





    })

exports.subsUpdateNotif = functions.firestore
    .document('subscribers/{subsId}')
    .onUpdate(async (doc) => {
        const subsbefore = doc.before.data();
        const subs = doc.after.data();
        var db = admin.firestore();

        //Retrieve Token
        const docRef = await db.collection('FCMToken').doc(subs.userId).get();
        const coopRef = await db.collection('coopInfo').doc(subs.coopId).get();


        if (subsbefore.status !== subs.status) {
            if (docRef.exists) {
                const coopData = coopRef.data();
                const token = docRef.data();
                cNotifID = db.collection('users').doc(subs.userId).collection('user_notifications').doc().id;

                const userNotif = {
                    userId: subs.userId,
                    notifID: cNotifID,
                    notifTitle: coopData.coopName,
                    notifText: 'Your subscription request is' + subs.status,
                    timestamp: admin.firestore.FieldValue.serverTimestamp(),
                    notifImageUrl: '',
                    iconUrl: coopData.profilePic,
                    status: 'unread'
                }
                const payload = {
                    token: token.fcmToken,
                    notification: {
                        // title: subs.coopId + '_' + subs.userId,
                        title: coopData.coopName,
                        body: "Your subscription request is " + subs.status,
                    },
                    data: {
                        notifID: cNotifID,
                        priority: "high",
                        timeToLive: "60 * 60* 24",
                    },
                };
                admin.messaging().send(payload).then((response) => {
                    // Response is a message ID string.

                    console.log('Successfully sent message:', response);
                    return createUserNotif(userNotif);
                }).catch((error) => {
                    return { error: error.code };
                });
            }

        } else {

            return;
        }

    })

exports.userUpdateNotif = functions.firestore
    .document('users/{userId}')
    .onUpdate(async (doc) => {
        var numUpdate = 0;
        var updateString = '';
        const docBefore = doc.before.data();
        const docAfter = doc.after.data();

        if (docBefore.profilePicUrl !== docAfter.profilePicUrl) {
            var db = admin.firestore();

            //Retrieve Token
            const docRef = await db.collection('FCMToken').doc(docAfter.userUID).get();

            const token = docRef.data();

            const userUpdateHistoryData = {
                userId: docAfter.userUID,
                description: 'These are the changes in your profile picture.',
                timestamp: admin.firestore.FieldValue.serverTimestamp()
            }

            const userUpdateData = {
                userId: docAfter.userUID,
                collectionName: 'subscribers',
                profilePicUrl: docAfter.profilePicUrl
            }

            const payload = {
                token: token.fcmToken,
                notification: {
                    title: 'You updated your profile picture.',
                },
                data: {
                    priority: "high",
                    timeToLive: "60 * 60* 24",
                },
            };


            admin.messaging().send(payload).then((response) => {
                // Response is a message ID string.

                console.log('Successfully sent message:', response);
                // return { success: true };

                return updateAllFromCollection(userUpdateData).then(
                    createUserUpdate(userUpdateHistoryData)
                );
            }).catch((error) => {
                return { error: error.code };
            });
        }
        if (docBefore.firstName !== docAfter.firstName) {
            updateString += 'firstname: ${docAfter.firstName}, '
            numUpdate += 1;
        }
        if (docBefore.middleName !== docAfter.middleName) {
            updateString += 'middleName: ${docAfter.middleName}, '
            numUpdate += 1;
        }
        if (docBefore.lastName !== docAfter.lastName) {
            updateString += 'lastName: ${docAfter.lastName}, '
            numUpdate += 1;
        }
        if (docBefore.gender !== docAfter.gender) {
            updateString += 'gender: ${docAfter.gender}, '
            numUpdate += 1;
        }
        if (docBefore.birthDate !== docAfter.birthDate) {
            updateString += 'birthDate: ${docAfter.birthDate}, '
            numUpdate += 1;
        }
        if (docBefore.currentAddress !== docAfter.currentAddress) {
            updateString += 'currentAddress: ${docAfter.currentAddress}, '
            numUpdate += 1;
        }
        if (docBefore.email !== docAfter.email) {
            updateString += 'email: ${docAfter.email}, '
            numUpdate += 1;
        }
        if (docBefore.mobileNo !== docAfter.mobileNo) {
            updateString += 'mobileNo: ${docAfter.mobileNo}, '
            numUpdate += 1;
        }
        var db = admin.firestore();

        //Retrieve Token
        const docRef = await db.collection('FCMToken').doc(docAfter.userUID).get();

        const token = docRef.data();

        const userUpdateHistoryData = {
            userId: docAfter.userUID,
            description: 'These are the changes ' + updateString,
            timestamp: admin.firestore.FieldValue.serverTimestamp()
        }

        const payload = {
            token: token.fcmToken,
            notification: {
                title: 'You updated your profile information',
            },
            data: {
                priority: "high",
                timeToLive: "60 * 60* 24",
            },
        };


        admin.messaging().send(payload).then((response) => {
            // Response is a message ID string.

            console.log('Successfully sent message:', response);
            // return { success: true };

            return createUserUpdate(userUpdateHistoryData);
        }).catch((error) => {
            return { error: error.code };
        });

    })

exports.paymentOnCreateTriggers = functions.firestore
    .document('payment/{paymentId}')
    .onCreate(async (doc) => {

        const paymentData = doc.data();

        var amount = 0;

        var db = admin.firestore();

        //Retrieve Token
        const docRef = await db.collection('FCMToken').doc(paymentData.payerId).get();
        const coopRef = await db.collection('coopInfo').doc(paymentData.coopId).get();



        if (docRef.exists) {
            const coopData = coopRef.data();
            const token = docRef.data();
            amount = paymentData.amount
            cNotifID = db.collection('users').doc(paymentData.payerId).collection('user_notifications').doc().id;
            const userNotif = {
                userId: paymentData.payerId,
                notifID: cNotifID,
                notifTitle: coopData.coopName,
                notifText: 'Your payment applicable for the loan code: ' + paymentData.loanId + 'in the month of ' + paymentData.dueDate.toDate().getMonth() + paymentData.dueDate.toDate().getFullYear() + ' with total amount of ' + amount.toLocaleString('en-PH', { style: 'currency', currency: 'PHP', decimals: 2 }) + '. It will be process on 2 business days',
                timestamp: admin.firestore.FieldValue.serverTimestamp(),
                notifImageUrl: '',
                iconUrl: coopData.profilePic,
                status: 'unread'
            }
            const payload = {
                token: token.fcmToken,
                notification: {
                    // title: subs.coopId + '_' + subs.userId,
                    title: coopData.coopName,
                    body: 'Your payment applicable for the loan code: ' + paymentData.loanId,
                },
                data: {
                    notifID: cNotifID,
                    priority: "high",
                    timeToLive: "60 * 60* 24",
                },
            };
            admin.messaging().send(payload).then((response) => {
                // Response is a message ID string.

                console.log('Successfully sent message:', response);
                return createUserNotif(userNotif);
            }).catch((error) => {
                // return { error: error.code };
                return console.error(paymentData.coopId + error);
            });
        }



    })

exports.paymentOnUpdateTriggers = functions.firestore
    .document('payment/{paymentId}')
    .onUpdate(async (doc) => {
        const paymentData = doc.before.data();
        const newPaymentData = doc.after.data();

        var amount = 0;

        var db = admin.firestore();

        //Retrieve Token
        const docRef = await db.collection('FCMToken').doc(paymentData.payerId).get();
        const coopRef = await db.collection('coopInfo').doc(paymentData.coopId).get();

        if (paymentData.payStatus !== newPaymentData.payStatus) {
            return;
        }


        if (newPaymentData.payStatus == 'paid') {

            const updateTenureData = {
                coopId: newPaymentData.coopId,
                payerId: newPaymentData.payerId,
                loanId: newPaymentData.loanId,
                amount: newPaymentData.amount,
                paymentMethod: newPaymentData.paymentMethod,
                status: newPaymentData.status,
                timestamp: newPaymentData.timestamp
            }

            if (docRef.exists) {
                const coopData = coopRef.data();
                const token = docRef.data();
                amount = newPaymentData.amount
                cNotifID = db.collection('users').doc(newPaymentData.payerId).collection('user_notifications').doc().id;

                const userNotif = {
                    userId: newPaymentData.payerId,
                    notifID: cNotifID,
                    notifTitle: coopData.coopName,
                    notifText: 'Your payment in the month of ' + newPaymentData.timestamp.toDate().getMonth() + ' ' + paymentData.dueDate.toDate.getFullYear() + ' with total amount of ' + amount.toLocaleString('en_PH', { style: 'currency', currency: 'PHP' }) + ' has been accepted and updated your tenure',
                    timestamp: admin.firestore.FieldValue.serverTimestamp(),
                    notifImageUrl: '',
                    iconUrl: coopData.profilePic,
                    status: 'unread'
                }
                const payload = {
                    token: token.fcmToken,
                    notification: {
                        // title: subs.coopId + '_' + subs.userId,
                        title: coopData.coopName,
                        body: 'Your payment in the month of ' + newPaymentData.timestamp.toDate().getMonth() + ' ' + newPaymentData.timestamp.toDate().getFullYear() + ' has been accepted and updated your tenure',
                    },
                    data: {
                        notifID: cNotifID,
                        priority: "high",
                        timeToLive: "60 * 60* 24",
                    },
                };
                admin.messaging().send(payload).then((response) => {
                    // Response is a message ID string.

                    console.log('Successfully sent message:', response);
                    return createUserNotif(userNotif);
                }).catch((error) => {
                    return { error: error.code };
                });
            }


        } else if (newPaymentData.payStatus == 'partial') {

            const updateTenureData = {
                coopId: newPaymentData.coopId,
                payerId: newPaymentData.payerId,
                loanId: newPaymentData.loanId,
                amount: newPaymentData.amount,
                paymentMethod: newPaymentData.paymentMethod,
                status: newPaymentData.status,
                timestamp: newPaymentData.timestamp
            }

            if (docRef.exists) {
                const coopData = coopRef.data();
                const token = docRef.data();
                amount = newPaymentData.amount
                cNotifID = db.collection('users').doc(newPaymentData.payerId).collection('user_notifications').doc().id;

                const userNotif = {
                    userId: newPaymentData.payerId,
                    notifID: cNotifID,
                    notifTitle: coopData.coopName,
                    notifText: 'Your partial payment in the month of ' + newPaymentData.timestamp.toDate().getMonth() + ' ' + paymentData.dueDate.toDate.getFullYear() + ' with total amount of ' + amount.toLocaleString('en_PH', { style: 'currency', currency: 'PHP' }) + ' has been accepted and updated your tenure',
                    timestamp: admin.firestore.FieldValue.serverTimestamp(),
                    notifImageUrl: '',
                    iconUrl: coopData.profilePic,
                    status: 'unread'
                }
                const payload = {
                    token: token.fcmToken,
                    notification: {
                        // title: subs.coopId + '_' + subs.userId,
                        title: coopData.coopName,
                        body: 'Your partial payment in the month of ' + newPaymentData.timestamp.toDate().getMonth() + ' ' + paymentData.dueDate.toDate.getFullYear() + ' with total amount of ' + amount.toLocaleString('en_PH', { style: 'currency', currency: 'PHP' }) + ' has been accepted and updated your tenure',
                    },
                    data: {
                        notifID: cNotifID,
                        priority: "high",
                        timeToLive: "60 * 60* 24",
                    },
                };
                admin.messaging().send(payload).then((response) => {
                    // Response is a message ID string.

                    console.log('Successfully sent message:', response);
                    // return updateTenure(updateTenureData).then(createUserNotif(userNotif));
                    return createUserNotif(userNotif);
                }).catch((error) => {
                    return { error: error.code };
                });
            }

        }





    })

