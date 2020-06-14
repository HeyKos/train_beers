import * as admin from 'firebase-admin';
import { initializeNextEvent } from './create_next_event';

admin.initializeApp();
initializeNextEvent();