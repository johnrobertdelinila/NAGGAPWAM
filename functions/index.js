const functions = require("firebase-functions");
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

const serviceAccount = 'naggapwamServiceAccountKey.json';
var defaultApp = admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://naggapwam-covid-tracing-default-rtdb.firebaseio.com"
});

const mMessaging = defaultApp.messaging();
const mFirestore = defaultApp.firestore();

const mailTransport = nodemailer.createTransport({
	service: 'gmail',
		auth: {
			user: 'francisian.doliente@lorma.edu',
			pass: 'humantorch'
	}
});
const APP_NAME = 'NAGGAPWAM COVID TRACKING';

const runtimeOpts = {
	timeoutSeconds: 150,
	memory: '256MB'
}

function sendNotificationDevice(fcmToken, title, body) {
	const payload = {
		notification: {
			title: title,
			body: body
		}
	};
	return mMessaging.sendToDevice(fcmToken, payload)
		.then(response => console.log('Successfully sent message ', response))
		.catch(err => console.log("Error sending message: ", err));
}

function sendAllNotification(exception) {
    return mFirestore.collection("fcmTokens").get()
        .then(snapshot => {
            if(!snapshot.empty) {
                const promises = [];
                snapshot.forEach(doc => {
                    if(doc.id != exception) {
                        const notification = {
                            fcmToken: doc.id,
                            title: "Exposure Notification",
                            timestamp: admin.firestore.FieldValue.serverTimestamp(),
                            body: "You\'ve been exposed in a patient with confirmed or probable COVID-19. Please be advised to contact City Health Office or have Self Quarantine at home."
                        };
                        const promise = mFirestore.collection("notifications").add(notification);
                        promises.push(promise);
                    }
                });
                return Promise.all(promises);
            }else {
                console.log("No fcm tokens found");
                return null;
            }
        })
        .catch(err => console.log(err.message));
}

function sendWelcomeEmail(email, displayName) {
	const mailOptions = {
		from: `${APP_NAME} <noreply@firebase.com>`,
		to: email,
	};
	mailOptions.subject = `Welcome to ${APP_NAME}!`;
	mailOptions.text = `Hi ${displayName || ''}! Welcome to ${APP_NAME}. Your registration is subject for verification. Please wait for an email confirming your registration. Do check your SPAM folder as it may be flagged as spam email.`;
	return mailTransport.sendMail(mailOptions).then(() => {
		return console.log('New welcome email sent to:', email);
	});
}

function verifiedScanningPointEmail(email, displayName, isVerified) {
	const mailOptions = {
		from: `${APP_NAME} <noreply@firebase.com>`,
		to: email,
	};
	mailOptions.subject = `Account Verification to ${APP_NAME}!`;
	if (isVerified === true) {
		mailOptions.text = `Congratulations ${displayName || ''}! Your account has been verified as Scanning Point. You can now login to your account to the Scanning Point.`;
	}else {
		mailOptions.text = `Sorry ${displayName || ''}! Your account has been rejected because you're not eligble to be Scanning Point.`;

	}
	return mailTransport.sendMail(mailOptions).then(() => {
		return console.log('Verified email sent to:', email);
	});
}

exports.sendWelcomeEmail = functions.region('asia-northeast1').auth.user().onCreate(user => {
	const email = user.email;
	return mFirestore.collection("scanning_points").doc(user.uid).get()
	    .then(doc => {
	        const displayName = doc.data().firstName || "null";
	        return sendWelcomeEmail(email, displayName);
	    })
	    .catch(err => console.log(err.message));
});

exports.sendVerifiedScanningPointEmail = functions.firestore.document('scanning_points/{scanning_point_id}')
    .onUpdate((change, context) => {
        const oldDocu = change.before.data();
        const newDocu = change.after.data();

        if(oldDocu.isVerified != newDocu.isVerified && newDocu.isVerified) {
            return verifiedScanningPointEmail(newDocu.username, newDocu.firstName, newDocu.isVerified);
        }else {
            return null;
        }

    });

exports.exposureNotificationDummy = functions.firestore.document('exposure/{id}')
    .onCreate((snap, context) => {
        const exposure = snap.data();
        return sendAllNotification(exposure.exception || null);
    });

exports.sendNotification = functions.firestore.document('notifications/{notificationId}')
	.onCreate((snap, context) => {
        const notification = snap.data();
        return sendNotificationDevice(notification.fcmToken, notification.title, notification.body);
	});

exports.resetHDF = functions.runWith(runtimeOpts).pubsub.schedule('59 23 * * 1-7')
  	.timeZone('Asia/Manila') // Users can choose timezone - default is America/Los_Angeles
  	.onRun(async (context) => {
  		console.log('This will be run every day at 11:59 PM Monday to Sunday');
  		return mFirestore.collection("hdf").get()
            .then(snapshot => {
                if(!snapshot.empty) {
                    const promises = [];
                    snapshot.forEach(doc => {
                        const promise = doc.ref.set({
                            isHaveBodyPain: false,
                            isHaveContact: false,
                            isHaveFever: false,
                            isHaveHeadache: false,
                            isHaveSoreThroat: false,
                            isHaveStayed: false,
                            isTravelledNCR: false,
                            isTravelledOutside: false,
                            travelledArea: null,
                            temperature: null
                        }, {merge: true});
                        promises.push(promise);
                    });
                    return Promise.all(promises);
                }else {
                    console.log("No Health declarations found.");
                    return null;
                }
            })
            .catch(err => console.log(err.message));
	});
