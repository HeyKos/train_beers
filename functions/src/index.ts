import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

/*
    Runs at 5:00pm, every Friday, every month to update the purchasedOn timestamp for the user
    that is currently set to purchase train beers.
*/
export const updatePurchasedOnForCurrentUser = functions.pubsub.schedule('0 0 17 ? * FRI *')
    .timeZone('America/New_York')
    .onRun((context) => {
        // Get the active user who has gone the longest without buying train beers.
        getCurrentBeerPurchaser()
            .then(onGetCurrentBeerPurchaserSuccess)
            .catch((e) => {
                console.error("An error occurred while getting the current purchaser user.", e);
            });
    }
);

/*
    Get the user in Firestore that is set to buy beer. This is based on the active user that has
    gone the longest time buying beer. 
*/
function getCurrentBeerPurchaser(): Promise<FirebaseFirestore.QuerySnapshot<FirebaseFirestore.DocumentData>> {
    return admin.firestore()
        .collection("users")
        .where("isActive", "==", true)
        .orderBy("purchasedOn", "asc")
        .limit(1)
        .get();
}

/*
    Calls a method to update the purchasedOn field when a user is successfully retrieved from Firestore.
*/
function onGetCurrentBeerPurchaserSuccess(snapshot: FirebaseFirestore.QuerySnapshot<FirebaseFirestore.DocumentData>) {
    if (snapshot.docs.length === 0) {
        console.error("No active users found!");
        return;
    }

    const user: FirebaseFirestore.DocumentData = snapshot.docs[0];
    // Update the user purchasedOn
    updateUserPurchasedOn(user);
}

/*
    Updates a user document in Firestore to set the purchasedOn field to now.
*/
function updateUserPurchasedOn(user: FirebaseFirestore.DocumentData) {
    admin.firestore()
        .collection("users")
        .doc(user.id)
        .update("purchasedOn", admin.firestore.Timestamp.now())
        .then((result:FirebaseFirestore.WriteResult) => {
            console.log(`Updated user: ${user.get("name")} (${user.id}) in: ${result.writeTime.seconds} (sec).`)
        })
        .catch((e) => {
            console.error("An error occurred when updating the document.", e);
        });
}