import * as admin from 'firebase-admin';

// Type aliases
type DocData = FirebaseFirestore.DocumentData;
type DocRef = FirebaseFirestore.DocumentReference<DocData>;
type QuerySnapshot = FirebaseFirestore.QuerySnapshot<DocData>;
type WriteResult = FirebaseFirestore.WriteResult;

// Interfaces
interface EventParticipant {
    event: DocRef,
    user: DocRef,
}

export const toggleEventParticipation = () => {
    // In order to test we're going to use hard-coded event and user data.
    // These will eventually be replaced with parameters, or API calls.
    // Get current event
    // TODO: Replace with API call
    const eventId: string = "SeH13v22sQ0CSJywrtm8";
    // TODO: Break this out into a separate function
    const eventRef: DocRef = admin.firestore().collection("events").doc(eventId);
    if (eventRef == null) {
        return;
    }
    // Get user
    // TODO: Replace this with a parameter
    const userId: string = "CK3P11pxZEPMBq0Z9yD6";
    // TODO: Break this out into a separate function
    const userRef: DocRef = admin.firestore()
        .collection("users")
        .doc(userId);
    if (userRef == null) {
        return;
    }
    // Get event participation for user
    // TODO: Break this out into a separate function
    admin.firestore()
        .collection("event_participants")
        .where("event", "==", eventRef)
        .where("user", "==", userRef)
        .limit(1)
        .get()
        .then((snapshot) => onGetParticipant(snapshot, eventRef, userRef));
};

const onGetParticipant = (snapshot: QuerySnapshot, eventRef: DocRef, userRef: DocRef) => {
    // If no event participation record exists create one to indicate the user is particpating in the event.
    if (snapshot.docs.length === 0) {
        // TODO: Break this out into a separate function
        const newParticipant: EventParticipant = {
            event: eventRef,
            user: userRef,
        };
        admin.firestore()
            .collection("event_participants")
            .add(newParticipant)
            .then(() => {
                console.log(`An new event participant was added. eventId: ${ eventRef.id } | userId: ${ userRef.id }`);
            })
            .catch((e) => {
                console.error("An error occurred when creating event.", e);
            });
        return;
    }

    // if record exists, delete it to indicate the user is not particpating in the event
    // TODO: Break this out into a separate function
    const participant = snapshot.docs[0];
    admin.firestore()
        .collection("event_participants")
        .doc(participant.id)
        .delete()
        .then((result) => onParticipantDeleted(result, participant.id));
};

const onParticipantDeleted = (result: WriteResult, participantId: string) => {
    const deletedOn = result.writeTime.toDate().toString();
    const message = `Participant ${ participantId } deleted at ${ deletedOn }`;
    console.log(message);
};
