import * as admin from 'firebase-admin';
import { EventParticipant } from './models/EventParticipant';
import { ParticipationToggleResponse } from './models/ParticipationToggleResponse';

// ------------------------
// Type Aliases
// ------------------------

type DocData = FirebaseFirestore.DocumentData;
type DocRef = FirebaseFirestore.DocumentReference<DocData>;
type WriteResult = FirebaseFirestore.WriteResult;


// ------------------------
// Exported Functions
// ------------------------

export const toggleEventParticipation = async (userId: string): Promise<ParticipationToggleResponse> => {
    const response: ParticipationToggleResponse = {
        eventId: "",
        userId: "",
    };

    const eventRef = await getEventRef();
    if (eventRef === null) {
        return response;
    }
    response.eventId = eventRef.id;

    const userRef = getUserRef(userId);
    if (userRef === null) {
        return response;
    }
    response.userId = userRef.id;

    const participantResult = await getParticipant(eventRef, userRef);

    // If no event participation record exists, create one to indicate the user
    // is participating in the event.
    if (participantResult.docs === null || participantResult.docs.length === 0) {
        await createParticipant(eventRef, userRef);
        response.isParticipating = true;
        return response;
    }

    // if record exists, delete it to indicate the user is not participating
    // in the event.
    const participant = participantResult.docs[0];
    await deleteParticipant(participant.id);
    response.isParticipating = false;

    return response;
};


// ------------------------
// Private Functions
// ------------------------

const createParticipant = async (eventRef: DocRef, userRef: DocRef) => {
    const newParticipant: EventParticipant = {
        event: eventRef,
        user: userRef,
    };

    await admin.firestore()
        .collection("event_participants")
        .add(newParticipant)
        .then(() => {
            console.log(`An new event participant was added. eventId: ${ eventRef.id } | userId: ${ userRef.id }`);
        })
        .catch((e) => {
            console.error("An error occurred when creating event.", e);
        });
};

const deleteParticipant = async (participantId: string): Promise<void> => {
    const deleteParticipantResult: WriteResult = await admin.firestore()
    .collection("event_participants")
    .doc(participantId)
    .delete();

    const deletedOn = deleteParticipantResult.writeTime.toDate().toString();
    const message = `Participant ${ participantId } deleted at ${ deletedOn }`;
    console.log(message);
};

const getCurrentEvent = async (): Promise<DocData|null> => {
    const getEventResult: DocData = await admin.firestore()
        .collection("events")
        .orderBy("date", "desc")
        .limit(1)
        .get();

    if (getEventResult.length === 0) {
        return null;
    }

    return getEventResult.docs[0];
};

const getEventRef = async ():Promise<DocRef|null> => {
    const eventData = await getCurrentEvent();
    if (eventData === null) {
        return null;
    }

    return admin.firestore().collection("events").doc(eventData.id);
};

const getParticipant = async (eventRef: DocRef, userRef: DocRef)
    : Promise<DocData> =>
    await admin.firestore()
        .collection("event_participants")
        .where("event", "==", eventRef)
        .where("user", "==", userRef)
        .limit(1)
        .get();

const getUserRef = (userId: string): DocRef|null =>
    admin.firestore().collection("users").doc(userId);
