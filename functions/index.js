const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { logger } = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

// Initialize with explicit credentials
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  databaseURL: "https://echo-review-system.firebaseio.com"
});

const API_URL = "https://sentiment-api-535446153093.us-central1.run.app/predict";

exports.analyzeComment = onDocumentCreated(
  {
    document: "comments/{commentId}",
    region: "us-central1",
    timeoutSeconds: 120,
    memory: "512MB",
  },
  async (event) => {
    const snapshot = event.data;
    if (!snapshot.exists) {
      logger.log("Document doesn't exist");
      return;
    }

    const comment = snapshot.data();
    logger.log("Processing comment:", { commentId: event.params.commentId });

    // Skip if already analyzed or no text
    if (comment.sentiment || !comment.text) {
      logger.log("Skipping analysis: Already analyzed or no text");
      return;
    }

    try {
      logger.log("Analyzing comment text:", comment.text);
      const response = await axios.post(
        API_URL,
        { text: comment.text },
        { timeout: 10000 }
      );

      logger.log("Analysis result:", response.data);

      // Use firestore() with explicit credentials
      const db = admin.firestore();
      await db.doc(`comments/${event.params.commentId}`).update({
        sentiment: response.data.sentiment,
        analyzedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      logger.log("Document updated successfully");
    } catch (error) {
      logger.error("Analysis failed:", {
        message: error.message,
        stack: error.stack,
        response: error.response?.data,
      });

      try {
        // Fallback update attempt
        await admin.firestore().doc(`comments/${event.params.commentId}`).update({
          sentiment: "error",
          errorMessage: error.message.substring(0, 500),
        });
      } catch (updateError) {
        logger.error("Fallback update failed:", updateError);
      }
    }
  }
);