const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendFCMOnDocumentAdded = functions.firestore
  .document("{collection}/{documentId}")
  .onCreate(async (snapshot, context) => {
  // 주제 구독 관련 코드 작성하셔야 합니다
    // Send the FCM message to the specified topic
    const topic = "all";
    const payload = {
      notification: {
        title: "New Message!",
        body: "New message added to Firestore",
      },
    };
    // 오류 방지를 위한 더미값
    try {
      await admin.messaging().sendToTopic(topic, payload);
      console.log("FCM message sent successfully");
    } catch (error) {
      console.error("Error sending FCM message:", error);
    }
  });