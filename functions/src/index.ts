import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { initializeNextEvent } from './create_next_event';
import { toggleEventParticipation } from './toggle_event_participation';

admin.initializeApp();

/*
    Runs at 6:00pm, every Friday, every week to update the purchasedOn timestamp for the user
    that is currently set to purchase train beers.
*/
export const scheduleNextEvent = functions.pubsub.schedule('0 0 18 ? * FRI *')
    .timeZone('America/New_York')
    .onRun((context) => initializeNextEvent);

/*
    Updates the purchasedOn timestamp for the user that is currently set to
    purchase train beers.
*/
export const scheduleNextEventOnDemand = functions.https.onRequest((req, res) => {
    initializeNextEvent();
    res.end();
});

/*
    Toggles a user's participation status for the current train beer event.
*/
export const toggleEventParticipationOnDemand = functions.https.onRequest((req, res) => {
    toggleEventParticipation();
    res.end();
});
