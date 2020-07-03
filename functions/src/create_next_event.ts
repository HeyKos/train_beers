import * as admin from 'firebase-admin';

// Type aliases
type DocData = FirebaseFirestore.DocumentData;
type DocRef = FirebaseFirestore.DocumentReference<DocData>;
type QuerySnapshot = FirebaseFirestore.QuerySnapshot<DocData>;
type Timestamp = FirebaseFirestore.Timestamp;
type WriteResult = FirebaseFirestore.WriteResult;

// Enums
enum EventStatus {
    notStarted,
    buyBeer,
    bringBeer,
    drinkBeer,
}

// Interfaces
interface Event {
    date: Timestamp,
    hostUser: DocRef,
    status: EventStatus,
}
export const initializeNextEvent = function () {
    getNextEventHost()
        .then(onGetNextEventHostSuccess)
        .catch((e) => {
            console.error("An error occurred while getting the next host user.", e);
        });
};

function getActiveUsers(): Promise<QuerySnapshot> {
    return admin.firestore()
        .collection("users")
        .where("isActive", "==", true)
        .get();
}

/*
    Get the user in Firestore that is set to buy beer. This is based on the active user that has
    gone the longest time buying beer. 
*/
function getNextEventHost(): Promise<QuerySnapshot> {
    return admin.firestore()
        .collection("users")
        .where("isActive", "==", true)
        .orderBy("lastHostedOn", "asc")
        .limit(1)
        .get();
}

/*
    Calls a method to update the purchasedOn field when a user is successfully retrieved from Firestore.
*/
function onGetNextEventHostSuccess(snapshot: QuerySnapshot) {
    if (snapshot.docs.length === 0) {
        console.error("No active users found!");
        return;
    }

    const user: DocData = snapshot.docs[0];

    // Update the user's lastHostedOnDate, and create the next event.
    updateUserLastHostedOn(user);
    createNextEvent(user.id);
}

/*
    Create the next event, and make the supplied user the host.
*/
function createNextEvent(userId: string) {
    const userRef = admin.firestore()
        .collection("users")
        .doc(userId);

    const newEvent: Event = {
        date: admin.firestore.Timestamp.now(),
        hostUser: userRef,
        status: EventStatus.notStarted,
    };

    admin.firestore()
        .collection("events")
        .add(newEvent)
        .then(onNextEventCreated)
        .catch((e) => {
            console.error("An error occurred when creating event.", e);
        });;
}

function onGetActiveUsers(snapshot: QuerySnapshot) {
    snapshot.docs.map((user) =>
        console.log("user name", user.get("name"))
    );
}

function onNextEventCreated(result: DocRef) {
    getActiveUsers()
        .then(onGetActiveUsers)
        .catch((e) =>
            console.error("An error occurred when getting active users.", e)
        );

}

/*
    Updates a user document in Firestore to set the lastHostedOm field to now.
*/
function updateUserLastHostedOn(user: DocData) {
    admin.firestore()
        .collection("users")
        .doc(user.id)
        .update("lastHostedOn", admin.firestore.Timestamp.now())
        .then((result: WriteResult) => {
            console.log(`Updated user: ${user.get("name")} (${user.id}) in: ${result.writeTime.seconds} (sec).`)
        })
        .catch((e) => {
            console.error("An error occurred when updating the document.", e);
        });
}