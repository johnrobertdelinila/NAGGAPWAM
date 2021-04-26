const functions = require("firebase-functions");
const admin = require('firebase-admin');

const serviceAccount = 'naggapwamServiceAccountKey.json';
var defaultApp = admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://naggapwam-covid-tracing-default-rtdb.firebaseio.com"
});

const mMessaging = defaultApp.messaging();
const mFirestore = defaultApp.firestore();

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
