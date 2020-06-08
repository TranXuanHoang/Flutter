const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.newMessageSent = functions.firestore
    .document('chats/{chatRoomId}/messages/{messageId}')
    .onCreate((snap, context) => {
        // Get an object representing the document
        const message = snap.data();
        const chatRoomId = context.params.chatRoomId;
        const messageId = context.params.messageId;

        console.log(message);
        console.log(chatRoomId);
        console.log(messageId);

        // Send notification to a topic
        // Note that the topic name should math the following format
        // [a-zA-Z0-9-_.~%]{1,900}
        // and therefore cannot contain the forward slash '/'.
        // So instead, we can use the underscore '_' to separate
        // the URI sub-paths in the topic name.
        // See the following Stackoverflow link for more discusions about this issue
        // https://stackoverflow.com/questions/43058836/firebase-cloud-messaging-cannot-parse-topic-name
        //
        // For the object passed to the send() function, see
        // https://firebase.google.com/docs/cloud-messaging/http-server-ref
        // https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages#Message
        return admin.messaging().send({
            topic: `chats_${chatRoomId}`,
            notification: {
                title: message.username,
                body: message.text,
                imageUrl: message.profileImageUrl,
            },
            android: {
                notification: {
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                    sound: 'default',
                }
            },
            apns: {
                payload: {
                    aps: {
                        sound: 'default',
                    }
                }
            }
        });

        // Another way to send notifications to a topic
        // return admin.messaging().sendToTopic(`chats_${chatRoomId}`, {
        //     notification: {
        //         title: message.username,
        //         body: message.text,
        //         clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        //     }
        // });
    });